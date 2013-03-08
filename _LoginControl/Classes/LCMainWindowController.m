//
//  SDMainWindowController.m
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "LCMainWindowController.h"

#import "LCItemsViewController.h"

//#import "SDLoginItemListManager.h"
//#import <NDAlias/NDAlias.h>

@interface LCMainWindowController ()
@end

@implementation LCMainWindowController

- (id) init {
	if (self = [super initWithWindowNibName:@"MainWindow"]) {
        listsViewController = [[LCListsViewController alloc] init];
        itemsViewController = [[LCItemsViewController alloc] init];
        
        listsViewController.delegate = self;
        
        undoManager = [[NSUndoManager alloc] init];
	}
	return self;
}

- (void) dealloc {
    [undoManager release];
    
    [listsViewController release];
    [itemsViewController release];
    
	[super dealloc];
}

- (void) windowDidLoad {
    [mainSplitView addSubview:[listsViewController view]];
    [mainSplitView addSubview:[itemsViewController view]];
    
    [self setNextResponder:listsViewController];
    [listsViewController setNextResponder:itemsViewController];
}

- (void) listsViewController:(LCListsViewController*)controller didSwitchToList:(LCList*)list {
    itemsViewController.representedList = list;
    [itemsViewController didSwitchToDifferentList];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return undoManager;
}

@end
