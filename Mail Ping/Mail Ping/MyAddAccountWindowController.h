//
//  MyAddAccountWindowController.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyAddAccountWindowController : NSWindowController

@property NSString* username;
@property NSString* password;

@property BOOL validatingEmail;

@end
