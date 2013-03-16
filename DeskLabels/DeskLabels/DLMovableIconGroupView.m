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

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self setBoxType:NSBoxCustom];
    [self setFillColor:[[NSColor whiteColor] colorWithAlphaComponent:0.1]];
    [self setBorderColor:[[NSColor blackColor] colorWithAlphaComponent:0.4]];
    [self setBorderType:NSLineBorder];
    [self setBorderWidth:1.0];
}

//- (void)drawRect:(NSRect)dirtyRect {
//    NSRect box = [self bounds];
//    
//    [[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
//    [NSBezierPath fillRect:box];
//    
//    [[[NSColor blackColor] colorWithAlphaComponent:0.4] setFill];
//    [NSBezierPath strokeRect:box];
//}

- (void) resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:[self visibleRect] cursor:[NSCursor crosshairCursor]];
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.didDrag = NO;
    
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
}

@end
