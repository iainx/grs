//
//  SDSnapshotEditableView.h
//  Docks
//
//  Created by Steven Degutis on 7/20/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DockSnapshot;

@interface SDSnapshotEditableView : NSView {
	DockSnapshot *snapshot;
	
	NSTextField *titleField;
}

- (id) initWithSnapshot:(DockSnapshot*)newSnapshot;

@end
