//
//  AppDelegate.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

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
    if (menu == self.statusBarMenu) {
//        NSString* licenseItemTitle = @"Purchase...";
//        
//        if ([MyLicenseVerifier hasValidLicense])
//            licenseItemTitle = @"License...";
//        
//        NSMenuItem* licenseItem = [menu itemWithTag:77];
//        [licenseItem setTitle:licenseItemTitle];
    }
    else {
        for (NSMenuItem* item in [menu itemArray]) {
            [item setState:NSOffState];
        }
        
        NSInteger num = [MyGrid width];
        NSString* numString = [NSString stringWithFormat:@"%ld", num];
        
        [[menu itemWithTitle:numString] setState:NSOnState];
    }
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
    if ([MyLicenseVerifier hasValidLicense])
        return;
    
    if ([MyLicenseVerifier expired]) {
        [self.myActor disableKeys];
        
        [NSApp activateIgnoringOtherApps:YES];
        NSInteger result = NSRunAlertPanel(@"AppGrid trial has expired",
                                           @"You may continue using AppGrid by purchasing a license.",
                                           @"OK",
                                           @"Purchase License",
                                           nil);
        
        if (result == NSAlertAlternateReturn)
            [MyLicenseVerifier sendToStore];
    }
    else {
        [self performSelector:@selector(endTrialIfNecessary) withObject:nil afterDelay:60];
    }
}

- (IBAction) showLicenseWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.myLicenseWindowController == nil)
        self.myLicenseWindowController = [[MyLicenseWindowController alloc] init];
    
    [self.myLicenseWindowController showWindow:self];
}

- (void) clickedLicenseWithName:(NSString*)licenseName licenceCode:(NSString*)licenseCode {
    BOOL valid = [MyLicenseVerifier tryRegisteringWithLicenseCode:licenseCode licenseName:licenseName];
    
    [NSApp activateIgnoringOtherApps:YES];
    NSInteger result = [[MyLicenseVerifier alertForValidity:valid fromLink:YES] runModal];
    
    if (result == NSAlertSecondButtonReturn)
        [MyLicenseVerifier sendToWebsite];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:MyLicenseVerifiedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.myActor enableKeys];
                                                  }];
    
    self.myLicenseURLHandler = [[MyLicenseURLHandler alloc] init];
    [self.myLicenseURLHandler listenForURLs:^(NSString* licenseName, NSString* licenseCode) {
        [self clickedLicenseWithName:licenseName licenceCode:licenseCode];
    }];
     
    [MyUniversalAccessHelper complainIfNeeded];
    
    self.myActor = [[MyActor alloc] init];
    [self.myActor bindMyKeys];
    
    self.howToWindowController = [[SDHowToWindowController alloc] init];
    [self.howToWindowController showInstructionsWindowFirstTimeOnly];
    
    [self endTrialIfNecessary];
}

@end
