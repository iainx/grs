//
//  DLDesktopIcon.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/16/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Finder.h"

@interface DLDesktopIcon : NSObject

@property FinderItem* finderItem;
@property NSPoint initialPosition;

- (void) setCurrentPositionByOffset:(NSPoint)offset;
- (void) resetInitialPosition;

@end
