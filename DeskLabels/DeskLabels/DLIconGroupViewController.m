//
//  DLIconGroupViewController.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLIconGroupViewController.h"

#import "DLDesktopIcon.h"
#import "DLNoteWindowController.h"

@interface DLIconGroupViewController ()

@property (weak) IBOutlet DLMovableIconGroupView* movableIconGroupView;

@property NSArray* movableDesktopIcons;
@property NSArray* movableNotes;

@property NSPoint initialBoxPoint;

@end

@implementation DLIconGroupViewController

- (NSString*) nibName {
    return @"IconGroup";
}

- (IBAction) killIconGroup:(id)sender {
    self.iconGroupKilled(self);
}

- (void) addToView:(NSView*)superview withBoxFrame:(NSRect)box desktopIcons:(NSArray*)desktopIcons notes:(NSArray*)notes {
    // adjust for inner movable view
    box = NSInsetRect(box, -20, -20);
    self.view.frame = box;
    
    [superview addSubview:self.view];
    
    NSRect movableViewBounds = [[self.movableIconGroupView window] convertRectToScreen:[self.movableIconGroupView convertRect:[self.movableIconGroupView bounds] toView:nil]];
    
    self.movableDesktopIcons = [desktopIcons filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DLDesktopIcon* desktopIcon, NSDictionary *bindings)
    {
        NSPoint convertedPoint = desktopIcon.initialPosition;
        convertedPoint.y = [[[self.view window] screen] frame].size.height - desktopIcon.initialPosition.y;
        return NSPointInRect(convertedPoint, movableViewBounds);
    }]];
    
    self.movableNotes = [notes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DLNoteWindowController* noteController, NSDictionary *bindings)
    {
        return NSIntersectsRect(movableViewBounds, [noteController labelRectInScreen]);
    }]];
}

- (void) didStartMoving {
    self.initialBoxPoint = [self.view frame].origin;
    
    for (DLNoteWindowController* noteController in self.movableNotes) {
        [noteController recordInitialPosition];
    }
}

- (void) didMoveByOffset:(NSPoint)offset {
    NSRect newFrame = [self.view frame];
    newFrame.origin.x = self.initialBoxPoint.x + offset.x;
    newFrame.origin.y = self.initialBoxPoint.y + offset.y;
    [self.view setFrame:newFrame];
    
    for (DLDesktopIcon* desktopIcon in self.movableDesktopIcons) {
        [desktopIcon setCurrentPositionByOffset:offset];
    }
    
    for (DLNoteWindowController* noteController in self.movableNotes) {
        [noteController setCurrentPositionByOffset:offset];
    }
}

- (void) didStopMoving {
    for (DLDesktopIcon* desktopIcon in self.movableDesktopIcons) {
        [desktopIcon resetInitialPosition];
    }
}

@end
