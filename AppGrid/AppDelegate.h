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

#import "SDHowToWindowController.h"

#import "FsprgEmbeddedStoreController.h"
#import "FsprgEmbeddedStoreDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate, FsprgEmbeddedStoreDelegate>

@property IBOutlet NSWindow* storeWindow;
@property (weak) IBOutlet WebView* storeWebView;

@property NSStatusItem* statusItem;
@property IBOutlet NSMenu* statusBarMenu;

@property MyPrefsWindowController *myPrefsWindowController;
@property MyActor *myActor;

@property SDHowToWindowController* howToWindowController;

@property FsprgEmbeddedStoreController *embeddedStoreController;

@end
