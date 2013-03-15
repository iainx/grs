//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDWelcomeWindowRoundedImageView.h"


@implementation SDWelcomeWindowRoundedImageView

- (void) drawRect:(NSRect)dirtyRect {
	float r = 7.0;
	float r2 = r - 0.9;
	
	NSRect bounds = [self bounds];
	NSRect imageClipBounds = NSInsetRect(bounds, 1.0, 1.0);
	
	NSBezierPath *borderFillPath = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:r yRadius:r];
	NSBezierPath *imageClipPath = [NSBezierPath bezierPathWithRoundedRect:imageClipBounds xRadius:r2 yRadius:r2];
	
	// draw border
	[[NSColor colorWithCalibratedWhite:0.20 alpha:1.0] setFill];
	[borderFillPath fill];
	
	// clip
	[imageClipPath addClip];
	
	// draw image
	[super drawRect:dirtyRect];
}

@end
