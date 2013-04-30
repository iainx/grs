//
//  BMWindow.m
//  BiggerMouse
//
//  Created by Steven on 4/12/13.
//  Copyright (c) 2013 Steven. All rights reserved.
//

#import "BMWindow.h"

@implementation BMWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if (self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag]) {
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
        
        self.ignoresMouseEvents = YES;
        self.level = NSFloatingWindowLevel;
        
        //        [self setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary];
	}
	return self;
}

@end
