//
//  SDNotEmptyStringValueTransformer.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDNotEmptyStringValueTransformer.h"

@implementation SDNotEmptyStringValueTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(NSString*)value {
    return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0);
}

@end
