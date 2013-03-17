//
//  SDResizeJunkView.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/1/13.
//
//

#import "DLArrangeDesktopView.h"


@interface DLArrangeDesktopView ()

@property NSPoint initialPoint;
@property NSPoint currentPoint;

@property BOOL didDrag;

@end

@implementation DLArrangeDesktopView

- (void) resetCursorRects {
    NSCursor* cursor = [NSCursor crosshairCursor];
    [self addCursorRect:[self visibleRect] cursor:cursor];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self setBoxType:NSBoxCustom];
    [self setFillColor:[[NSColor blackColor] colorWithAlphaComponent:0.25]];
}

- (NSRect) currentIconsBoxRect {
    CGFloat x = MIN(self.initialPoint.x, self.currentPoint.x);
    CGFloat y = MIN(self.initialPoint.y, self.currentPoint.y);
    
    CGFloat width = abs(self.initialPoint.x - self.currentPoint.x);
    CGFloat height = abs(self.initialPoint.y - self.currentPoint.y);
    
    NSRect box = NSMakeRect(x, y, width, height);
    box = NSIntegralRect(box);
    box = NSInsetRect(box, 0.5, 0.5);
    return box;
}

- (void) drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (NSEqualPoints(self.initialPoint, NSZeroPoint))
        return;
    
    NSRect box = [self currentIconsBoxRect];
    
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:box xRadius:12 yRadius:12];
    
    CGFloat array[2];
    array[0] = 7.0; //segment painted with stroke color
    array[1] = 4.0; //segment not painted with a color
    
    [path setLineWidth:2.0];
    [path setLineDash:array count:2 phase:0];
    
    [[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
    [path fill];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.8] setStroke];
    [path stroke];
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.didDrag = NO;
    
    NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    self.initialPoint = NSMakePoint(round(p.x), round(p.y));
}

- (void) mouseDragged:(NSEvent *)theEvent {
    self.didDrag = YES;
    
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent *)theEvent {
    if (self.didDrag) {
        self.wantsBoxInRect([self currentIconsBoxRect]);
        return;
    }
    
    self.initialPoint = NSZeroPoint;
    self.currentPoint = NSZeroPoint;
    
    [self setNeedsDisplay:YES];
    
    self.didDrag = NO;
}

@end
