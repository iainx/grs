//
//  SDArrangeDesktopWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 2/25/13.
//
//

#import "DLArrangeDesktopWindowController.h"

#import "DLFinderProxy.h"

#import "DLIconGroupViewController.h"

#import "DLMovableIconGroupView.h"


@interface DLArrangeDesktopWindowController ()

@property (weak) IBOutlet DLArrangeDesktopView* arrangeDesktopView;
@property (weak) IBOutlet NSButton* button;

@property NSMutableArray* iconGroups;

@property NSArray* desktopIcons;

@end


@implementation DLArrangeDesktopWindowController

- (NSString*) windowNibName {
    return @"ArrangeDesktopWindow";
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self.window invalidateCursorRectsForView:self.arrangeDesktopView];
    
    self.desktopIcons = [[DLFinderProxy finderProxy] desktopIcons];
    
    self.iconGroups = [NSMutableArray array];
    
    NSRect frame = self.button.frame;
    frame.origin.y = NSHeight([[[self window] screen] frame]) - 70.0 - NSHeight(frame);
    self.button.frame = frame;
    
    __weak DLArrangeDesktopWindowController* weakSelf = self;
    
    self.arrangeDesktopView.wantsBoxInRect = ^(NSRect box) {
        DLIconGroupViewController* iconGroupController = [[DLIconGroupViewController alloc] init];
        
        [iconGroupController addToView:weakSelf.arrangeDesktopView
                          withBoxFrame:box
                          desktopIcons:weakSelf.desktopIcons
                                 notes:weakSelf.noteControllers];
        
        [weakSelf.iconGroups addObject:iconGroupController];
        iconGroupController.iconGroupKilled = ^(DLIconGroupViewController* iconGroup) {
            [iconGroup.view removeFromSuperview];
            [weakSelf.iconGroups removeObject:iconGroup];
        };
    };
}

- (IBAction) doneArrangingDesktop:(id)sender {
    [self close];
    
    self.doneArrangingDesktop();
}

@end
