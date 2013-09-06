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

@end
