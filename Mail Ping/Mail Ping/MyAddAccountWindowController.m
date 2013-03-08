//
//  MyAddAccountWindowController.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyAddAccountWindowController.h"

#import "EmailAccountsController.h"
#import "GmailFeed.h"

@implementation MyAddAccountWindowController

- (NSString*) windowNibName {
    return @"MyAddAccountWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) addAccount:(id)sender {
    self.validatingEmail = YES;
    
    [GmailFeed getFeedForUsername:self.username
                         password:self.password
                          handler:^(GmailFeed *feed) {
                              self.validatingEmail = NO;
                              
                              if (feed.lastModified) {
                                  [NSApp endSheet:[self window] returnCode:1];
                                  [self.window orderOut:self];
                              }
                              else {
                                  NSBeginCriticalAlertSheet(@"Invalid Credentials",
                                                            @"OK",
                                                            nil,
                                                            nil,
                                                            self.window,
                                                            nil,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            @"Your email address could not be authenticated.");
                              }
                          }];
}

- (IBAction) cancelAddingAccount:(id)sender {
    [NSApp endSheet:[self window] returnCode:0];
    [self.window orderOut:self];
}

- (BOOL) emailExists {
    return [[EmailAccountsController emailAccounts] containsObject:self.username];
}

@end
