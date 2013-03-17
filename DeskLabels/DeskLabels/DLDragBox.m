//
//  DLDragBox.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLDragBox.h"

@interface DLDragBox ()

@property BOOL isDragging;

@end

@implementation DLDragBox

- (void) resetCursorRects {
    NSCursor* cursor = self.isDragging ? [NSCursor closedHandCursor] : [NSCursor openHandCursor];
    [self addCursorRect:[self bounds] cursor:cursor];
}

- (void) startedDragging {
    self.isDragging = YES;
    [self.window invalidateCursorRectsForView:self];
}

- (void) stoppedDragging {
    self.isDragging = NO;
    [self.window invalidateCursorRectsForView:self];
}

@end
