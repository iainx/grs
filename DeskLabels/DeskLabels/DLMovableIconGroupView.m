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

- (void)drawRect:(NSRect)dirtyRect {
    NSRect box = [self bounds];
    
    [[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
    [NSBezierPath fillRect:box];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.4] setFill];
    [NSBezierPath strokeRect:box];
}

- (void) resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:[self visibleRect] cursor:[NSCursor crosshairCursor]];
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.didDrag = NO;
    
    [self.delegate didStartMoving];
    
    NSPoint p = [theEvent locationInWindow];
    self.initialMousePoint = NSMakePoint(round(p.x), round(p.y));
//    self.initialBoxPoint = [[self superview] frame].origin;
}

- (void) mouseDragged:(NSEvent *)theEvent {
    self.didDrag = YES;
    
    NSPoint currentPoint = [theEvent locationInWindow];
    
    CGFloat offsetX = currentPoint.x - self.initialMousePoint.x;
    CGFloat offsetY = currentPoint.y - self.initialMousePoint.y;
    
    [self.delegate didMoveByOffset:NSMakePoint(offsetX, offsetY)];
    
//    
//    NSRect newFrame = [[self superview] frame];
//    newFrame.origin.x = self.initialBoxPoint.x + offsetX;
//    newFrame.origin.y = self.initialBoxPoint.y + offsetY;
//    [[self superview] setFrame:newFrame];
//    
//    
//    for (NSMutableDictionary* itemDict in self.desktopIcons) {
//        FinderItem* item = [itemDict objectForKey:@"item"];
//        NSString* pointStr = [itemDict objectForKey:@"initialPoint"];
//        NSPoint point = NSPointFromString(pointStr);
//        
//        point.x += offsetX;
//        point.y -= offsetY;
//        
//        item.desktopPosition = point;
//    }
}

- (void) mouseUp:(NSEvent *)theEvent {
    if (self.didDrag) {
        
        [self.delegate didStopMoving];
        
//        NSPoint currentPoint = [theEvent locationInWindow];
//        
//        CGFloat offsetX = currentPoint.x - self.initialMousePoint.x;
//        CGFloat offsetY = currentPoint.y - self.initialMousePoint.y;
//        
//        for (NSMutableDictionary* itemDict in self.desktopIcons) {
//            NSString* pointStr = [itemDict objectForKey:@"initialPoint"];
//            NSPoint point = NSPointFromString(pointStr);
//            
//            point.x += offsetX;
//            point.y -= offsetY;
//            
//            [itemDict setObject:NSStringFromPoint(point)
//                         forKey:@"initialPoint"];
//        }
    }
}

@end
