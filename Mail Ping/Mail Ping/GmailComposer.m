//
//  GmailComposer.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/21/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "GmailComposer.h"

#import "EmailAccountsController.h"

@implementation GmailComposer

- (void) menuNeedsUpdate:(NSMenu *)menu {
    [menu removeAllItems];
    int i = 0;
    for (NSString* email in [EmailAccountsController emailAccounts]) {
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"From \"%@\"", email]
                                                      action:@selector(composeEmailAs:)
                                               keyEquivalent:@""];
        [item setTag:i++];
        [menu addItem:item];
    }
}

@end
