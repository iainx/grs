//
//  SDMoveAroundView.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/14/13.
//
//

#import "SDMoveAroundView.h"

#import "DLFinderProxy.h"

#import "Finder.h"


#import "DLNoteWindowController.h"


@interface SDMoveAroundView ()

@property NSPoint initialMousePoint;
@property NSPoint initialBoxPoint;

@property NSArray* desktopIcons;
@property NSArray* deskLabels;

@property BOOL didDrag;

@end


@implementation SDMoveAroundView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect box = [self bounds];
    
    [[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
    [NSBezierPath fillRect:box];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.4] setFill];
    [NSBezierPath strokeRect:box];
}

- (void) resetCursorRects {
    [self addCursorRect:[self visibleRect] cursor:[NSCursor crosshairCursor]];
}

- (void) takeNoticeOfIcons {
    NSMutableArray* desktopIcons = [NSMutableArray array];
    
    NSRect myBounds = [[self window] convertRectToScreen:[self convertRect:[self bounds] toView:nil]];
    
    SBElementArray* icons = [[DLFinderProxy finderProxy] desktopIcons];
    NSArray* positions = [icons arrayByApplyingSelector:@selector(desktopPosition)];
    
    for (int i = 0; i < [icons count]; i++) {
        FinderItem* icon = [icons objectAtIndex:i];
        NSValue* position = [positions objectAtIndex:i];
        NSPoint pos = [position pointValue];
        
        NSPoint convertedPoint = pos;
        convertedPoint.y = [[[self window] screen] frame].size.height - pos.y;
        
        if (!NSPointInRect(convertedPoint, myBounds))
            continue;
        
        [desktopIcons addObject:[@{
         @"item": icon,
         @"initialPoint": NSStringFromPoint(pos),
         } mutableCopy]];
    }
    
    self.desktopIcons = desktopIcons;
}

- (void) takeNoticeOfLabels:(NSArray*)labels {
//    NSMutableArray* deskLabels = [NSMutableArray array];
//    
//    NSRect myBounds = [[self window] convertRectToScreen:[self convertRect:[self bounds] toView:nil]];
//    
//    for (DLNoteWindowController* noteController in labels) {
//        NSRect labelRect = NSInsetRect([[[noteController window] contentView] frame], 36, 30);
//        
//        NSLog(@"%@", NSStringFromRect(labelRect));
//        
//        if (!NSIntersectsRect(labelRect, myBounds))
//            continue;
//        
//        [deskLabels addObject:[@{
//                               @"item": icon,
//                               @"initialPoint": NSStringFromPoint(pos),
//                               } mutableCopy]];
//    }
//    
//    self.deskLabels = deskLabels;
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.didDrag = NO;
    
    NSPoint p = [theEvent locationInWindow];
    self.initialMousePoint = NSMakePoint(round(p.x), round(p.y));
    self.initialBoxPoint = [[self superview] frame].origin;
}

- (void) mouseDragged:(NSEvent *)theEvent {
    self.didDrag = YES;
    
    NSPoint currentPoint = [theEvent locationInWindow];
    
    CGFloat offsetX = currentPoint.x - self.initialMousePoint.x;
    CGFloat offsetY = currentPoint.y - self.initialMousePoint.y;
    
    
    NSRect newFrame = [[self superview] frame];
    newFrame.origin.x = self.initialBoxPoint.x + offsetX;
    newFrame.origin.y = self.initialBoxPoint.y + offsetY;
    [[self superview] setFrame:newFrame];
    
    
    for (NSMutableDictionary* itemDict in self.desktopIcons) {
        FinderItem* item = [itemDict objectForKey:@"item"];
        NSString* pointStr = [itemDict objectForKey:@"initialPoint"];
        NSPoint point = NSPointFromString(pointStr);
        
        point.x += offsetX;
        point.y -= offsetY;
        
        item.desktopPosition = point;
    }
}

- (void) mouseUp:(NSEvent *)theEvent {
    if (self.didDrag) {
        NSPoint currentPoint = [theEvent locationInWindow];
        
        CGFloat offsetX = currentPoint.x - self.initialMousePoint.x;
        CGFloat offsetY = currentPoint.y - self.initialMousePoint.y;
        
        for (NSMutableDictionary* itemDict in self.desktopIcons) {
            NSString* pointStr = [itemDict objectForKey:@"initialPoint"];
            NSPoint point = NSPointFromString(pointStr);
            
            point.x += offsetX;
            point.y -= offsetY;
            
            [itemDict setObject:NSStringFromPoint(point)
                         forKey:@"initialPoint"];
        }
    }
}

- (IBAction) killIconGroupBox:(NSView*)sender {
    [[self superview] removeFromSuperview];
}

@end
