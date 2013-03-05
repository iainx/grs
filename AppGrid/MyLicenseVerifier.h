//
//  MyLicenseVerifier.h
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MyLicenseVerifiedNotification @"MyLicenseVerifiedNotification"

@interface MyLicenseVerifier : NSObject

+ (BOOL) verifyLicenseCode:(NSString*)regCode forLicenseName:(NSString*)regName;

+ (NSString*) licenseName;
+ (NSString*) licenseCode;

+ (BOOL) hasValidLicense;

+ (void) sendToStore;

+ (NSAlert*) alertForValidity:(BOOL)valid;

@end
