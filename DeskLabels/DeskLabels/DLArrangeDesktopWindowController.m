//
//  SDArrangeDesktopWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 2/25/13.
//
//

#import "DLArrangeDesktopWindowController.h"


@interface DLArrangeDesktopWindowController ()

@property (weak) IBOutlet DLArrangeDesktopView* arrangeDesktopView;

@end


@implementation DLArrangeDesktopWindowController

- (NSString*) windowNibName {
    return @"ArrangeDesktopWindow";
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    __weak DLArrangeDesktopWindowController* me = self;
    
    self.arrangeDesktopView.wantsBoxInRect = ^(NSRect box) {
        me.wantsBoxInRect(box);
        [me close];
    };
}

@end
