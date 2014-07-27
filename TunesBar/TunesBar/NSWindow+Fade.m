//
//  NSWindow+Fade.m
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "NSWindow+Fade.h"

static const CGFloat kWindowAnimationDuration = 0.1f;
@implementation NSWindow (Fade)

- (void)fadeIn
{
    [self setAlphaValue:0.f];
    [self makeKeyAndOrderFront:nil];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:kWindowAnimationDuration];
    [[self animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}

- (void)fadeOut
{
    [NSAnimationContext beginGrouping];
    __block __unsafe_unretained NSWindow *bself = self;
    [[NSAnimationContext currentContext] setDuration:kWindowAnimationDuration];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [bself orderOut:nil];
        [bself setAlphaValue:1.f];
    }];
    [[self animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}

@end
