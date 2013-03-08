//
//  AppDelegate.m
//  Simple Music
//
//  Created by Steven Degutis on 12/7/12.
//  Copyright (c) 2012 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "KNVolumeControl.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.mainWindowController = [[MainWindowController alloc] init];
    [self.mainWindowController showWindow:self];
}

- (IBAction) incSysVolume:(id)sender {
    float newVol = [KNVolumeControl volume] + 0.0625;
    [KNVolumeControl setVolume:MIN(newVol, 1.0)];
}

- (IBAction) decSysVolume:(id)sender {
    float newVol = [KNVolumeControl volume] - 0.0625;
    [KNVolumeControl setVolume:MAX(newVol, 0.0)];
}

@end
