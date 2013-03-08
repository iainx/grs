//
//  AppDelegate.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MyAccountsWindowController.h"

#import "EmailChecker.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate, UnreadEmailsColorizer>

@property NSStatusItem* statusItem;
@property (weak) IBOutlet NSMenu* statusMenu;

@property NSTimer* checkTimer;

@property MyAccountsWindowController *myAccountsWindowController;

@property EmailChecker* emailChecker;

@property BOOL someUnread;

@end
