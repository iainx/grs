//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "NSWindow+Geometry.h"

@implementation NSWindow (SDResizableWindow)

- (void) sd_setContentViewSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate {
	[self setFrame:[self sd_windowFrameForNewContentViewSize:newSize] display:display animate:animate];
}

- (NSRect) sd_windowFrameForNewContentViewSize:(NSSize)newSize {
	NSRect windowFrame = [self frame];
	
	windowFrame.size.width = newSize.width;
	
	float titlebarAreaHeight = windowFrame.size.height - [[self contentView] frame].size.height;
	float newHeight = newSize.height + titlebarAreaHeight;
	float heightDifference = windowFrame.size.height - newHeight;
	windowFrame.size.height = newHeight;
	windowFrame.origin.y += heightDifference;
	
	return windowFrame;
}

@end
