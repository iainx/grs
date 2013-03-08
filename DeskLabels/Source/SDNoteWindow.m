//
//  SDMainWindow.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDNoteWindow.h"

#import "SDEditTitleController.h"

@implementation SDNoteWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ([super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag]) {
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setLevel:kCGDesktopIconWindowLevel + 1];
        [self setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary];
        
        NSNotificationCenter* nc = [[NSWorkspace sharedWorkspace] notificationCenter];
        [nc addObserver:self
               selector:@selector(activeSpaceDidChange:)
                   name:NSWorkspaceActiveSpaceDidChangeNotification
                 object:nil];
	}
	return self;
}

- (void) activeSpaceDidChange:(NSNotification*)aNotification {
    [self orderFront:self];
}

- (void) mouseDown:(NSEvent*)event {
	if ([event clickCount] == 2)
		[self tryToPerform:@selector(editTitle) with:nil];
}

@end
