//
//  NSImage+SDAttributedStringAdditions.m
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "NSImage+SDAttributedStringAdditions.h"


@implementation NSImage (SDAttributedStringAdditions)

+ (NSImage*) imageFromString:(NSString*)title attributes:(NSDictionary*)attributes {
	NSAttributedString *attributedTitle = [[[NSAttributedString alloc] initWithString:title attributes:attributes] autorelease];
	
	NSSize frameSize = [title sizeWithAttributes:attributes];
	NSImage *image = [[[NSImage alloc] initWithSize:frameSize] autorelease];
	[image lockFocus];
	[attributedTitle drawAtPoint:NSMakePoint(0, 0)];
	[image unlockFocus];
	return image;
}

@end
