//
//  MyLicenseWindowController.m
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyLicenseWindowController.h"

#import "MyLicenseVerifier.h"

@implementation MyLicenseWindowController

- (NSString*) windowNibName {
    return @"MyLicenseWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) validateLicense:(id)sender {
    
}

- (IBAction) buyNow:(id)sender {
    [MyLicenseVerifier sendToStore];
}

+ (NSSet*) keyPathsForValuesAffectingHasValidLicense {
    return [NSSet setWithArray:@[@""]];
}

//- (NSUserDefaultsController*) defaultsController {
//    return [NSUserDefaultsController sharedUserDefaultsController];
//}

- (BOOL) hasValidLicense {
    return [MyLicenseVerifier hasValidLicense];
}

@end
