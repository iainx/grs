//
//  MyLicenseURLHandler.m
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyLicenseURLHandler.h"

#import "NSString+PECrypt.h"

@interface MyLicenseURLHandler ()

@property (copy) void(^handler)(NSString* licenseName, NSString* licenseCode);

@end

@implementation MyLicenseURLHandler

- (void) listenForURLs:(void(^)(NSString* licenseName, NSString* licenseCode))handler {
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(handleURLEvent:withReplyEvent:)
                                                     forEventClass:kInternetEventClass
                                                        andEventID:kAEGetURL];
    
    self.handler = handler;
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    
	NSArray *protocolAndTheRest = [url componentsSeparatedByString:@"://"];
	if ([protocolAndTheRest count] != 2) {
		NSLog(@"License URL is invalid (no protocol)");
		return;
	}
    
	NSArray *userNameAndSerialNumber = [[protocolAndTheRest objectAtIndex:1] componentsSeparatedByString:@"/"];
	if ([userNameAndSerialNumber count] != 2) {
		NSLog(@"License URL is invalid (missing parts)");
		return;
	}
    
	NSString *usernameb64 = (NSString *)[userNameAndSerialNumber objectAtIndex:0];
	NSString *licenseName = [usernameb64 base64Decode];
	NSString *licenseCode = (NSString *)[userNameAndSerialNumber objectAtIndex:1];
    
    self.handler(licenseName, licenseCode);
}

@end
