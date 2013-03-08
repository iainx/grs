//
//  NSStatusItem+SDAdditions.m
//  SDKit
//
//  Created by Steven on 11/7/08.
//  Copyright 2008 Giant Robot Software. All rights reserved.
//

#import "NSStatusItem+SDAdditions.h"
#import "NSImage+SDAttributedStringAdditions.h"

@implementation NSStatusItem (SDAdditions)

- (void) setImagesWithTitle:(NSString*)title font:(NSFont*)font foreColor:(NSColor*)foreColor {
	NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
	[shadow setShadowBlurRadius:1.0];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.7]];
	[shadow setShadowOffset:NSMakeSize(0, -1)];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, foreColor, NSForegroundColorAttributeName, shadow, NSShadowAttributeName, nil];
	NSDictionary *altAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSColor whiteColor], NSForegroundColorAttributeName, nil];
	
	NSDisableScreenUpdates();
	
	[self setImage:[NSImage imageFromString:title attributes:attributes]];
	[self setAlternateImage:[NSImage imageFromString:title attributes:altAttributes]];
	
	NSEnableScreenUpdates();
}

@end
