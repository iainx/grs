//
//  AppDelegate.h
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDCommonAppDelegate.h"

@interface AppDelegate : SDCommonAppDelegate {
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	
	NSMutableArray *noteControllers;
}

- (IBAction) addNote:(id)sender;
- (IBAction) removeAllNotes:(id)sender;

@end
