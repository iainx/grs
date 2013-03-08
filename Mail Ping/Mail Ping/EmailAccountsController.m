//
//  EmailAccountsController.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "EmailAccountsController.h"

#import "SDKeychain.h"

#define EmailAccountsKey @"EmailAccountsKey"

@implementation EmailAccountsController

+ (NSArray*) emailAccounts {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:EmailAccountsKey];
}

+ (void) setEmailAccounts:(NSArray*)accounts {
    [[NSUserDefaults standardUserDefaults] setObject:accounts
                                              forKey:EmailAccountsKey];
}

+ (void) addEmailAccount:(NSString*)email password:(NSString*)password {
    NSMutableArray* accounts = [NSMutableArray arrayWithArray:[self emailAccounts]];
    [accounts addObject:email];
    
    [[NSUserDefaults standardUserDefaults] setObject:accounts
                                              forKey:EmailAccountsKey];
    
    [SDKeychain setSecurePassword:password forIdentifier:email];
}

+ (void) removeEmailAccountAtIndex:(NSUInteger)index {
    NSMutableArray* accounts = [NSMutableArray arrayWithArray:[self emailAccounts]];
    [accounts removeObjectAtIndex:index];
    
    [[NSUserDefaults standardUserDefaults] setObject:accounts
                                              forKey:EmailAccountsKey];
}

+ (NSString*) passwordForEmailAccount:(NSString*)email {
    return [SDKeychain securePasswordForIdentifier:email];
}

@end
