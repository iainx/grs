//
//  DLDragGroupWindowController.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DLDragGroupWindowController : NSWindowController <NSWindowDelegate>

@property (copy) void(^dragGroupKilled)(DLDragGroupWindowController* me);

@end
