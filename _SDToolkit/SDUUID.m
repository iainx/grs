//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDUUID.h"


@implementation SDUUID

+ (NSString*) getUUID {
    CFUUIDRef UUID = CFUUIDCreate(NULL);
    CFStringRef str = CFUUIDCreateString(NULL, UUID);
    CFRelease(UUID);
    return (__bridge_transfer NSString*)str;
}

@end
