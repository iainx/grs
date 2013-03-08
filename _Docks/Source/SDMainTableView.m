//
//  NSMainTableView.m
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDMainTableView.h"

#import "DockSnapshot.h"

#import "SDFauxTooltip.h"

#define kSDDrawingAlpha (0.7)

@interface SDMainTableView (Private)

- (void) _resetSnapshotColumnWidth;

@end


@implementation SDMainTableView

- (void) dealloc {
	[highlightGradient release];
	[super dealloc];
}

// MARK: -
// MARK: Faux Tooltip

- (void) awakeFromNib {
	int options = (NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect);
	NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
																options:options
																  owner:self
															   userInfo:nil];
	[self addTrackingArea:trackingArea];
	[trackingArea release];
}

- (void) mouseExited:(NSEvent*)event {
	[tooltip release];
	tooltip = nil;
}

- (void)mouseMoved:(NSEvent *)theEvent {
	if ([SDDefaults boolForKey:@"showFilenamePreview"] == NO) {
		if (tooltip) {
			[tooltip release];
			tooltip = nil;
		}
		return;
	}
	
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	NSInteger row = [self rowAtPoint:point];
	NSInteger col = [self columnAtPoint:point];
	NSInteger imageColumnNumber = [self columnWithIdentifier:@"image"];
	
	NSString *title = nil;
	
	if (col == imageColumnNumber && row != -1) {
		NSRect cellFrame = [self frameOfCellAtColumn:col row:row];
		
		NSCell *cell = [self preparedCellAtColumn:col row:row];
		DockSnapshot *snapshot = [cell representedObject];
		
		point.x -= cellFrame.origin.x - 1;
		point.y -= cellFrame.origin.y - 1;
		
		title = [snapshot titleOfIconAtPoint:point withRowHeight:[self rowHeight]];
	}
	
	NSDisableScreenUpdates();
	
	if (tooltip) {
		[tooltip release];
		tooltip = nil;
	}
	
	if (title)
		tooltip = [[SDFauxTooltip tooltipWithString:title] retain];
	
	NSEnableScreenUpdates();
}

// MARK: -
// MARK: Resizing Column Width

- (void) reloadData {
	[super reloadData];
	safeToResize = NO;
	[self performSelector:@selector(resetResizineSafety) withObject:nil afterDelay:0.5];
}

- (void) resetResizineSafety {
	safeToResize = YES;
	[self _resetSnapshotColumnWidth];
}

- (void) tile {
	[super tile];
	if (safeToResize)
		[self _resetSnapshotColumnWidth];
}

- (void) _resetSnapshotColumnWidth {
	NSTableColumn *col = [self tableColumnWithIdentifier:@"image"];
	NSInteger colNum = [self columnWithIdentifier:@"image"];
	
	CGFloat widestWidth = 0.0;
	
	for (NSInteger i = 0; i < [self numberOfRows]; i++) {
		NSCell *cell = [self preparedCellAtColumn:colNum row:i];
		
		DockSnapshot *snapshot = [cell representedObject];
		NSSize size = [[snapshot wholeDockImage] size];
		
		CGFloat calculatedWidth = size.width / (size.height / [self rowHeight]);
		
		if (calculatedWidth > widestWidth)
			widestWidth = calculatedWidth;
	}
	
	[col setWidth:widestWidth];
	[col setMinWidth:widestWidth];
}

// MARK: -
// MARK: Custom Drawing

- (id)_alternatingRowBackgroundColors {
	if ([NSApp isActive])
		return [NSArray arrayWithObjects:
				[NSColor colorWithCalibratedWhite:0.35 alpha:1.0],
				[NSColor colorWithCalibratedWhite:0.37 alpha:1.0],
				nil];
	else
		return [NSArray arrayWithObjects:
				[NSColor colorWithCalibratedWhite:0.45 alpha:1.0],
				[NSColor colorWithCalibratedWhite:0.47 alpha:1.0],
				nil];
}

- (NSGradient*) highlightGradient {
	if (highlightGradient == nil) {
		highlightGradient = [[NSGradient alloc] initWithColorsAndLocations:
							 [NSColor colorWithCalibratedWhite:0.05 alpha:kSDDrawingAlpha], 0.0,
							 [NSColor colorWithCalibratedWhite:0.03 alpha:kSDDrawingAlpha], 0.5,
							 [NSColor colorWithCalibratedWhite:0.00 alpha:kSDDrawingAlpha], 0.5,
							 [NSColor colorWithCalibratedWhite:0.00 alpha:kSDDrawingAlpha], 1.0,
							 nil];
	}
	
	return highlightGradient;
}

- (void)_manuallyDrawSourceListHighlightInRect:(NSRect)rect isButtedUpRow:(BOOL)flag {
	[[self highlightGradient] drawInRect:rect angle:90.0];
	
	if ([NSApp isActive] == NO) {
		[[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
		[NSBezierPath fillRect:rect];
	}
}

- (BOOL) _manuallyDrawSourceListHighlight {
	return YES;
}

// MARK: -
// MARK: Keyboard

- (void)keyDown:(NSEvent *)theEvent {
	BOOL cmdHeld = (([theEvent modifierFlags] & NSCommandKeyMask) != 0);
	NSString *keyString = [theEvent charactersIgnoringModifiers];
	
	switch([keyString characterAtIndex:0]) {
		case 0177: /* Delete key */
		case NSDeleteFunctionKey:
		case NSDeleteCharFunctionKey:
			if (cmdHeld)
				[[self window] tryToPerform:@selector(deleteSnapshot:) with:self];
			
			break;
		default:
			[super keyDown:theEvent];
	}
}

// MARK: -
// MARK: Mouse

//- (void) magnifyWithEvent:(NSEvent *)anEvent {
//	if ([slider isHidden] == YES)
//		return;
//	
//	float value = [SDDefaults floatForKey:@"rowHeight"];
//	
//	value += ceil([anEvent deltaZ] / 2.0);
//	
//	if (value > [slider maxValue])
//		value = [slider maxValue];
//	
//	if (value < [slider minValue])
//		value = [slider minValue];
//	
//	[SDDefaults setFloat:value forKey:@"rowHeight"];
//	
//	[self setNeedsDisplay:YES];
//}

@end
