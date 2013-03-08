//
//  AppDelegate.h
//  CocoaApp
//
//  Created by Steven Degutis on 7/23/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDCommonAppDelegate.h"

#import "LCMainWindowController.h"

@interface LoginControlAppDelegate : SDCommonAppDelegate {
	LCMainWindowController *mainWindowController;
}

- (IBAction) showMainWindow:(id)sender;

@end
