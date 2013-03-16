//
//  DLIconGroupViewController.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DLMovableIconGroupView.h"

@interface DLIconGroupViewController : NSViewController <DLMovableIconGroupViewDelegate>

@property (copy) void(^iconGroupKilled)(DLIconGroupViewController* me);

- (void) addToView:(NSView*)view withBoxFrame:(NSRect)box desktopIcons:(NSArray*)desktopIcons notes:(NSArray*)notes;

@end
