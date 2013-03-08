//
//  SDTableView.m
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import "LCTableView.h"

#import "LCDragOffWindow.h"

@implementation LCTableView

- (NSMenu*) menuForEvent:(NSEvent *)event {
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:p];
    if ([[self delegate] respondsToSelector:@selector(tableView:menuForRow:)])
        [self setMenu:[[self delegate] tableView:self menuForRow:row]];
    return [super menuForEvent:event];
}

- (void) keyDown:(NSEvent *)theEvent {
    unichar firstChar = [[theEvent characters] characterAtIndex:0];
    
    BOOL userPressedDeleteKey = (firstChar == NSDeleteFunctionKey || firstChar == NSDeleteCharFunctionKey || firstChar == NSDeleteCharacter);
    BOOL delegateCares = [[self delegate] respondsToSelector:@selector(tableViewDidReceiveDeleteRequest:)];
    BOOL holdingCommand = (([theEvent modifierFlags] & NSCommandKeyMask) != 0);
    
    if (userPressedDeleteKey && delegateCares && holdingCommand)
        [[self delegate] tableViewDidReceiveDeleteRequest:self];
    else
        [super keyDown:theEvent];
}

- (void)dragImage:(NSImage *)anImage
               at:(NSPoint)imageLoc
           offset:(NSSize)mouseOffset
            event:(NSEvent *)theEvent
       pasteboard:(NSPasteboard *)pboard
           source:(id)sourceObject
        slideBack:(BOOL)slideBack
{
    LCDragOffWindow *dragOffWindow = [LCDragOffWindow sharedWindow];
    
    [dragOffWindow showBelowWindowIfNeeded:[self window] delegate:self];
    
    [super dragImage:anImage
                  at:imageLoc
              offset:mouseOffset
               event:theEvent
          pasteboard:pboard
              source:sourceObject
           slideBack:slideBack];
    
    [dragOffWindow hideOnNextRunloop];
}

- (BOOL) dragOffWindow:(LCDragOffWindow*)dragOffWindow shouldDragOff:(id<NSDraggingInfo>)info {
    if ([[self delegate] respondsToSelector:@selector(tableView:shouldDragOffToDelete:)])
        return [[self delegate] tableView:self shouldDragOffToDelete:info];
    else
        return NO;
}

- (void) registerDragOffTypes:(NSArray*)types {
    LCDragOffWindow *dragOffWindow = [LCDragOffWindow sharedWindow];
    [dragOffWindow registerDragOffTypes:types];
}

@end
