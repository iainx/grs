//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDInstructionsWindowController.h"
#import "SDRoundedInstructionsImageView.h"

@interface SDInstructionsWindowController ()

@property NSMutableArray *imageViews;
@property NSInteger selectedImageIndex;

@end

#define SDInstructionsWindowFirstTimePastKey @"SDInstructionsWindowFirstTimePastForVersion" // never change this line, ever.

@implementation SDInstructionsWindowController

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
    return @"SDInstructionsWindow";
}

- (NSString*) appName {
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    if (appName == nil)
        appName = [[[NSFileManager defaultManager] displayNameAtPath:[[NSBundle mainBundle] bundlePath]] stringByDeletingPathExtension];
    return appName;
}

- (NSArray*) imageNames {
    NSArray* urls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[[NSBundle mainBundle] resourceURL]
                                                  includingPropertiesForKeys:@[]
                                                                     options:0
                                                                       error:NULL];
    
    urls = [urls valueForKey:@"lastPathComponent"];
    urls = [urls filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString* evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject hasPrefix:@"sd_howto_"];
    }]];
    urls = [urls sortedArrayUsingSelector:@selector(compare:)];
    return urls;
}

- (void) windowDidLoad {
    self.imageViews = [NSMutableArray array];
    
	NSWindow *window = [self window];
	
	for (NSString *imageName in [self imageNames]) {
		NSImage *image = [NSImage imageNamed:imageName];
        
		NSRect imageViewFrame = NSZeroRect;
		imageViewFrame.size = [self.imageViewContainer frame].size;
//		imageViewFrame.origin = NSMakePoint(1.0, 1.0);
		imageViewFrame = NSIntegralRect(imageViewFrame);
		
		NSImageView *imageView = [[SDRoundedInstructionsImageView alloc] initWithFrame:imageViewFrame];
		[imageView setImageScaling:NSScaleNone];
		[imageView setImageAlignment:NSImageAlignCenter];
		[imageView setImage:image];
		
		[self.imageViews addObject:imageView];
	}
	
	// to make it appear right away in the window
	[self willChangeValueForKey:@"selectedImageIndexPlusOne"];
	self.selectedImageIndex = 0;
	[self didChangeValueForKey:@"selectedImageIndexPlusOne"];
	
	[self.imageViewContainer setWantsLayer:YES];
	[self.imageViewContainer addSubview:[self.imageViews objectAtIndex:0]];
	
	[window setContentBorderThickness:34.0 forEdge:NSMinYEdge];
	[window setTitle:[NSString stringWithFormat:[window title], [self appName]]];
}

- (NSInteger) selectedImageIndexPlusOne {
	return self.selectedImageIndex + 1;
}

- (void) navigateInDirection:(NSNumber*)dir {
	NSInteger oldSelectedImage = self.selectedImageIndex;
	
	[self willChangeValueForKey:@"selectedImageIndexPlusOne"];
	
	self.selectedImageIndex += [dir intValue];
	
	if (self.selectedImageIndex < 0)
		self.selectedImageIndex = 0;
	else if (self.selectedImageIndex == [self.imageViews count])
		self.selectedImageIndex = [self.imageViews count] - 1;
	
	[self didChangeValueForKey:@"selectedImageIndexPlusOne"];
	
	[self.backForwardButton setEnabled:(self.selectedImageIndex > 0) forSegment:0];
	[self.backForwardButton setEnabled:(self.selectedImageIndex < [self.imageViews count] - 1) forSegment:1];
	
	if (self.selectedImageIndex == oldSelectedImage)
		return;
    
    NSLog(@"%ld", self.selectedImageIndex);
	
	NSView *oldSubview = [[self.imageViewContainer subviews] lastObject];
	NSView *newSubview = [self.imageViews objectAtIndex:self.selectedImageIndex];
	
	[[self.imageViewContainer animator] replaceSubview:oldSubview
											 with:newSubview];
}

- (IBAction) navigateFromArrowsButton:(NSSegmentedControl*)sender {
	if ([sender selectedSegment] == 0)
		[self navigateInDirection:[NSNumber numberWithInt:(-1)]];
	else
		[self navigateInDirection:[NSNumber numberWithInt:(+1)]];
}

- (IBAction) closeWindow:(id)sender {
	[self close];
}

@end
