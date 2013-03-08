//
//  SDFauxTooltipWindow.m
//  Docks
//
//  Created by Steven Degutis on 7/19/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDFauxTooltipWindow.h"


@implementation SDFauxTooltipWindow

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)windowStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)deferCreation
{
	contentRect.origin = [NSEvent mouseLocation];
	contentRect.origin.y -= 45.0;
	
	if (self = [super initWithContentRect:contentRect
								styleMask:NSBorderlessWindowMask
								  backing:bufferingType
									defer:deferCreation]) {
		[self setBackgroundColor:[NSColor colorWithCalibratedRed:0.988 green:0.992 blue:0.788 alpha:1.0]];
	}
	return self;
}

- (void) drawRect:(NSRect)dirtyRect {
}

@end
