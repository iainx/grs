//
//  SDTBAppDelegate.m
//  TunesBarHelper
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDTBAppDelegate.h"

@implementation SDTBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSWorkspace sharedWorkspace] launchApplication:@"TunesBar"];
    [NSApp terminate:nil];
}

@end
