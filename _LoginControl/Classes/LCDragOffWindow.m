//
//  LCDragOffWindow.m
//  LoginControl
//
//  Created by Steven Degutis on 5/31/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import "LCDragOffWindow.h"


@implementation LCDragOffWindow

+ (LCDragOffWindow*) sharedWindow {
    static LCDragOffWindow *sharedWindow;
    if (!sharedWindow)
        sharedWindow = [[LCDragOffWindow alloc] init];
    return sharedWindow;
}

- (id) init {
    NSRect allScreensRect = NSZeroRect;
    for (NSScreen *screen in [NSScreen screens])
        allScreensRect = NSUnionRect(allScreensRect, [screen frame]);
    
    if ((self = [super initWithContentRect:allScreensRect
                                 styleMask:NSBorderlessWindowMask
                                   backing:NSBackingStoreBuffered
                                     defer:NO]))
    {
        [self setBackgroundColor:[NSColor clearColor]];
        [self setAlphaValue:0.0];
        [self setIgnoresMouseEvents:NO];
        [self setOpaque:NO];
        [self useOptimizedDrawing:NO];
    }
    return self;
}

- (void) dealloc {
    [deletionTypes release];
    [super dealloc];
}

#pragma mark -
#pragma mark utilities

- (void) showBelowWindowIfNeeded:(NSWindow*)window delegate:(id)someDelegate {
    delegate = someDelegate;
    
    if (deletionTypes) {
        [self unregisterDraggedTypes];
        [self registerForDraggedTypes:deletionTypes];
        [self orderWindow:NSWindowBelow
               relativeTo:[window windowNumber]];
    }
}

- (void) registerDragOffTypes:(NSArray*)types {
    deletionTypes = [types copy];
}

- (void) hide {
    [self orderOut:self];
    
    delegate = nil;
    
    [deletionTypes release];
    deletionTypes = nil;
}

- (void) hideOnNextRunloop {
    if (deletionTypes) {
        [self performSelector:@selector(hide)
                   withObject:nil
                   afterDelay:0.0];
    }
}

#pragma mark -
#pragma mark drag + drop support

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
	[[NSCursor disappearingItemCursor] push];
	return NSDragOperationDelete;
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender {
	return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    if ([delegate respondsToSelector:@selector(dragOffWindow:shouldDragOff:)])
        return [delegate dragOffWindow:self shouldDragOff:sender];
    else
        return NO;
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
	NSShowAnimationEffect(NSAnimationEffectPoof,
                          [sender draggingLocation],
                          NSZeroSize,
                          nil,
                          NULL,
                          NULL);
}

@end
