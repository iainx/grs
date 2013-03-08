//
//  LCDragOffWindow.h
//  LoginControl
//
//  Created by Steven Degutis on 5/31/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LCDragOffWindow : NSWindow {
    NSArray *deletionTypes;
    id delegate;
}

+ (LCDragOffWindow*) sharedWindow;

- (void) showBelowWindowIfNeeded:(NSWindow*)window delegate:(id)someDelegate;
- (void) hideOnNextRunloop;

- (void) registerDragOffTypes:(NSArray*)types;

@end

@interface NSObject (LCDraggingOffDelegation)

- (BOOL) dragOffWindow:(LCDragOffWindow*)dragOffWindow shouldDragOff:(id<NSDraggingInfo>)info;

@end
