//
//  SDItemsViewController.h
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LCList;

@interface LCItemsViewController : NSViewController {
	IBOutlet NSTableView *itemsTableView;
    LCList *representedList;
    
    IBOutlet NSMenu *fileContextMenu;
    IBOutlet NSMenu *noSelectedFileContextMenu;
    
    IBOutlet NSButton *addFilesButton;
    IBOutlet NSButton *deleteFilesButton;
    
    NSArray *selectedItems;
}

@property (assign) LCList *representedList;

- (void) didSwitchToDifferentList;

- (IBAction) performAddItem:(id)sender;
- (IBAction) performRemoveSelectedItems:(id)sender;
- (IBAction) performRevealItemsInFinder:(id)sender;

@end
