//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDHowToWindowController.h"

#import <QTKit/QTKit.h>

@interface SDHowToWindowController ()

@property (weak) IBOutlet QTMovieView *movieView;

@end

#define SDInstructionsWindowFirstTimePastKey @"SDInstructionsWindowFirstTimePastForVersion" // never change this line, ever.

@implementation SDHowToWindowController

+ (SDHowToWindowController*) sharedHowToWindowController {
    static SDHowToWindowController* sharedHowToWindowController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHowToWindowController = [[SDHowToWindowController alloc] init];
    });
    return sharedHowToWindowController;
}

+ (void) showInstructionsWindowFirstTimeOnly {
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* firstTimeDefaultsKeyForVersion = [NSString stringWithFormat:@"%@%@", SDInstructionsWindowFirstTimePastKey, version];
    
    BOOL firstTimePast = [[NSUserDefaults standardUserDefaults] boolForKey:firstTimeDefaultsKeyForVersion];
    
    if (!firstTimePast) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstTimeDefaultsKeyForVersion];
        [self showInstructionsWindow];
    }
}

+ (void) showInstructionsWindow {
	[NSApp activateIgnoringOtherApps:YES];
	[[[self sharedHowToWindowController] window] center];
	[[self sharedHowToWindowController] showWindow:self];
}

- (NSString*) windowNibName {
    return @"SDHowToWindow";
}

- (NSString*) appName {
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    if (appName == nil)
        appName = [[[NSFileManager defaultManager] displayNameAtPath:[[NSBundle mainBundle] bundlePath]] stringByDeletingPathExtension];
    return appName;
}

- (void) windowWillClose:(NSNotification *)notification {
    [self.movieView pause:self];
    [self.movieView gotoBeginning:self];
}

- (void) windowDidLoad {
    NSError *__autoreleasing error;
	QTMovie* movie = [QTMovie movieNamed:@"howto" error:&error];
    self.movieView.movie = movie;
    
    [self.movieView setBackButtonVisible:NO];
    [self.movieView setCustomButtonVisible:NO];
    [self.movieView setHotSpotButtonVisible:NO];
    [self.movieView setStepButtonsVisible:NO];
    [self.movieView setTranslateButtonVisible:NO];
    [self.movieView setVolumeButtonVisible:NO];
    [self.movieView setZoomButtonsVisible:NO];
    
	NSWindow *window = [self window];
	[window setContentBorderThickness:34.0 forEdge:NSMinYEdge];
	[window setTitle:[NSString stringWithFormat:[window title], [self appName]]];
}

@end
