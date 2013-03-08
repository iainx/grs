//
//  SDSnapshotPreviewCell.m
//  Docks
//
//  Created by Steven Degutis on 7/18/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDSnapshotPreviewCell.h"

#import "DockSnapshot.h"

@implementation SDSnapshotPreviewCell

- (void) setObjectValue:(id)objectValue {
	if ([objectValue isKindOfClass: [DockSnapshot class]]) {
		DockSnapshot *snapshot = objectValue;
		objectValue = [snapshot wholeDockImage];
		[self setRepresentedObject:snapshot];
	}
	
	[super setObjectValue:objectValue];
}

@end
