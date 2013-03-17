//
//  DLDragGroupWindowController.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DLDragGroupView.h"

@interface DLDragGroupWindowController : NSWindowController <NSWindowDelegate, DLDragGroupViewDelegate>

@property (copy) void(^dragGroupKilled)(DLDragGroupWindowController* me);

- (void) useBox:(NSRect)box withNoteControllers:(NSArray*)noteControllers;

@end
