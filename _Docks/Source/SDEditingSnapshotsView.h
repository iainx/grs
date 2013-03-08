//
//  SDEditingSnapshotsView.h
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kSDSnapshotsBindingsContext @"kSDSnapshotsBindingsContext"

@interface SDEditingSnapshotsView : NSView {
	NSArray *snapshots;
	
	float minWidth;
	float minHeight;
}

@property (retain) NSArray *snapshots;

@end
