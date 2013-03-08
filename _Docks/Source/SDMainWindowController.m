//
//  SDMainWindowController.m
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDMainWindowController.h"

#import "SDModelController.h"

#import "DockSnapshot.h"

#import "SDApplication.h"

@implementation SDMainWindowController

@synthesize inEditingMode;
@synthesize dockIsDead;

@synthesize windowWasShownFromGlobalShortcut;

- (SDModelController*) modelController {
	return SDSharedModelController;
}

- (id) init {
	if (self = [super initWithWindowNibName:@"MainWindow"]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillResignActive:)
													 name:NSApplicationWillResignActiveNotification
												   object:NSApp];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dockDied:)
													 name:SDDockDiedNotification
												   object:NSApp];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dockRestarted:)
													 name:SDDockRestartedNotification
												   object:NSApp];
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void) applicationWillResignActive:(NSNotification*)notification {
	self.windowWasShownFromGlobalShortcut = NO;
}

- (void) dockDied:(NSNotification*)notification {
	self.dockIsDead = YES;
}

- (void) dockRestarted:(NSNotification*)notification {
	self.dockIsDead = NO;
}

- (void) awakeFromNib {
}

- (void) windowDidLoad {
	[[self window] setContentBorderThickness:34.0 forEdge:NSMinYEdge];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
	if (window == [self window])
		return [[SDSharedModelController managedObjectContext] undoManager];
	else
		return nil;
}

- (IBAction) addSnapshot:(id)sender {
	if ([SDDefaults boolForKey:@"playCameraSound"])
		[[NSSound soundNamed:@"ShutterSound.wav"] play];
	
	[[SDDock dock] takeSnapshotWithDelegate:self];
}

- (IBAction) restoreSnapshot:(id)sender {
	DockSnapshot *snapshot = [[snapshotsArrayController selectedObjects] lastObject];
	if (snapshot) {
		[[SDDock dock] restoreSnapshot:snapshot];
		
		if (windowWasShownFromGlobalShortcut)
			[NSApp hide:self];
	}
}

- (IBAction) delete:(id)sender {
	[self deleteSnapshot:sender];
}

- (IBAction) deleteSnapshot:(id)sender {
	DockSnapshot *snapshot = [[snapshotsArrayController selectedObjects] lastObject];
	if (snapshot) {
		[[snapshot managedObjectContext] deleteObject:snapshot];
		
		int i = 0;
		for (DockSnapshot *snapshot in [DockSnapshot orderedSnapshots])
			snapshot.index = NSINT(i++);
	}
}

- (IBAction) openAppsFolder:(id)sender {
	[[NSWorkspace sharedWorkspace] openFile:@"/Applications" withApplication:@"Finder"];
}

- (void) dock:(SDDock*)theDock tookSnapshotSuccessfully:(DockSnapshot*)snapshot {
	[snapshotsArrayController setSelectedObjects:[NSArray arrayWithObject:snapshot]];
}

- (IBAction) zoomDown:(id)sender {
	[SDDefaults setFloat:[zoomSlider minValue] forKey:@"rowHeight"];
}

- (IBAction) zoomUp:(id)sender {
	[SDDefaults setFloat:[zoomSlider maxValue] forKey:@"rowHeight"];
}

@end
