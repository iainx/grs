//
//  SDMainWindowController.h
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LCListsViewController.h"
@class LCItemsViewController;

@interface LCMainWindowController : NSWindowController <LCListsViewControllerDelegate> {
    IBOutlet NSSplitView *mainSplitView;
    
    LCListsViewController *listsViewController;
    LCItemsViewController *itemsViewController;
    
    NSUndoManager *undoManager;
}

@end
