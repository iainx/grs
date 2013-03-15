//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// usually just a subclass of NSViewController
@protocol SDPreferencePane <NSObject>

- (NSString*) title;
- (NSView*) view;

@optional

// only needed if you have more than one panel
- (NSImage*) image;

@end


@interface SDPreferencesWindowController : NSWindowController

// must call once before ever showing preferences window
// these must be Class objects, conforming to SDPreferencePane
- (void) usePreferencePaneControllerClasses:(NSArray*)classes;

// this is how you show the window
- (void) showWindow:(id)sender;

// defaults to NO
@property BOOL shouldFadeBetweenPanes;

@end
