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

+ (BOOL) verifyLicense:(NSString*)regCode for:(NSString*)regName {
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
    
	return ([verifier verifyRegCode:regCode forName:regName error:NULL]);
}

+ (BOOL) hasValidLicense {
    return NO;
}

@end
