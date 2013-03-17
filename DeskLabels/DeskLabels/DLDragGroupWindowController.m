//
//  DLDragGroupWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLDragGroupWindowController.h"

#import "DLDragBox.h"

@interface DLDragGroupWindowController ()

@property (weak) IBOutlet DLDragBox* dragBox;

@property NSPoint initialPosition;

@end

@implementation DLDragGroupWindowController

- (NSString*) windowNibName {
    return @"DragGroupWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setMovableByWindowBackground:YES];
}

- (void) mouseDown:(NSEvent *)theEvent {
    self.initialPosition = [self.window frame].origin;
    
    [self.dragBox startedDragging];
}

- (void) mouseDragged:(NSEvent *)theEvent {
}

- (void) mouseUp:(NSEvent *)theEvent {
    [self.dragBox stoppedDragging];
}

- (IBAction) killDragWindow:(id)sender {
    [self close];
    self.dragGroupKilled(self);
}

@end
