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

#import "MyUniversalAccessHelper.h"

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
    CGRect r = [win gridProps];
    r.origin.x = MAX(r.origin.x - 1, 0);
    [win moveToGridProps:r];
}

- (void) moveRight {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.x = MIN(r.origin.x + 1, 2);
    [win moveToGridProps:r];
}

- (void) growRight {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MIN(r.size.width + 1, 3 - r.origin.x);
    [win moveToGridProps:r];
}

- (void) shrinkRight {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MAX(r.size.width - 1, 1);
    [win moveToGridProps:r];
}

- (void) shrinkToLower {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 1;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) shrinkToUpper {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) fillEntierColumn {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 2;
    [win moveToGridProps:r];
}

- (void) loadStatusItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"statusitem"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"statusitem_pressed"]];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusBarMenu];
}

- (void) awakeFromNib {
    [self loadStatusItem];
}

- (IBAction) reallyShowAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) showHotKeysWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.myPrefsWindowController == nil)
        self.myPrefsWindowController = [[MyPrefsWindowController alloc] init];
    
    [self.myPrefsWindowController showWindow:self];
}

- (void) bindDefaultsKey:(NSString*)key toSelector:(SEL)sel {
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:key handler:^{
        if ([MyUniversalAccessHelper complainIfNeeded])
            return;
        
        [self performSelectorOnMainThread:sel
                               withObject:nil
                            waitUntilDone:NO];
    }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [MyUniversalAccessHelper complainIfNeeded];
    
    [MASShortcut setAllowsAnyHotkeyWithOptionModifier:YES];
    
//    [self showHotKeysWindow:self];
    
    [self bindDefaultsKey:MyAlignAllToGridShortcutKey toSelector:@selector(alignAllWindows)];
    
    [self bindDefaultsKey:MyMoveLeftShortcutKey toSelector:@selector(moveLeft)];
    [self bindDefaultsKey:MyMoveRightShortcutKey toSelector:@selector(moveRight)];
    
    [self bindDefaultsKey:MyGrowRightShortcutKey toSelector:@selector(growRight)];
    [self bindDefaultsKey:MyShrinkRightShortcutKey toSelector:@selector(shrinkRight)];
    
    [self bindDefaultsKey:MyShrinkToLowerRowShortcutKey toSelector:@selector(shrinkToLower)];
    [self bindDefaultsKey:MyShrinkToUpperRowShortcutKey toSelector:@selector(shrinkToUpper)];
    [self bindDefaultsKey:MyFillEntireColumnShortcutKey toSelector:@selector(fillEntierColumn)];
}

@end
