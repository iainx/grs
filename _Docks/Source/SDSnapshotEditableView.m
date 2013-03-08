//
//  SDSnapshotEditableView.m
//  Docks
//
//  Created by Steven Degutis on 7/20/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDSnapshotEditableView.h"

#import "DockSnapshot.h"
#import "PersistentApp.h"
#import "PersistentOther.h"
#import "DockIconFile.h"

#import "SDSnapshotTitleTextFieldCell.h"

@interface SDSnapshotEditableView (Private)

- (void) setFrameBasedOnSnapshot;
- (void) addSnapshotAreaSubviews;

@end


@implementation SDSnapshotEditableView

#define SDIconWidth (32.0)
#define SDIconHeight (SDIconWidth)
#define SDMarginWidth (SDIconWidth / 4.0)
#define SDStreetAreaWidth (SDIconWidth / 2.0)
#define SDTitleAreaWidth (150.0)

- (id) initWithSnapshot:(DockSnapshot*)newSnapshot {
	if (self = [super init]) {
		snapshot = newSnapshot;
		
		[self setFrameBasedOnSnapshot];
		[self addSnapshotAreaSubviews];
	}
	return self;
}

- (void) setFrameBasedOnSnapshot {
	NSArray *apps = [PersistentApp orderedIconsInSnapshot:snapshot];
	NSArray *others = [PersistentOther orderedIconsInSnapshot:snapshot];
	
	NSRect frame = NSZeroRect;
	frame.size.height = SDIconHeight + (SDMarginWidth * 2.0);
	frame.size.width = (SDMarginWidth * 2.0) + (SDIconWidth * ([apps count] + [others count])) + SDStreetAreaWidth + SDTitleAreaWidth;
	
	[self setFrame:frame];
}

- (void) dealloc {
	[titleField unbind:@"value"];
	[titleField release];
	[super dealloc];
}

- (void) addSnapshotAreaSubviews {
	// title subview
	
	NSRect titleFrame = NSMakeRect(SDMarginWidth, SDMarginWidth, SDTitleAreaWidth, SDIconHeight);
	titleField = [[NSTextField alloc] initWithFrame:titleFrame];
	[titleField setCell:[[[SDSnapshotTitleTextFieldCell alloc] init] autorelease]];
	[titleField setEditable:NO];
	[titleField setSelectable:NO];
	[titleField setDrawsBackground:NO];
	
	[titleField bind:@"value"
			toObject:snapshot
		 withKeyPath:@"userDefinedName"
			 options:nil];
	
	[self addSubview:titleField];
	
}

@end
