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

#import "MyLicenseVerifier.h"

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

- (void) endTrialIfNecessary {
    NSDate* expires = [NSDate dateWithTimeIntervalSinceReferenceDate:383851680 + (60 * 60 * 24 * 7)];
    NSDate* now = [NSDate date];
    BOOL expired = ([now compare: expires] == NSOrderedDescending);
    
    if (expired) {
        [self.myActor unbindMyKeys];
        
        [NSApp activateIgnoringOtherApps:YES];
        NSRunAlertPanel(@"AppGrid's trial period is over", @"Let me know if you want an extended trial.", @"OK", nil, nil);
        [NSApp terminate:self];
    }
    
    [self performSelector:@selector(endTrialIfNecessary) withObject:nil afterDelay:60];
}

- (IBAction) showLicenseOrStore:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    self.myLicenseWindowController = [[MyLicenseWindowController alloc] init];
    [self.myLicenseWindowController showWindow:self];
}

- (void) user:(NSString*)username clickedLicenseWithSerial:(NSString*)serial {
    BOOL valid = [MyLicenseVerifier verifyLicense:serial for:username];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    // TODO: Save registration to preferences.
    // TODO: Broadcast notification of a changed registration information.
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self endTrialIfNecessary];
    
    self.myLicenseURLHandler = [[MyLicenseURLHandler alloc] init];
    [self.myLicenseURLHandler listenForURLs:^(NSString *username, NSString *serial) {
        [self user:username clickedLicenseWithSerial:serial];
    }];
     
    [MyUniversalAccessHelper complainIfNeeded];
    
    [MASShortcut setAllowsAnyHotkeyWithOptionModifier:YES];
    
    self.myActor = [[MyActor alloc] init];
    [self.myActor bindMyKeys];
    
    self.howToWindowController = [[SDHowToWindowController alloc] init];
    [self.howToWindowController showInstructionsWindowFirstTimeOnly];
}

@end
