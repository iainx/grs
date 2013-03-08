//
//  SDMainSplitView.m
//  LoginControl
//
//  Created by Steven Degutis on 7/29/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "LCMainSplitView.h"


@implementation LCMainSplitView

- (void) awakeFromNib {
	[self setDelegate:self];
}

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize {
	CGFloat width = NSWidth([[[sender subviews] firstObject] frame]);
	[sender adjustSubviews];
	[sender setPosition:width ofDividerAtIndex:0];
}

- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
	CGFloat width = 6.0;
	proposedEffectiveRect.size.width += width;
	proposedEffectiveRect.origin.x -= width / 2.0;
	return proposedEffectiveRect;
}

- (CGFloat)splitView:(NSSplitView *)sender constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)offset {
	CGFloat minLeftWidth = 150.0;
	CGFloat minRightWidth = 300.0;
	
	CGFloat minRightWidthFromLeft = NSWidth([sender frame]) - minRightWidth;
	
	if (proposedPosition < minLeftWidth)
		proposedPosition = minLeftWidth;
	
	if (proposedPosition > minRightWidthFromLeft)
		proposedPosition = minRightWidthFromLeft;
	
	return proposedPosition;
}

- (NSRect)splitView:(NSSplitView *)splitView additionalEffectiveRectOfDividerAtIndex:(NSInteger)dividerIndex {
	CGFloat width = 16.0;
	CGFloat height = 23.0;
	NSRect rect = [[[splitView subviews] firstObject] bounds];
	return NSMakeRect(NSWidth(rect) - width, NSHeight(rect) - height, width, height);
}

@end
