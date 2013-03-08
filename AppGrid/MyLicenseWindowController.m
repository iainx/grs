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
    
    self.window.level = NSModalPanelWindowLevel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myLicenseVerifiedNotification:)
                                                 name:MyLicenseVerifiedNotification
                                               object:nil];
    
    [self resetMyProperties];
}

- (void) resetMyProperties {
    self.licenseName = [[MyLicenseVerifier licenseName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.licenseCode = [[MyLicenseVerifier licenseCode] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.hasValidLicense = [MyLicenseVerifier hasValidLicense];
}

- (void) myLicenseVerifiedNotification:(NSNotification*)note {
    [self willChangeValueForKey:@"hasValidLicense"];
    [self resetMyProperties];
    [self didChangeValueForKey:@"hasValidLicense"];
}

- (void) validationAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertSecondButtonReturn)
        [MyLicenseVerifier sendToWebsite];
}

- (IBAction) validateLicense:(id)sender {
    BOOL valid = [MyLicenseVerifier
                  tryRegisteringWithLicenseCode:[self.licenseCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                  licenseName:[self.licenseName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    [[MyLicenseVerifier alertForValidity:valid fromLink:NO]
     beginSheetModalForWindow:[self window]
     modalDelegate:self
     didEndSelector:@selector(validationAlertDidEnd:returnCode:contextInfo:)
     contextInfo:NULL];
}

- (IBAction) buyNow:(id)sender {
    [MyLicenseVerifier sendToStore];
}

+ (NSSet*) keyPathsForValuesAffectingLicenseWindowTitle {
    return [NSSet setWithArray:@[@"hasValidLicense"]];
}

- (NSString*) licenseWindowTitle {
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    if (self.hasValidLicense) {
        return [NSString stringWithFormat:@"Your %@ License", appName];
    }
    else {
        return [NSString stringWithFormat:@"Enter %@ License", appName];
    }
}

@end
