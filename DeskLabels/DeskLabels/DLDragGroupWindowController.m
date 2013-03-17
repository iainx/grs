//
//  DLDragGroupWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLDragGroupWindowController.h"

#import "DLDragGroupView.h"

#import "DLFinderProxy.h"

#import "DLNoteWindowController.h"

@interface DLDragGroupWindowController ()

@property (weak) IBOutlet NSBox* dragGroupBox;

@property NSArray* movableDesktopIcons;
@property NSArray* movableNotes;

@end

@implementation DLDragGroupWindowController

- (NSString*) windowNibName {
    return @"DragGroupWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setMovableByWindowBackground:YES];
    
    DLDragGroupView* dragGroupView = [[DLDragGroupView alloc] init];
    dragGroupView.dragGroupDelegate = self;
    [self.dragGroupBox setContentView:dragGroupView];
}

- (IBAction) killDragWindow:(id)sender {
    [self close];
    self.dragGroupKilled(self);
}

#pragma mark - Setting up

- (void) useBox:(NSRect)box withNoteControllers:(NSArray*)notes {
    [self.window setFrame:NSInsetRect(box, -12, -12)
                  display:YES
                  animate:NO];
    
    NSArray* desktopIcons = [[DLFinderProxy finderProxy] desktopIcons];
    
    NSRect movableViewBounds = [self.window convertRectToScreen:[self.dragGroupBox convertRect:[self.dragGroupBox bounds] toView:nil]];
    
    self.movableDesktopIcons = [desktopIcons filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DLDesktopIcon* desktopIcon, NSDictionary *bindings)
                                                                          {
                                                                              NSPoint convertedPoint = desktopIcon.initialPosition;
                                                                              convertedPoint.y = [[self.window screen] frame].size.height - desktopIcon.initialPosition.y;
                                                                              return NSPointInRect(convertedPoint, movableViewBounds);
                                                                          }]];
    
    self.movableNotes = [notes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DLNoteWindowController* noteController, NSDictionary *bindings)
                                                            {
                                                                return NSIntersectsRect(movableViewBounds, [noteController labelRectInScreen]);
                                                            }]];
}

#pragma mark - Drag stuff

- (void) didStartMoving {
    for (DLNoteWindowController* noteController in self.movableNotes) {
        [noteController recordInitialPosition];
    }
}

- (void) didStopMoving {
    for (DLDesktopIcon* desktopIcon in self.movableDesktopIcons) {
        [desktopIcon resetInitialPosition];
    }
}

- (void) didMoveByOffset:(NSPoint)offset {
    for (DLDesktopIcon* desktopIcon in self.movableDesktopIcons) {
        [desktopIcon setCurrentPositionByOffset:offset];
    }
    
    for (DLNoteWindowController* noteController in self.movableNotes) {
        [noteController setCurrentPositionByOffset:offset];
    }
}

@end
