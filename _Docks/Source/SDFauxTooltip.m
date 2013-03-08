//
//  SDFauxTooltip.m
//  Docks
//
//  Created by Steven Degutis on 7/19/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDFauxTooltip.h"


@implementation SDFauxTooltip

+ (id) tooltipWithString:(NSString*)newTitle {
	return [[[self alloc] initWithString:newTitle] autorelease];
}

- (id) initWithString:(NSString*)newTitle {
	if (self = [super initWithWindowNibName:@"FauxTooltipWindow"]) {
		title = [newTitle copy];
		
		[self showWindow:self];
	}
	return self;
}

- (void) windowDidLoad {
	[titleField setStringValue:title];
	[titleField sizeToFit];
	
	[titleField setFont:[NSFont toolTipsFontOfSize:[[titleField font] pointSize]]];
	
	NSRect windowFrame = [[self window] frame];
	windowFrame.size.width = [titleField frame].size.width + ([titleField frame].origin.x * 2.0);
	[[self window] setFrame:windowFrame display:YES];
}

- (void) dealloc {
	[title release];
	[super dealloc];
}

@end
