//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDWelcomeWindowController.h"

#define SDInstructionsWindowFirstTimePastKey @"SDInstructionsWindowFirstTimePassed" // never change this line, ever.

@implementation SDWelcomeWindowController

- (NSString*) windowNibName {
    return @"SDWelcomeWindow";
}

+ (SDWelcomeWindowController*) sharedWelcomeWindowController {
    static SDWelcomeWindowController* sharedWelcomeWindowController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWelcomeWindowController = [[SDWelcomeWindowController alloc] init];
    });
    return sharedWelcomeWindowController;
}

+ (void) showInstructionsWindowFirstTimeOnly {
    BOOL firstTimePast = [[NSUserDefaults standardUserDefaults] boolForKey:SDInstructionsWindowFirstTimePastKey];
    
    if (!firstTimePast) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SDInstructionsWindowFirstTimePastKey];
        [self showInstructionsWindow];
    }
}

+ (void) showInstructionsWindow {
	[NSApp activateIgnoringOtherApps:YES];
	[[[self sharedWelcomeWindowController] window] center];
	[[self sharedWelcomeWindowController] showWindow:self];
}

- (NSString*) appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (void) windowDidLoad {
    [super windowDidLoad];
    [[self window] setContentBorderThickness:34.0 forEdge:NSMinYEdge];
}

@end
