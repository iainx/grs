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

#import "SDWelcomeWindowController.h"

@implementation SDTBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DefaultValues" ofType:@"plist"];
	NSDictionary *initialValues = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults:initialValues];
    
    [self.statusItemController setupStatusItem];
    
    [iTunesProxy proxy].delegate = self.statusItemController;
    [[iTunesProxy proxy] loadInitialTunesBarInfo];
    
    [SDWelcomeWindowController showInstructionsWindowFirstTimeOnly];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
    [self.statusItemController hideInfoPanel];
}

- (void)windowLostFocus
{
    NSLog(@"Lost focus");
}

@end
