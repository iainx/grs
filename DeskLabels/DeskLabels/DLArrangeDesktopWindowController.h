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

@property NSArray* noteControllers;

@property (copy) dispatch_block_t doneArrangingDesktop;

@end
