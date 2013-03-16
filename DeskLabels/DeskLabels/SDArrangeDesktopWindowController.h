//
//  SDArrangeDesktopWindowController.h
//  DeskLabels
//
//  Created by Steven Degutis on 2/25/13.
//
//

#import <Cocoa/Cocoa.h>

#import "SDResizeJunkView.h"

@interface SDArrangeDesktopWindowController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet SDResizeJunkView* resizeJunkView;
@property (weak) IBOutlet NSButton* button;

@property NSArray* noteControllers;

@end
