//
//  SDMPAppDelegate.m
//  MailPingHelper
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDMPAppDelegate.h"

@implementation SDMPAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSWorkspace sharedWorkspace] launchApplication:@"Mail Ping"];
    [NSApp terminate:nil];
}

@end
