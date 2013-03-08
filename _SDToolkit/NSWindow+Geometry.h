//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (SDResizableWindow)

- (void) sd_setContentViewSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate;

- (NSRect) sd_windowFrameForNewContentViewSize:(NSSize)newSize;

@end
