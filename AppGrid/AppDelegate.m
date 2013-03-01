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

dispatch_block_t MyDoOnMainThread(dispatch_block_t blk) {
    return ^{ dispatch_async(dispatch_get_main_queue(), blk); };
}

@implementation AppDelegate

+ (void) initialize {
    if (self == [AppDelegate self]) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
}

- (void) alignAllWindows {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    for (MyWindow* win in [MyWindow allWindows]) {
        [win moveToGridProps:[win gridProps]];
    }
}

- (void) moveLeft {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.x = MAX(r.origin.x - 1, 0);
    [win moveToGridProps:r];
}

- (void) moveRight {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.x = MIN(r.origin.x + 1, 2);
//    CGRect r = CGRectMake(0, 0, 1, 1);
    [win moveToGridProps:r];
}

- (void) growRight {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MIN(r.size.width + 1, 3 - r.origin.x);
    [win moveToGridProps:r];
}

- (void) shrinkRight {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MAX(r.size.width - 1, 1);
    [win moveToGridProps:r];
}

- (void) shrinkToLower {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 1;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) shrinkToUpper {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) fillEntierColumn {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return;
    
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 2;
    [win moveToGridProps:r];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"accessibility enabled? %d", AXAPIEnabled());
    
    self.myPrefsWindowController = [[MyPrefsWindowController alloc] init];
    [self.myPrefsWindowController showWindow:self];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyAlignAllToGridShortcutKey handler:MyDoOnMainThread(^{ [self alignAllWindows]; })];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyMoveLeftShortcutKey handler:MyDoOnMainThread(^{ [self moveLeft]; })];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyMoveRightShortcutKey handler:MyDoOnMainThread(^{ [self moveRight]; })];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyGrowRightShortcutKey handler:MyDoOnMainThread(^{ [self growRight]; })];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyShrinkRightShortcutKey handler:MyDoOnMainThread(^{ [self shrinkRight]; })];
    
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyShrinkToLowerRowShortcutKey handler:MyDoOnMainThread(^{ [self shrinkToLower]; })];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyShrinkToUpperRowShortcutKey handler:MyDoOnMainThread(^{ [self shrinkToUpper]; })];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MyFillEntireColumnShortcutKey handler:MyDoOnMainThread(^{ [self fillEntierColumn]; })];
}

@end
