//
//  MyUniversalAccessHelper.m
//  AppGrid
//
//  Created by Steven Degutis on 3/1/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyUniversalAccessHelper.h"

@implementation MyUniversalAccessHelper

+ (BOOL) complainIfNeeded {
    Boolean enabled = AXAPIEnabled();
    
    if (!enabled) {
        [NSApp activateIgnoringOtherApps:YES];
        
        NSInteger result = NSRunAlertPanel(@"AppGrid Requires Universal Access",
                                           @"For AppGrid to function properly, enable access for assistive devices.\n\n"
                                           @"Enable this feature by checking \"Enable access for assistive devices\" in the Universal Access pane of System Preferences.",
                                           @"Open Universal Access",
                                           @"Dismiss",
                                           nil);
        
        if (result == NSAlertDefaultReturn) {
            NSString* src = @"tell application \"System Preferences\"\nactivate\nset current pane to pane \"com.apple.preference.universalaccess\"\nend tell";
            NSAppleScript *a = [[NSAppleScript alloc] initWithSource:src];
            [a executeAndReturnError:nil];
        }
        
        return YES;
    }
    
    return NO;
}

@end
