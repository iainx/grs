//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDWelcomeWindowController.h"
#import "SDRoundedWelcomeImageView.h"

#define SDInstructionsWindowFirstTimePastKey @"SDInstructionsWindowFirstTimePassed" // never change this line, ever.

@implementation SDWelcomeWindowController

- (NSString*) windowNibName {
    return @"SDWelcomeWindow";
}

- (void) showInstructionsWindowFirstTimeOnly {
    BOOL firstTimePast = [[NSUserDefaults standardUserDefaults] boolForKey:SDInstructionsWindowFirstTimePastKey];
    
    if (!firstTimePast) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SDInstructionsWindowFirstTimePastKey];
        [self showInstructionsWindow];
    }
}

- (void) showInstructionsWindow {
	[NSApp activateIgnoringOtherApps:YES];
	[[self window] center];
	[self showWindow:self];
}

- (NSString*) appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

@end
