//
//  SDSnapshotTitleTextFieldCell.m
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDSnapshotTitleTextFieldCell.h"


@implementation SDSnapshotTitleTextFieldCell

//- (id) initWithCoder:(NSCoder*)coder {
//	if (self = [super initWithCoder:coder]) {
//	}
//	return self;
//}

//- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//	[super drawWithFrame:cellFrame inView:controlView];
//}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[self setBackgroundStyle:NSBackgroundStyleLowered];
	[self setTextColor:[NSColor whiteColor]];
	[self setFont:[[NSFontManager sharedFontManager] convertFont:[self font] toHaveTrait:NSBoldFontMask]];
	
	float amount = NSHeight(cellFrame) * 0.30;
	SDDivideRect(cellFrame, NULL, &cellFrame, amount, NSMinYEdge);
	cellFrame.size.height = 17.0;
	
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
	float amount = NSHeight(aRect) * 0.30;
	SDDivideRect(aRect, NULL, &aRect, amount, NSMinYEdge);
	aRect.size.height = 17.0;
	
	[super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
	float amount = NSHeight(aRect) * 0.30;
	SDDivideRect(aRect, NULL, &aRect, amount, NSMinYEdge);
	aRect.size.height = 17.0;
	
	[self setTextColor:[NSColor blackColor]];
	
	[super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

@end
