//
// Created 2008 by Steven Degutis
// http://www.thoughtfultree.com/
// Some rights reserved.
//

#import "SDOpenAtLoginController.h"

#import <ServiceManagement/SMLoginItem.h>
#import <ServiceManagement/ServiceManagement.h>

@implementation SDOpenAtLoginController

@dynamic opensAtLogin;

- (id) init {
	if (self = [super init]) {
		sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	}
	return self;
}

- (void) setOpensAtLogin:(BOOL)opensAtLogin {
    SMLoginItemSetEnabled((CFStringRef)[[NSBundle mainBundle] bundleIdentifier], opensAtLogin);
}

- (BOOL) opensAtLogin {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSArray * jobDicts = nil;
    jobDicts = (NSArray *)SMCopyAllJobDictionaries( kSMDomainUserLaunchd );
    // Note: Sandbox issue when using SMJobCopyDictionary()
    
    if ( (jobDicts != nil) && [jobDicts count] > 0 ) {
        
        BOOL bOnDemand = NO;
        
        for ( NSDictionary * job in jobDicts ) {
            
            if ( [bundleID isEqualToString:[job objectForKey:@"Label"]] ) {
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
        
        CFRelease((CFDictionaryRef)jobDicts); jobDicts = nil;
        return bOnDemand;
        
    }
    return NO;
}

@end
