//
//  SDArrangeDesktopWindow.m
//  DeskLabels
//
//  Created by Steven Degutis on 2/25/13.
//
//

#import "DLArrangeDesktopWindow.h"

@implementation DLArrangeDesktopWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if (self = [super initWithContentRect:[[NSScreen mainScreen] frame]
                         styleMask:NSBorderlessWindowMask
                           backing:bufferingType
                             defer:flag])
    {
        [self setBackgroundColor:[NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setLevel:kCGDesktopIconWindowLevel + 1];
        [self setAnimationBehavior:NSWindowAnimationBehaviorNone];
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary];
        
//        NSNotificationCenter* nc = [[NSWorkspace sharedWorkspace] notificationCenter];
//        [nc addObserver:self
//               selector:@selector(activeSpaceDidChange:)
//                   name:NSWorkspaceActiveSpaceDidChangeNotification
//                 object:nil];
	}
	return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

@end
