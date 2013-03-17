//
//  SDMoveAroundView.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/14/13.
//
//

#import "DLMovableIconGroupView.h"

//#import "DLFinderProxy.h"
//
//#import "Finder.h"


//#import "DLNoteWindowController.h"


@interface DLMovableIconGroupView ()

@property NSPoint initialMousePoint;
@property NSPoint initialBoxPoint;

@property BOOL didDrag;

@end


@implementation DLMovableIconGroupView

//- (void)cursorUpdate:(NSEvent *)event {
//    [[NSCursor openHandCursor] set];
//}

- (void) resetCursorRects {
    [self discardCursorRects];
    
    NSCursor* cursor = self.didDrag ? [NSCursor closedHandCursor] : [NSCursor openHandCursor];
    [self addCursorRect:[self visibleRect] cursor:cursor];
//    [cursor setOnMouseEntered:YES];
    
//    cursor = [NSCursor crosshairCursor];
//    [self addCursorRect:[self visibleRect] cursor:cursor];
//    [cursor setOnMouseExited:YES];
}

- (void) mouseMoved:(NSEvent *)theEvent {
    [self.window invalidateCursorRectsForView:self];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [[self window] invalidateCursorRectsForView:self];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect box = [self bounds];
    
    [[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
    [NSBezierPath fillRect:box];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.4] setFill];
    [NSBezierPath strokeRect:box];
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.didDrag = NO;
    
    [[self window] invalidateCursorRectsForView:self];
    
    [self.delegate didStartMoving];
    
    NSPoint p = [theEvent locationInWindow];
    self.initialMousePoint = NSMakePoint(round(p.x), round(p.y));
}

- (void) mouseDragged:(NSEvent *)theEvent {
    self.didDrag = YES;
    
    NSPoint currentPoint = [theEvent locationInWindow];
    
    CGFloat offsetX = currentPoint.x - self.initialMousePoint.x;
    CGFloat offsetY = currentPoint.y - self.initialMousePoint.y;
    
    [self.delegate didMoveByOffset:NSMakePoint(offsetX, offsetY)];
}

- (void) mouseUp:(NSEvent *)theEvent {
    if (self.didDrag)
        [self.delegate didStopMoving];
    
    self.didDrag = NO;
    [[self window] invalidateCursorRectsForView:self];
}

@end
