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
#import "DCOAboutWindowController.h"

#import <Mixpanel-OSX-Community/Mixpanel.h>

@implementation SDTBAppDelegate {
    DCOAboutWindowController *_aboutWindowController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DefaultValues" ofType:@"plist"];
	NSDictionary *initialValues = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults:initialValues];
    
    [Mixpanel sharedInstanceWithToken:@"204d9e38ffa5a29a254ac5496fc58a9b"];
    [[Mixpanel sharedInstance] track:@"started"];
    
    [[iTunesProxy proxy] loadInitialTunesBarInfo];
    [self.statusItemController setupStatusItem];
    
    [iTunesProxy proxy].delegate = self.statusItemController;
    
    [SDWelcomeWindowController showInstructionsWindowFirstTimeOnly];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:nil];
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

- (void)windowWillClose:(NSNotification *)note
{
    if (note.object == _aboutWindowController.window) {
        _aboutWindowController = nil;
    }
}

- (IBAction)showAbout:(id)sender
{
    if (_aboutWindowController) {
        [_aboutWindowController.window orderFront:self];
        return;
    }
    
    _aboutWindowController = [[DCOAboutWindowController alloc] init];
    _aboutWindowController.appWebsiteURL = [NSURL URLWithString:@"http://falsevictories.com"];
    [_aboutWindowController showWindow:nil];
}
@end
