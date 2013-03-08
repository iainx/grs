//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDStringNotEmptyValueTransformer.h"

@implementation SDStringNotEmptyValueTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(NSString*)value {
    return @([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0);
}

@end
