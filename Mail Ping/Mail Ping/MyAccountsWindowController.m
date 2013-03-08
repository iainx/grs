//
//  MyAccountsWindowController.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyAccountsWindowController.h"

#import "EmailAccountsController.h"

#define MyEmailAccountType @"MyEmailAccountType"

@implementation MyAccountsWindowController

- (NSString*) windowNibName {
    return @"MyAccountsWindow";
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self.accountsTableView registerForDraggedTypes:@[MyEmailAccountType]];
    
    NSAttributedString* attrTitle = [[NSAttributedString alloc] initWithString:@"Order Matters" attributes:@{
                                                 NSUnderlineStyleAttributeName: @(NSSingleUnderlineStyle),
                                                NSForegroundColorAttributeName: [NSColor blueColor]}];
    
    [self.orderMattersButton setAttributedTitle:attrTitle];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) addAccount:(id)sender {
    self.myAddAccountWindowController = [[MyAddAccountWindowController alloc] init];
    
    [NSApp beginSheet:[self.myAddAccountWindowController window]
       modalForWindow:[self window]
        modalDelegate:self
       didEndSelector:@selector(addAccountSheetDidEnd:returnCode:contextInfo:)
          contextInfo:NULL];
}

- (void) addAccountSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode) {
        [EmailAccountsController addEmailAccount:self.myAddAccountWindowController.username
                                        password:self.myAddAccountWindowController.password];
        
        [self.accountsTableView reloadData];
    }
}

- (IBAction) whyDoesOrderMatter:(id)sender {
    NSBeginAlertSheet(@"Why does order matter?",
                      @"Oh, I see.",
                      nil,
                      nil,
                      self.window,
                      nil,
                      NULL,
                      NULL,
                      NULL,
                      @"In order for Mail Ping to work flawlessly with multiple Gmail accounts, the order of your emails in Mail Ping must match the order of the Gmail accounts you're logged into in your favorite browser.\n\n"
                      @"To re-order your Mail Ping accounts, just drag them to a different spot."
                      );
}

- (IBAction) removeAccount:(id)sender {
    NSBeginAlertSheet(@"Are you sure you want to remove this account?",
                      @"Never mind",
                      @"Remove it!",
                      nil,
                      self.window,
                      self,
                      @selector(removeAccountSheetDidEnd:returnCode:contextInfo:),
                      NULL,
                      NULL,
                      @"This can't be undone. Well, not easily at least.");
}

- (void) removeAccountSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo; {
    if (returnCode == 0) {
        [EmailAccountsController removeEmailAccountAtIndex:[self.accountSelectionIndexes firstIndex]];
        [self.accountsTableView reloadData];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[EmailAccountsController emailAccounts] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [[EmailAccountsController emailAccounts] objectAtIndex:row];
}

- (BOOL)tableView:(NSTableView *)aTableView
       acceptDrop:(id < NSDraggingInfo >)info
              row:(NSInteger)newIndex
    dropOperation:(NSTableViewDropOperation)operation
{
    NSUInteger originalIndex = [[[info draggingPasteboard] propertyListForType:MyEmailAccountType] unsignedIntegerValue];
    
    NSMutableArray* reorderedAccounts = [NSMutableArray arrayWithArray:[EmailAccountsController emailAccounts]];
    NSString* theEmailAccount = [reorderedAccounts objectAtIndex:originalIndex];
    
    [reorderedAccounts insertObject:theEmailAccount atIndex:newIndex];
    [reorderedAccounts removeObjectAtIndex:[reorderedAccounts indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return (obj == theEmailAccount && idx != newIndex);
    }]];
    
    [EmailAccountsController setEmailAccounts:reorderedAccounts];
    
    [self.accountsTableView reloadData];
    
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation {
    if (operation == NSTableViewDropAbove)
        return NSDragOperationMove;
    else
        return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:@[MyEmailAccountType] owner:nil];
    [pboard setPropertyList:@([rowIndexes firstIndex]) forType:MyEmailAccountType];
    return YES;
}

@end
