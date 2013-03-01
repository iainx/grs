//
//  AppDelegate.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "MASShortcut.h"
#import "MyUniversalAccessHelper.h"
#import "MyGrid.h"

@implementation AppDelegate

+ (void) initialize {
    if (self == [AppDelegate self]) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
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

- (IBAction) changeNumberOfGridColumns:(id)sender {
    NSInteger oldNum = [MyGrid width];
    NSInteger newNum = [[sender title] integerValue];
    
    if (oldNum != newNum)
        [MyGrid setWidth:newNum];
}

- (void) menuNeedsUpdate:(NSMenu *)menu {
    for (NSMenuItem* item in [menu itemArray]) {
        [item setState:NSOffState];
    }
    
    NSInteger num = [MyGrid width];
    NSString* numString = [NSString stringWithFormat:@"%ld", num];
    
    [[menu itemWithTitle:numString] setState:NSOnState];
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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [MyUniversalAccessHelper complainIfNeeded];
    
    [MASShortcut setAllowsAnyHotkeyWithOptionModifier:YES];
    
    self.myActor = [[MyActor alloc] init];
    [self.myActor bindMyKeys];
    
    self.howToWindowController = [[SDHowToWindowController alloc] init];
    [self.howToWindowController showInstructionsWindowFirstTimeOnly];
}

@end
