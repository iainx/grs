//
//  AppDelegate.m
//  MailPingHelper
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    BOOL alreadyRunning = NO;
    BOOL isActive = NO;
    NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in running) {
        if ([[app bundleIdentifier] isEqualToString:@"org.degutis.Mail-Ping"]) {
            alreadyRunning = YES;
            isActive = [app isActive];
            break;
        }
    }
    
    if (!alreadyRunning || !isActive)
        [[NSWorkspace sharedWorkspace] launchApplication:@"Mail Ping"];
    
    [NSApp terminate:nil];
}

@end
