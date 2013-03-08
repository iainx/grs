//
//  SDLoginItemCell.m
//  LoginControl
//
//  Created by Steven Degutis on 7/29/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "LCLoginItemCell.h"

#import "LCLoginItem.h"
#import <NDAlias/NDAlias.h>

@implementation LCLoginItemCell

- (void) setObjectValue:(id)newObjectValue {
	icon = nil;
	
	if ([newObjectValue isKindOfClass: [LCLoginItem class]]) {
		LCLoginItem *loginItem = newObjectValue;
		
		newObjectValue = loginItem.displayName;
		icon = loginItem.icon;
	}
	
	[super setObjectValue:newObjectValue];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSRect imageFrame = cellFrame;
    imageFrame.size = NSMakeSize(16.0, 16.0);
    imageFrame.origin.x += 3;
    imageFrame.origin.y += 1;
    
    SDDivideRect(cellFrame, NULL, &cellFrame, 24.0, NSMinXEdge);
    
	if (icon) {
		[icon setFlipped:YES];
		[icon drawInRect:imageFrame
				fromRect:NSZeroRect
			   operation:NSCompositeSourceAtop
				fraction:1.0];
	}
	
	[super drawWithFrame:cellFrame inView:controlView];
}

@end
