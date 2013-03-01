//
//  AppDelegate.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"

#import "MyWindow.h"

@implementation AppDelegate

- (void) showWindowPosition {
    MyWindow* win = [MyWindow focusedWindow];
    
//    NSPoint p = [win topLeft];
//    
//    p.x += 10;
//    p.y -= 10;
//    
//    [win setTopLeft:p];
    
    NSSize p = [win size];
    
    p.width += 10;
    p.height += 10;
    
    [win setSize:p];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"accessibility enabled? %d", AXAPIEnabled());
    
    NSString *const kPreferenceGlobalShortcut = @"GlobalShortcut";
    self.shortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kPreferenceGlobalShortcut handler:^{
        [self showWindowPosition];
	}];
}

@end
