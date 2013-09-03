//
//  SDMainWindowController.m
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDStatusItemController.h"

#import "DefaultsKeys.h"
#import "SDTBStatusItemHelper.h"
#import "MAAttachedWindow.h"

@interface SDStatusItemController ()

@property IBOutlet NSMenu *statusItemMenu;

@property NSStatusItem *statusItem;

@end


@implementation SDStatusItemController {
    NSMutableArray *_displayStrings;
    NSTimer *_displayTimer;
    NSUInteger _displayIndex;
    MAAttachedWindow *_attachedWindow;
}

static const NSTimeInterval INFO_CHANGE_DELAY = 10;
- (void) setupStatusItem {
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:kSDSeparatorLeftKey
                                               options:0
                                               context:NULL];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:kSDSeparatorMidKey
                                               options:0
                                               context:NULL];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:kSDSeparatorRightKey
                                               options:0
                                               context:NULL];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"titleOptions"
                                               options:0
                                               context:NULL];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"fontSize"
                                               options:0
                                               context:NULL];
    
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[self.statusItem setHighlightMode:YES];
	//[self.statusItem setMenu:self.statusItemMenu];
    [self.statusItem setAction:@selector(showInfoPanel:)];
    [self.statusItem setTarget:self];
    
    [self _updateTitle];
}

- (void)showInfoPanel:(id)sender
{
    NSEvent *event = [NSApp currentEvent];
    
    if (_attachedWindow) {
        [[event window] removeChildWindow:_attachedWindow];
        _attachedWindow = nil;
        
        [self resetTimer];
        return;
    }
    
    NSRect frame = [[event window] frame];
    
    _attachedWindow = [[MAAttachedWindow alloc] initWithView:_hubView
                                                      attachedToPoint:NSMakePoint(NSMidX(frame), frame.origin.y)
                                                               onSide:MAPositionAutomatic];
    [[event window] addChildWindow:_attachedWindow ordered:NSWindowAbove];
    
    [_displayTimer invalidate];
    _displayTimer = nil;
    
    [self updateHudInfo];
}

- (void)updateHudInfo
{
    iTunesProxy *iProxy = [iTunesProxy proxy];
    
    [_imageView setImage:[iProxy coverArtwork]];
    [_titleField setStringValue:[iProxy trackName]];
    [_artistField setStringValue:[iProxy trackArtist]];
    [_albumField setStringValue:[iProxy trackAlbum]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	[self _updateTitle];
    if (_attachedWindow) {
        [self updateHudInfo];
    }
}

- (void) iTunesUpdated {
	[self _updateTitle];
    if (_attachedWindow) {
        [self updateHudInfo];
    }
}

- (void) _updateTitle {
	if ([[iTunesProxy proxy] isRunning]) {
		_displayStrings = [NSMutableArray array];
		
        NSArray *titleDisplayOptions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"titleOptions"];
        
		for (NSDictionary *titleOptions in titleDisplayOptions) {
			NSNumber *enabled = [titleOptions objectForKey:@"Enabled"];
			
			if ([enabled boolValue] == YES) {
				NSString *key = [titleOptions objectForKey:@"iTunesKey"];
				NSString *title = [[iTunesProxy proxy] valueForKey:key];
				if (title) {
					[_displayStrings addObject:title];
                }
			}
		}
	} else {
        _displayStrings = nil;
        [_displayTimer invalidate];
        _displayTimer = nil;
        return;
	}
	   
    _displayIndex = -1;
    [self changeDisplayString:nil];
    
    if (_attachedWindow == nil) {
        [self resetTimer];
    }
}

- (void)changeDisplayString:(NSTimer *)timer
{
    if ([_displayStrings count] == 0) {
        return;
    }
    
    _displayIndex++;
    if (_displayIndex >= [_displayStrings count]) {
        _displayIndex = 0;
    }
    
    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"];
	NSFont *font = [NSFont systemFontOfSize:fontSize];
	
	NSColor *foreColor = [NSColor blackColor];
	if ([[iTunesProxy proxy] isPlaying] == NO) {
		foreColor = [foreColor colorWithAlphaComponent:0.65];
    }
	
	[SDTBStatusItemHelper setImagesWithTitle:_displayStrings[_displayIndex]
                                        font:font
                                   foreColor:foreColor
                                onStatusItem:self.statusItem];
}

- (void)resetTimer
{
    [_displayTimer invalidate];
    _displayTimer = [NSTimer scheduledTimerWithTimeInterval:INFO_CHANGE_DELAY target:self
                                                   selector:@selector(changeDisplayString:)
                                                   userInfo:self
                                                    repeats:YES];
}

- (IBAction) playPause:(id)sender {
	[[[iTunesProxy proxy] iTunes] playpause];
}

- (IBAction) nextTrack:(id)sender {
	[[[iTunesProxy proxy] iTunes] nextTrack];
}

- (IBAction) previousTrack:(id)sender {
	[[[iTunesProxy proxy] iTunes] previousTrack];
}

// MARK: -
// MARK: User Interface

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(playPause:)) {
		NSString *title = @"Play";
		
		if ([[iTunesProxy proxy] isPlaying] == YES)
			title = @"Pause";
		
		[menuItem setTitle:title];
		[menuItem setImage:[NSImage imageNamed:title]];
	}
	return YES;
}

@end
