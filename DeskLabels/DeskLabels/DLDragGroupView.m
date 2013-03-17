//
//  DLDragBox.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLDragGroupView.h"

@interface DLDragGroupView ()

@property BOOL isDragging;
@property NSPoint initialMousePoint;

@end

@implementation DLDragGroupView

- (void) resetCursorRects {
    [self discardCursorRects];
    
    NSCursor* cursor = self.isDragging ? [NSCursor closedHandCursor] : [NSCursor openHandCursor];
    [self addCursorRect:[self bounds] cursor:cursor];
    [cursor setOnMouseEntered:YES];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.isDragging = NO;
    [self.window invalidateCursorRectsForView:self];
    
    [self.dragGroupDelegate didStartMoving];
    
    NSPoint p = [NSEvent mouseLocation];
    self.initialMousePoint = NSMakePoint(round(p.x), round(p.y));
}

- (void) mouseDragged:(NSEvent *)theEvent {
    self.isDragging = YES;
    [self.window invalidateCursorRectsForView:self];
    
    NSPoint currentPoint = [NSEvent mouseLocation];
    
    CGFloat offsetX = currentPoint.x - self.initialMousePoint.x;
    CGFloat offsetY = currentPoint.y - self.initialMousePoint.y;
    
    [self.dragGroupDelegate didMoveByOffset:NSMakePoint(offsetX, offsetY)];
}

- (void) mouseUp:(NSEvent *)theEvent {
    if (self.isDragging)
        [self.dragGroupDelegate didStopMoving];
    
    self.isDragging = NO;
    [self.window invalidateCursorRectsForView:self];
}


@end
