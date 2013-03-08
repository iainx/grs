//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDHowToWindowController.h"
#import "SDRoundedHowToImageView.h"

@interface SDHowToWindowController ()

@property IBOutlet NSView *imageViewContainer;

@property NSImageView *imageView;

@end

#define SDInstructionsWindowFirstTimePastKey @"SDInstructionsWindowFirstTimePastForVersion" // never change this line, ever.

@implementation SDHowToWindowController

- (void) showInstructionsWindowFirstTimeOnly {
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* firstTimeDefaultsKeyForVersion = [NSString stringWithFormat:@"%@%@", SDInstructionsWindowFirstTimePastKey, version];
    
    BOOL firstTimePast = [[NSUserDefaults standardUserDefaults] boolForKey:firstTimeDefaultsKeyForVersion];
    
    if (!firstTimePast) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstTimeDefaultsKeyForVersion];
        [self showInstructionsWindow];
    }
}

- (void) showInstructionsWindow {
	[NSApp activateIgnoringOtherApps:YES];
	[[self window] center];
	[self showWindow:self];
}

- (NSString*) windowNibName {
    return @"SDHowToWindow";
}

- (NSString*) appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (void) windowDidLoad {
	NSWindow *window = [self window];
	
    NSImage *image = [NSImage imageNamed:@"sd_intro"];
        
    NSRect imageViewFrame = NSZeroRect;
    imageViewFrame.size = [self.imageViewContainer frame].size;
//    imageViewFrame.origin = NSMakePoint(1.0, 1.0);
    imageViewFrame = NSIntegralRect(imageViewFrame);
    
    self.imageView = [[SDRoundedHowToImageView alloc] initWithFrame:imageViewFrame];
    [self.imageView setImageScaling:NSScaleNone];
    [self.imageView setImageAlignment:NSImageAlignCenter];
    [self.imageView setImage:image];
    
	[self.imageViewContainer setWantsLayer:YES];
	[self.imageViewContainer addSubview:self.imageView];
	
	[window setContentBorderThickness:34.0 forEdge:NSMinYEdge];
	[window setTitle:[NSString stringWithFormat:[window title], [self appName]]];
}

- (IBAction) closeWindow:(id)sender {
	[self close];
}

@end
