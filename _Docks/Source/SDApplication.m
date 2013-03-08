//
//  SDApplication.m
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDApplication.h"

@interface NSApplication (SDApplicationAdditions)
- (void) _dockDied;
- (void) _dockRestarted;
@end

@implementation SDApplication

- (void) _dockDied {
	[[NSNotificationCenter defaultCenter] postNotificationName:SDDockDiedNotification
														object:self];
	[super _dockDied];
}

- (void) _dockRestarted {
	[[NSNotificationCenter defaultCenter] postNotificationName:SDDockRestartedNotification
														object:self];
	[super _dockRestarted];
}

- (void) activateIgnoringOtherApps {
	[NSApp activateIgnoringOtherApps:YES];
}

@end
