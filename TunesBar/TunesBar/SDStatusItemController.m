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
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[self.statusItem setHighlightMode:YES];
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
    iTunesProxy *iProxy = [iTunesProxy proxy];
    NSView *hudView;
    
    if ([iProxy isRunning]) {
        hudView = _hudView;
    } else {
        hudView = _startHudView;
    }

    _attachedWindow = [[MAAttachedWindow alloc] initWithView:hudView
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
    
    if (![iProxy isRunning]) {
        return;
    }
    
    if ([iProxy isPlaying]) {
        [_playButton setState:1];
    } else {
        [_playButton setState:0];
    }
    [_imageView setImage:[iProxy coverArtwork]];
    [_titleField setStringValue:[iProxy trackName]];
    [_artistField setStringValue:[iProxy trackArtist]];
    [_albumField setStringValue:[iProxy trackAlbum]];
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
		
        NSArray *titleDisplayOptions = @[@"trackName", @"trackAlbum", @"trackArtist"];
        
		for (NSString *key in titleDisplayOptions) {
			
            NSString *title = [[iTunesProxy proxy] valueForKey:key];
            if (title) {
                [_displayStrings addObject:title];
			}
		}
	} else {
        _displayStrings = [NSMutableArray arrayWithObject:@"Nothing Playing"];
        [_displayTimer invalidate];
        _displayTimer = nil;
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

- (IBAction)startiTunes:(id)sender {
    [[NSWorkspace sharedWorkspace] launchApplication:@"/Applications/iTunes.app"];
    if (_attachedWindow) {
        [[_attachedWindow parentWindow] removeChildWindow:_attachedWindow];
        _attachedWindow = nil;
        
        [self resetTimer];
        return;
    }
}
@end
