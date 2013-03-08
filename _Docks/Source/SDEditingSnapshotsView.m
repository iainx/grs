//
//  SDEditingSnapshotsView.m
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDEditingSnapshotsView.h"

#import "DockSnapshot.h"

#import "SDSnapshotEditableView.h"

@interface SDEditingSnapshotsView (Private)

- (void) refreshSnapshots;
- (void) readjustSizeBasedOnMinimums;

@end

@implementation SDEditingSnapshotsView

@synthesize snapshots;

+ (void) initialize {
	if (self == [SDEditingSnapshotsView class]) {
		[self exposeBinding:@"snapshots"];
	}
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldBoundsSize {
	[self readjustSizeBasedOnMinimums];
//	[super resizeWithOldSuperviewSize:oldBoundsSize];
}

- (void) dealloc {
	[snapshots release];
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"arrangedObjects"] && [(id)context isEqualToString:kSDSnapshotsBindingsContext])
		[self refreshSnapshots];
}

- (void) drawRect:(NSRect)dirtyRect {
	[[[NSColor redColor] colorWithAlphaComponent:0.5] drawSwatchInRect:[self bounds]];
}

- (void) readjustSizeBasedOnMinimums {
	BOOL minWidthIsZero = [[NSNumber numberWithFloat:minWidth] isEqualToNumber:[NSNumber numberWithInt:0]];
	BOOL minheightIsZero = [[NSNumber numberWithFloat:minHeight] isEqualToNumber:[NSNumber numberWithInt:0]];
	if (minWidthIsZero || minheightIsZero)
		return;
	
	NSRect rect = [[self enclosingScrollView] documentVisibleRect];
	
	NSLog(@"hi %@", NSStringFromRect(rect));
}

- (void) refreshSnapshots {
	NSDisableScreenUpdates();
	
	// remove all subviews
	
	while ([[self subviews] count] > 0)
		[[[self subviews] lastObject] removeFromSuperview];
	
	// create new subviews
	
	NSMutableArray *newSubviews = [NSMutableArray array];
	
	minWidth = 0.0;
	minHeight = 0.0;
	
	for (DockSnapshot *snapshot in snapshots) {
		SDSnapshotEditableView *editableView = [[[SDSnapshotEditableView alloc] initWithSnapshot:snapshot] autorelease];
		[newSubviews addObject:editableView];
		
		float width = NSWidth([editableView frame]);
		minHeight += NSHeight([editableView frame]);
		
		if (width > minWidth)
			minWidth = width;
	}
	
//	[self setFrameSize:NSMakeSize(minWidth, minHeight)];
	
	[self readjustSizeBasedOnMinimums];
	
	float y = 0.0;
	for (NSView *view in newSubviews) {
		[view setFrameOrigin:NSMakePoint(0.0, y)];
		[self addSubview:view];
		y += NSHeight([view frame]);
	}
	
	NSEnableScreenUpdates();
	//NSLog(@"hi! %d", snapshotsCount);
}

@end
