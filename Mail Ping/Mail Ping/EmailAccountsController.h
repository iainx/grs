//
//  EmailAccountsController.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailAccountsController : NSObject

+ (NSArray*) emailAccounts;
+ (void) setEmailAccounts:(NSArray*)accounts;

+ (void) addEmailAccount:(NSString*)email password:(NSString*)password;
+ (void) removeEmailAccountAtIndex:(NSUInteger)index;
+ (NSString*) passwordForEmailAccount:(NSString*)email;

@end
