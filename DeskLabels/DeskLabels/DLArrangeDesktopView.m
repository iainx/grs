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
    
    [[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
    [NSBezierPath fillRect:box];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.4] setFill];
    [NSBezierPath strokeRect:box];
}

- (void) resetCursorRects {
    [self addCursorRect:[self visibleRect] cursor:[NSCursor crosshairCursor]];
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
        NSRect box = [self currentIconsBoxRect];
        
        box.origin.x -= 6.0;
        box.origin.y -= 6.0;
        
        self.wantsBoxInRect(box);
    }
    
    self.initialPoint = NSZeroPoint;
    self.currentPoint = NSZeroPoint;
    
    [self setNeedsDisplay:YES];
    
    self.didDrag = NO;
}

@end
