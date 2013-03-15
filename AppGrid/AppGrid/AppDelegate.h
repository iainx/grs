//
//  AppDelegate.h
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MyPrefsWindowController.h"
#import "MyActor.h"
#import "MyLicenseWindowController.h"
#import "MyFeedbackWindowController.h"

#import <Sparkle/Sparkle.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property NSStatusItem* statusItem;
@property IBOutlet NSMenu* statusBarMenu;

@property MyPrefsWindowController *myPrefsWindowController;
@property MyActor *myActor;
@property MyLicenseWindowController *myLicenseWindowController;
@property MyFeedbackWindowController* myFeedbackWindowController;

@property IBOutlet SUUpdater *updater;

@end
