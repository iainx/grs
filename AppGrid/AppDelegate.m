//
//  AppDelegate.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "MASShortcut+UserDefaults.h"
#import "MyShortcuts.h"

#import "MyWindow.h"

@implementation AppDelegate

+ (void) initialize {
    if (self == [AppDelegate self]) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
}

- (void) alignAllWindows {
    for (MyWindow* win in [MyWindow allWindows]) {
        [win moveToGridProps:[win gridProps]];
    }
}

- (void) moveLeft {
    MyWindow* win = [MyWindow focusedWindow];
    NSRect r = [win gridProps];
    r.origin.x = MAX(r.origin.x - 1, 0);
    [win moveToGridProps:r];
}

- (void) moveRight {
    MyWindow* win = [MyWindow focusedWindow];
    NSRect r = [win gridProps];
    r.origin.x = MIN(r.origin.x + 1, 2);
    [win moveToGridProps:r];
}

- (void) growRight {
    MyWindow* win = [MyWindow focusedWindow];
    NSRect r = [win gridProps];
    r.size.width = MIN(r.size.width + 1, 3 - r.origin.x);
    [win moveToGridProps:r];
}

- (void) shrinkRight {
    MyWindow* win = [MyWindow focusedWindow];
    NSRect r = [win gridProps];
    r.size.width = MAX(r.size.width - 1, 1);
    [win moveToGridProps:r];
}

- (void) shrinkToLower {
    MyWindow* win = [MyWindow focusedWindow];
    NSRect r = [win gridProps];
    r.origin.y = 1;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) shrinkToUpper {
    MyWindow* win = [MyWindow focusedWindow];
    NSRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) fillEntierColumn {
    MyWindow* win = [MyWindow focusedWindow];
    NSRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 2;
    [win moveToGridProps:r];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"accessibility enabled? %d", AXAPIEnabled());
    
    self.myPrefsWindowController = [[MyPrefsWindowController alloc] init];
    [self.myPrefsWindowController showWindow:self];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyAlignAllToGridShortcutKey handler:^{ [self alignAllWindows]; }];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyMoveLeftShortcutKey handler:^{ [self moveLeft]; }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyMoveRightShortcutKey handler:^{ [self moveRight]; }];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyGrowRightShortcutKey handler:^{ [self growRight]; }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyShrinkRightShortcutKey handler:^{ [self shrinkRight]; }];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyShrinkToLowerRowShortcutKey handler:^{ [self shrinkToLower]; }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyShrinkToUpperRowShortcutKey handler:^{ [self shrinkToUpper]; }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyFillEntireColumnShortcutKey handler:^{ [self fillEntierColumn]; }];
}

@end
