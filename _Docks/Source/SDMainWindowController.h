//
//  SDMainWindowController.h
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDDock.h"

@interface SDMainWindowController : NSWindowController <SDDockDelegate> {
	IBOutlet NSArrayController *snapshotsArrayController;
	
	IBOutlet NSView *tableViewsContainerView;
	IBOutlet NSSlider *zoomSlider;
	
	BOOL inEditingMode;
	BOOL dockIsDead;
	
	BOOL windowWasShownFromGlobalShortcut;
}

@property BOOL inEditingMode;
@property BOOL dockIsDead;

@property BOOL windowWasShownFromGlobalShortcut;

- (IBAction) addSnapshot:(id)sender;
- (IBAction) restoreSnapshot:(id)sender;
- (IBAction) deleteSnapshot:(id)sender;
- (IBAction) openAppsFolder:(id)sender;

- (IBAction) zoomDown:(id)sender;
- (IBAction) zoomUp:(id)sender;

- (IBAction) openAppsFolder:(id)sender;

@end
