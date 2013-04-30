//
//  BMAppDelegate.m
//  BiggerMouse
//
//  Created by Steven on 4/12/13.
//  Copyright (c) 2013 Steven. All rights reserved.
//

#import "BMAppDelegate.h"

@implementation BMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask | NSLeftMouseDraggedMask | NSRightMouseDraggedMask | NSOtherMouseDraggedMask handler:^(NSEvent* e) {
            NSRect newFrame = [self.window frame];
            newFrame.origin = [NSEvent mouseLocation];
            newFrame.origin.y -= newFrame.size.height;
            
            newFrame.origin.x++;
            newFrame.origin.y--;
            
            [self.window setFrame:newFrame display:YES animate:NO];
        }];
    });
}

@end
