//
//  MyLicenseURLHandler.h
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLicenseURLHandler : NSObject

- (void) listenForURLs:(void(^)(NSString* licenseName, NSString* serial))handler;

@end
