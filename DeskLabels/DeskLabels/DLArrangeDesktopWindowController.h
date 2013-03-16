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

@property (weak) IBOutlet DLArrangeDesktopView* resizeJunkView;
@property (weak) IBOutlet NSButton* button;

@property NSArray* noteControllers;

@end
