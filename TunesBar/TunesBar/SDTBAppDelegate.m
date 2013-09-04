//
//  SDTBAppDelegate.m
//  TunesBar
//
//  Created by Steven Degutis on 3/14/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//
//  Modified by Iain Holmes
//  Copyright (c) 2013 Sleep(5)
//

#import "SDTBAppDelegate.h"

#import "SDPreferencesWindowController.h"

#import "SDGeneralPrefPane.h"

#import <ServiceManagement/ServiceManagement.h>

#import "SDWelcomeWindowController.h"

@implementation SDTBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSImage imageNamed:@"NextTrack"] setTemplate:YES];
    [[NSImage imageNamed:@"PreviousTrack"] setTemplate:YES];
    [[NSImage imageNamed:@"Play"] setTemplate:YES];
    [[NSImage imageNamed:@"Pause"] setTemplate:YES];
    
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DefaultValues" ofType:@"plist"];
	NSDictionary *initialValues = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults:initialValues];
    
    [iTunesProxy proxy].delegate = self.statusItemController;
    [[iTunesProxy proxy] loadInitialTunesBarInfo];
    [self.statusItemController setupStatusItem];
    
    [SDWelcomeWindowController showInstructionsWindowFirstTimeOnly];
}

- (IBAction) showPreferencesWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.preferencesWindowController == nil) {
        self.preferencesWindowController = [[SDPreferencesWindowController alloc] init];
        [self.preferencesWindowController usePreferencePaneControllerClasses:@[[SDGeneralPrefPane self]]];
    }
    
    [self.preferencesWindowController showWindow:sender];
}

- (IBAction) reallyShowAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) toggleOpenAtLogin:(id)sender {
	NSInteger changingToState = ![sender state];
    if (!SMLoginItemSetEnabled(CFSTR("com.sleepfive.TunesBarPlusHelper"), changingToState)) {
        NSRunAlertPanel(@"Could not change Open at Login status",
                        @"For some reason, this failed. Most likely it's because the app isn't in the Applications folder.",
                        @"OK",
                        nil,
                        nil);
    }
}

- (BOOL) opensAtLogin {
    CFArrayRef jobDictsCF = SMCopyAllJobDictionaries( kSMDomainUserLaunchd );
    NSArray* jobDicts = (__bridge_transfer NSArray*)jobDictsCF;
    // Note: Sandbox issue when using SMJobCopyDictionary()

    if ((jobDicts != nil) && [jobDicts count] > 0) {
        BOOL bOnDemand = NO;

        for (NSDictionary* job in jobDicts) {
            if ([[job objectForKey:@"Label"] isEqualToString: @"com.sleepfive.TunesBarPlusHelper"]) {
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }

        return bOnDemand;
    }
    return NO;
}

- (void) menuNeedsUpdate:(NSMenu *)menu {
    BOOL opensAtLogin = [self opensAtLogin];
    [[menu itemWithTitle:@"Open at Login"] setState:(opensAtLogin ? NSOnState : NSOffState)];
}

@end
