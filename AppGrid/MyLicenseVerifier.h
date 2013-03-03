//
//  MyLicenseVerifier.h
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLicenseVerifier : NSObject

+ (BOOL) verifyLicense:(NSString*)regCode for:(NSString*)regName;

@end
