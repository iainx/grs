//
//  NSData+MD5.m
//  Dupl
//
//  Created by iain on 26/02/2014.
//  Copyright (c) 2014 Entouch. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSData+MD5.h"

@implementation NSData (MD5)

// From http://stackoverflow.com/a/1994690/697819
- (NSString*)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end
