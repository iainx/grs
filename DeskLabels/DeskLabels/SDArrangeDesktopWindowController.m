//
//  SDArrangeDesktopWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 2/25/13.
//
//

#import "SDArrangeDesktopWindowController.h"

//#import "DLFinderProxy.h"

#import "DLIconGroupViewController.h"

#import "SDMoveAroundView.h"


@implementation SDArrangeDesktopWindowController

- (NSString*) windowNibName {
    return @"ArrangeDesktopWindow";
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    NSRect frame = self.button.frame;
    frame.origin.y = NSHeight([[[self window] screen] frame]) - 70.0 - NSHeight(frame);
    self.button.frame = frame;
    
    self.resizeJunkView.wantsBoxInRect = ^(NSRect box) {
        box = NSInsetRect(box, -20, -20);
        
        DLIconGroupViewController* iconGroupController = [[DLIconGroupViewController alloc] init];
        iconGroupController.view.frame = box;
        [self.resizeJunkView addSubview:iconGroupController.view];
        
        [iconGroupController.moveAroundView takeNoticeOfIcons];
        [iconGroupController.moveAroundView takeNoticeOfLabels:self.noteControllers];
    };
}

- (IBAction) doneArrangingDesktop:(id)sender {
    [self close];
}

@end
