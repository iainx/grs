//
//  AppDelegate.h
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDCommonAppDelegate.h"
#import "SDSpacesBridge.h"

@class SDMainWindowController;
@class SDStatusItemController;

@interface AppDelegate : SDCommonAppDelegate <SDSpacesDelegate> {
	SDMainWindowController *mainWindowController;
	SDStatusItemController *statusItemController;
}

- (IBAction) takeSnapshot:(id)sender;
- (IBAction) showMainWindow:(id)sender;

- (IBAction) toggleInterfaceType:(id)sender;

@end
