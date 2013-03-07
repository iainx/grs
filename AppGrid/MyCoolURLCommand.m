#import "MyCoolURLCommand.h"

#import "NSString+PECrypt.h"

@implementation MyCoolURLCommand

- (id)performDefaultImplementation {
	NSString *url = [self directParameter];
    
	NSArray *protocolAndTheRest = [url componentsSeparatedByString:@"://"];
	if ([protocolAndTheRest count] != 2) {
		NSLog(@"License URL is invalid (no protocol)");
		return nil;
	}
    
	NSArray *userNameAndSerialNumber = [[protocolAndTheRest objectAtIndex:1] componentsSeparatedByString:@"/"];
	if ([userNameAndSerialNumber count] != 2) {
		NSLog(@"License URL is invalid (missing parts)");
		return nil;
	}
    
	NSString *usernameb64 = (NSString *)[userNameAndSerialNumber objectAtIndex:0];
	NSString *licenseName = [usernameb64 base64Decode];
	NSString *licenseCode = (NSString *)[userNameAndSerialNumber objectAtIndex:1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MyClickedAutoRegURLNotification
                                                        object:nil
                                                      userInfo:@{@"name": licenseName, @"code": licenseCode}];
    
	return nil;
}

@end
