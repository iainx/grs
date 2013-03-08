//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDArrayNotEmptyValueTransformer.h"


@implementation SDArrayNotEmptyValueTransformer

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
	return @([value count] > 0);
}

@end
