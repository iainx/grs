//
//  DLHAppDelegate.m
//  DeskLabelsHelper
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLHAppDelegate.h"

@implementation DLHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSWorkspace sharedWorkspace] launchApplication:@"DeskLabels"];
    [NSApp terminate:nil];
}

@end
