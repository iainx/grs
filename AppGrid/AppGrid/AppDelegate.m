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

#import "MyCoolURLCommand.h"

#import "SDOpenAtLogin.h"

#import "MyCrashHandler.h"

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

- (IBAction) toggleOpensAtLogin:(id)sender {
	NSInteger changingToState = ![sender state];
	[SDOpenAtLogin setOpensAtLogin: changingToState];
}

- (IBAction) toggleUseWindowMargins:(id)sender {
	NSInteger changingToState = ![sender state];
	[MyGrid setUsesWindowMargins: changingToState];
}

- (void) menuNeedsUpdate:(NSMenu *)menu {
    if (menu == self.statusBarMenu) {
		[[menu itemWithTitle:@"Use Window Margins"] setState:([MyGrid usesWindowMargins] ? NSOnState : NSOffState)];
		[[menu itemWithTitle:@"Open at Login"] setState:([SDOpenAtLogin opensAtLogin] ? NSOnState : NSOffState)];
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
        
        [[MyLicenseVerifier sharedLicenseVerifier] nag];
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

- (void) applicationWillFinishLaunching:(NSNotification *)notification {
    self.myActor = [[MyActor alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MyLicenseVerifiedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.myActor enableKeys];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MyClickedAutoRegURLNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString* licenseName = [[note userInfo] objectForKey:@"name"];
                                                      NSString* licenseCode = [[note userInfo] objectForKey:@"code"];
                                                      
                                                      [self clickedLicenseWithName:licenseName
                                                                       licenceCode:licenseCode];
                                                  }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [MyCrashHandler handleCrashes];
    
    [self.myActor bindMyKeys];
    
    [MyUniversalAccessHelper complainIfNeeded];
    
    self.howToWindowController = [[SDHowToWindowController alloc] init];
    [self.howToWindowController showInstructionsWindowFirstTimeOnly];
    
    [self endTrialIfNecessary];
}

- (IBAction) showSendFeedbackWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.myFeedbackWindowController == nil)
        self.myFeedbackWindowController = [[MyFeedbackWindowController alloc] init];
    
    [self.myFeedbackWindowController showWindow:self];
}

@end
