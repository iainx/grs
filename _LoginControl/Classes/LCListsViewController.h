//
//  SDListsViewController.h
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LCListsViewController;
@class LCList;

@protocol LCListsViewControllerDelegate

- (void) listsViewController:(LCListsViewController*)controller didSwitchToList:(LCList*)list;

@end

@interface LCListsViewController : NSViewController {
	IBOutlet NSTableView *listsTableView;
    
    IBOutlet NSMenu *noSelectedListContextMenu;
    IBOutlet NSMenu *listContextMenu;
    
    IBOutlet NSButton *deleteListButton;
    
	NSMutableArray *lists;
    LCList *selectedList;
    
    LCList *listBeingDragged;
    
    id <LCListsViewControllerDelegate> delegate;
}

@property (assign) id <LCListsViewControllerDelegate> delegate;

- (IBAction) performNewList:(id)sender;
- (IBAction) performDuplicateList:(id)sender;
- (IBAction) performDeleteList:(id)sender;
- (IBAction) performMakeListLive:(id)sender;

@end
