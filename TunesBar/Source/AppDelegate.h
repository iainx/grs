//
//  AppDelegate.h
//  CocoaApp
//
//  Created by Steven Degutis on 7/23/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDCommonAppDelegate.h"

#import "SDStatusItemController.h"

@interface AppDelegate : SDCommonAppDelegate {
	SDStatusItemController *statusItemController;
}

@end
