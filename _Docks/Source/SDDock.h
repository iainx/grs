//
//  SDDock.h
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SDDock;
@class DockSnapshot;

@protocol SDDockDelegate

- (void) dock:(SDDock*)theDock tookSnapshotSuccessfully:(DockSnapshot*)snapshot;

@end


@interface SDDock : NSObject {
	BOOL dockIsBusy;
	id <SDDockDelegate> delegate;
	
	BOOL thisAppKilledDock;
}

@property BOOL dockIsBusy;

// designated accessor (singleton)
+ (SDDock*) dock;

- (void) takeSnapshotWithDelegate:(id<SDDockDelegate>)newDelegate;
- (void) restoreSnapshot:(DockSnapshot*)snapshot;

@end
