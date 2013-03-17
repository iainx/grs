//
//  DLCloseButton.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/16/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLCloseButton.h"

@implementation DLCloseButton

- (void) resetCursorRects {
    [self addCursorRect:[self visibleRect] cursor:[NSCursor arrowCursor]];
}

- (BOOL) acceptsFirstResponder {
    return NO;
}

@end
