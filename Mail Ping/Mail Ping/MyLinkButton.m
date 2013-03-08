//
//  MyLinkButton.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/21/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyLinkButton.h"

@implementation MyLinkButton

- (void) resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

@end
