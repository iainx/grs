//
//  DLDesktopIcon.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/16/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLDesktopIcon.h"

@interface DLDesktopIcon ()

@property NSPoint lastKnownPosition;

@end

@implementation DLDesktopIcon

- (void) setCurrentPositionByOffset:(NSPoint)offset {
    FinderItem* item = self.finderItem;
    NSPoint point = self.initialPosition;
    
    point.x += offset.x;
    point.y -= offset.y;
    
    item.desktopPosition = point;
    self.lastKnownPosition = point;
}

- (void) resetInitialPosition {
    self.initialPosition = self.lastKnownPosition;
}

@end
