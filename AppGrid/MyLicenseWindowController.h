//
//  MyLicenseWindowController.h
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MyStoreWindowController.h"

@interface MyLicenseWindowController : NSWindowController

@property MyStoreWindowController *myStoreWindowController;

@property NSString* licenseName;
@property NSString* licenseCode;

@property (readonly) BOOL hasValidLicense;

@end
