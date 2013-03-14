//
//  MyLicenseWindowController.h
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyLicenseWindowController : NSWindowController

@property NSString* licenseName;
@property NSString* licenseCode;

@property BOOL hasValidLicense;

@property (readonly) NSString* licenseWindowTitle;
@property (readonly) CGFloat licenseWindowHeight;

@end
