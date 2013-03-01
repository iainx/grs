//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDInstructionsWindowController : NSWindowController

@property IBOutlet NSView *imageViewContainer;
@property IBOutlet NSSegmentedControl *backForwardButton;

- (void) showInstructionsWindow;
- (void) showInstructionsWindowFirstTimeOnly;

@end
