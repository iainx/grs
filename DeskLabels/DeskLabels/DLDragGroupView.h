//
//  DLDragBox.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DLDragGroupViewDelegate <NSObject>

- (void) didStartMoving;
- (void) didStopMoving;
- (void) didMoveByOffset:(NSPoint)offset;

@end

@interface DLDragGroupView : NSView

@property (weak) id<DLDragGroupViewDelegate> dragGroupDelegate;

@end
