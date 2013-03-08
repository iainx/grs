//
//  AppDelegate.m
//  Timer
//
//  Created by Steven Degutis on 2/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "TimerWindowController.h"

@implementation AppDelegate

- (id) init {
    if ((self = [super init])) {
        self.windowControllers = [NSMutableArray array];
    }
    return self;
}

- (BOOL) applicationOpenUntitledFile:(NSApplication *)sender {
    [self showNewTimer];
    return YES;
}

- (void) windowDidCloseForWindowController:(id)wc {
    [self.windowControllers removeObject:wc];
}

- (void) showNewTimer {
    TimerWindowController* wc = [[TimerWindowController alloc] init];
    wc.closeDelegate = self;
    [wc showWindow:self];
    
    [self.windowControllers addObject:wc];
}

- (IBAction) newDocument:(id)sender {
    [self showNewTimer];
}

@end
