//
//  SDInsetVerticalLine.m
//  AppGrid
//
//  Created by Steven Degutis on 3/6/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDInsetVerticalLine.h"

@implementation SDInsetVerticalLine

- (void)drawRect:(NSRect)dirtyRect {
    NSRect bounds = [self bounds], garbage;
    NSDivideRect(bounds, &bounds, &garbage, 2.0, NSMaxXEdge);
    
	NSRect topLine, bottomLine;
	NSDivideRect(bounds, &topLine, &bottomLine, 1.0, NSMinXEdge);
	
	[[NSColor lightGrayColor] setFill];
	[NSBezierPath fillRect:topLine];
	
	[[NSColor whiteColor] setFill];
	[NSBezierPath fillRect:bottomLine];
}

@end
