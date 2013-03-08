//
//  SDStatusItemController.m
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDStatusItemController.h"

#import "DockSnapshot.h"
#import "SDDock.h"

@implementation SDStatusItemController

- (id) init {
	if (self = [super init]) {
		[NSBundle loadNibNamed:@"StatusItemMenu" owner:self];
	}
	return self;
}

- (void) dealloc {
	[statusIconMenu release];
	[super dealloc];
}

- (void) toggleStatusItemVisible:(BOOL)toVisible {
	if (toVisible) {
		if (statusItem)
			return;
		
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
		[statusItem setHighlightMode:YES];
		[statusItem setImage:[NSImage imageNamed:@"statusitemicon.png"]];
		[statusItem setMenu:statusIconMenu];
	}
	else {
		if (statusItem == nil)
			return;
		
		[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
		[statusItem release];
		statusItem = nil;
	}
}

- (void) toggleStatusItem {
	if (statusItem == nil)
		[self toggleStatusItemVisible:YES];
	else
		[self toggleStatusItemVisible:NO];
}

- (void)menuNeedsUpdate:(NSMenu *)menu {
	int startIndex = [statusIconMenu indexOfItem: snapshotsTitleMenuItem] + 1;
	int endIndex = [statusIconMenu indexOfItem: bottomDividerMenuItem];
	
	for (int i = 0; i < (endIndex - startIndex); i++)
		[statusIconMenu removeItemAtIndex:startIndex];
	
	NSArray *snapshots = [DockSnapshot orderedSnapshots];
	
	BOOL hideTitleStuff = ([snapshots count] == 0);
	[snapshotsTitleMenuItem setHidden:hideTitleStuff];
	[topDividerMenuItem setHidden:hideTitleStuff];
	
	for (DockSnapshot *snapshot in snapshots) {
		NSMenuItem *dockSetMenuItem = [[[NSMenuItem alloc] init] autorelease];
		
		[dockSetMenuItem setTitle:NSSTRINGF(@"   %@", snapshot.userDefinedName)];
		[dockSetMenuItem setRepresentedObject:snapshot];
		
		[dockSetMenuItem setTarget:self];
		[dockSetMenuItem setAction:@selector(chooseDockSetFromMenu:)];
		
		[statusIconMenu insertItem:dockSetMenuItem atIndex:(startIndex++)];
	}
}

- (void) chooseDockSetFromMenu:(NSMenuItem*)sender {
	[[SDDock dock] restoreSnapshot:[sender representedObject]];
}

@end
