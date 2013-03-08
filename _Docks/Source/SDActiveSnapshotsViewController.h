//
//  SDActiveSnapshotsViewController.h
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDViewController.h"

@interface SDActiveSnapshotsViewController : SDViewController {
	IBOutlet NSTableView *tableView;
	IBOutlet NSImageCell *snapshotCell;
	
	IBOutlet NSArrayController *snapshotsArrayController;
	
	IBOutlet NSPopUpButton *restoreSpacePopupButton;
}

@end
