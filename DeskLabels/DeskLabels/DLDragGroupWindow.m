//
//  DLDragGroupWindow.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLDragGroupWindow.h"

@interface DLDragGroupWindow ()

@property NSPoint initialMousePoint;

@property BOOL didDrag;

@end

@implementation DLDragGroupWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ([super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag]) {
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setLevel:kCGDesktopIconWindowLevel + 1];
//        [self setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary];
        
        NSNotificationCenter* nc = [[NSWorkspace sharedWorkspace] notificationCenter];
        [nc addObserver:self
               selector:@selector(activeSpaceDidChange:)
                   name:NSWorkspaceActiveSpaceDidChangeNotification
                 object:nil];
	}
	return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.didDrag = NO;
    
    [self.dragGroupDelegate didStartMoving];
    
    NSPoint p = [NSEvent mouseLocation];
    self.initialMousePoint = NSMakePoint(round(p.x), round(p.y));
}

- (void) mouseDragged:(NSEvent *)theEvent {
    self.didDrag = YES;
    
    NSPoint currentPoint = [NSEvent mouseLocation];
    
    CGFloat offsetX = currentPoint.x - self.initialMousePoint.x;
    CGFloat offsetY = currentPoint.y - self.initialMousePoint.y;
    
    [self.dragGroupDelegate didMoveByOffset:NSMakePoint(offsetX, offsetY)];
}

- (void) mouseUp:(NSEvent *)theEvent {
    if (self.didDrag)
        [self.dragGroupDelegate didStopMoving];
    
    self.didDrag = NO;
}

@end
