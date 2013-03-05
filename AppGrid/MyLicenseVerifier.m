//
//  MyLicenseVerifier.m
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyLicenseVerifier.h"

#import "CFobLicVerifier.h"

@implementation MyLicenseVerifier

+ (BOOL) verifyLicenseCode:(NSString*)regCode forLicenseName:(NSString*)regName {
	regName = [NSString stringWithFormat:@"AppGrid,%@", regName];
    
	NSString *publicKey =
    @"MIHxMIGpBgcqhkjOOAQBMIGdAkEApu5r"@"og+tkWTO1cMy3284VgEMmDxQmY7hJRmn"@"\n"
    @"skTFv7nRBCXva1pUhlOR/awOFyhkMBzR"@"nen1NlimxOBSiCfivQIVAOtu+QXEbzXf"@"\n"
    @"MMU1qyuhEp0o233zAkEApF6zQLuBy89f"@"J3gEP4V+N6J1hWzRv5VtQgrHpu635pkw"@"\n"
    @"eQDtkQriu3tvrw85QotzKdgZVhmDkg0U"@"o7PfZpQ+lANDAAJAFuesN0blhZdMn0SX"@"\n"
    @"EydQvrlQda7dEuI9zZo919yO/8SsSy9V"@"7PU+HklIX7elMdhjtwdUlncKgZoaZREO"@"\n"
    @"guP8lg==\n";
    
	publicKey = [CFobLicVerifier completePublicKeyPEM:publicKey];
    
	CFobLicVerifier * verifier = [[CFobLicVerifier alloc] init];
    [verifier setPublicKey:publicKey error:NULL];
    
    BOOL valid = [verifier verifyRegCode:regCode forName:regName error:NULL];
    
    if (valid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MyLicenseVerifiedNotification
                                                            object:nil];
    }
    
	return valid;
}

+ (NSString*) licenseName {
}

+ (NSString*) licenseCode {
}

+ (BOOL) hasValidLicense {
    return NO;
}

+ (void) sendToStore {
    NSString* storeUrl = @"http://giantrobotsoftware.com/appgrid/store.html";
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:storeUrl]];
}

+ (NSAlert*) alertForValidity:(BOOL)valid {
    NSAlert* alert = [[NSAlert alloc] init];
    
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    if (valid) {
        alert.alertStyle = NSInformationalAlertStyle;
        alert.messageText = @"AppGrid successfully registered!";
        alert.informativeText = [NSString stringWithFormat:@"Now you have the full version of %@. Congratulations!", appName];
    }
    else {
        alert.alertStyle = NSCriticalAlertStyle;
        alert.messageText = @"Invalid or Corrupted License";
        alert.informativeText = [NSString stringWithFormat:
                                 @"The auto-register link you clicked has been corrupted and can't be verified.\n\n"
                                 @"To register %@, find the license name and license code (which was emailed to you) and enter them into the License window.",
                                 appName];
    }
    
    return alert;
}

@end
