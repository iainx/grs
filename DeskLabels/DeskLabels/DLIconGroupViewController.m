//
//  DLIconGroupViewController.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLIconGroupViewController.h"

#import "DLDesktopIcon.h"

@interface DLIconGroupViewController ()

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
    
    NSRect movableViewBounds = [[self.view window] convertRectToScreen:[self.view convertRect:[self.view bounds] toView:nil]];
    
    self.movableDesktopIcons = [desktopIcons filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DLDesktopIcon* desktopIcon, NSDictionary *bindings)
    {
        NSPoint convertedPoint = desktopIcon.initialPosition;
        convertedPoint.y = [[[self.view window] screen] frame].size.height - desktopIcon.initialPosition.y;
        return NSPointInRect(convertedPoint, movableViewBounds);
    }]];
}

- (void) didStartMoving {
    self.initialBoxPoint = [self.view frame].origin;
}

- (void) didMoveByOffset:(NSPoint)offset {
    NSRect newFrame = [self.view frame];
    newFrame.origin.x = self.initialBoxPoint.x + offset.x;
    newFrame.origin.y = self.initialBoxPoint.y + offset.y;
    [self.view setFrame:newFrame];
    
    for (DLDesktopIcon* desktopIcon in self.movableDesktopIcons) {
        [desktopIcon setCurrentPositionByOffset:offset];
    }
}

- (void) didStopMoving {
    for (DLDesktopIcon* desktopIcon in self.movableDesktopIcons) {
        [desktopIcon resetInitialPosition];
    }
}

//- (void) takeNoticeOfLabels:(NSArray*)labels {
//    //    NSMutableArray* deskLabels = [NSMutableArray array];
//    //
//    //    NSRect myBounds = [[self window] convertRectToScreen:[self convertRect:[self bounds] toView:nil]];
//    //
//    //    for (DLNoteWindowController* noteController in labels) {
//    //        NSRect labelRect = NSInsetRect([[[noteController window] contentView] frame], 36, 30);
//    //
//    //        NSLog(@"%@", NSStringFromRect(labelRect));
//    //
//    //        if (!NSIntersectsRect(labelRect, myBounds))
//    //            continue;
//    //
//    //        [deskLabels addObject:[@{
//    //                               @"item": icon,
//    //                               @"initialPoint": NSStringFromPoint(pos),
//    //                               } mutableCopy]];
//    //    }
//    //
//    //    self.deskLabels = deskLabels;
//}

@end
