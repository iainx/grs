//
//  SDArrangeDesktopWindowController.h
//  DeskLabels
//
//  Created by Steven Degutis on 2/25/13.
//
//

#import <Cocoa/Cocoa.h>

#import "DLArrangeDesktopView.h"

@interface DLArrangeDesktopWindowController : NSWindowController <NSWindowDelegate>

@property (copy) void(^wantsBoxInRect)(NSRect box);

@end
