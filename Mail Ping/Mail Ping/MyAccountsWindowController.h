//
//  MyAccountsWindowController.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MyAddAccountWindowController.h"

@interface MyAccountsWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property MyAddAccountWindowController *myAddAccountWindowController;

@property NSIndexSet* accountSelectionIndexes;
@property (weak) IBOutlet NSTableView* accountsTableView;

@property (weak) IBOutlet NSButton* orderMattersButton;

@end
