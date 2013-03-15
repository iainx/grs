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


@interface SDStatusItemController ()

@property IBOutlet NSMenu *statusItemMenu;

@property NSStatusItem *statusItem;

@end


@implementation SDStatusItemController

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
	[self.statusItem setMenu:self.statusItemMenu];
	[self _updateTitle];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	[self _updateTitle];
}

- (void) iTunesUpdated {
	[self _updateTitle];
}

- (void) _updateTitle {
	NSString *newTitle = nil;
	
	NSArray *titleDisplayOptions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"titleOptions"];
	
	NSString *leftSeparator = [[NSUserDefaults standardUserDefaults] stringForKey:kSDSeparatorLeftKey];
	NSString *midSeparator = [[NSUserDefaults standardUserDefaults] stringForKey:kSDSeparatorMidKey];
	NSString *rightSeparator = [[NSUserDefaults standardUserDefaults] stringForKey:kSDSeparatorRightKey];
	
	if ([[iTunesProxy proxy] isRunning]) {
		NSMutableArray *stringsToDisplay = [NSMutableArray array];
		
		for (NSDictionary *titleOptions in titleDisplayOptions) {
			NSNumber *enabled = [titleOptions objectForKey:@"Enabled"];
			
			if ([enabled boolValue] == YES) {
				NSString *key = [titleOptions objectForKey:@"iTunesKey"];
				NSString *title = [[iTunesProxy proxy] valueForKey:key];
				if (title)
					[stringsToDisplay addObject:title];
			}
		}
		
		newTitle = [stringsToDisplay componentsJoinedByString:[NSString stringWithFormat:@"  %@  ", midSeparator ]];
		newTitle = [NSString stringWithFormat:@"%@  %@  %@", leftSeparator, newTitle, rightSeparator ];
	}
	else {
		newTitle = [NSString stringWithFormat:@"%@  TunesBar  %@", leftSeparator, rightSeparator ];
	}
	
	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"];
	NSFont *font = [NSFont systemFontOfSize:fontSize];
	
	NSColor *foreColor = [NSColor blackColor];
	if ([[iTunesProxy proxy] isPlaying] == NO)
		foreColor = [foreColor colorWithAlphaComponent:0.65];
	
	[SDTBStatusItemHelper setImagesWithTitle:newTitle font:font foreColor:foreColor onStatusItem:self.statusItem];
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
