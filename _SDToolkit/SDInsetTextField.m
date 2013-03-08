//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDInsetTextField.h"


@implementation SDInsetTextField

- (id) initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
		[[self cell] setBackgroundStyle:NSBackgroundStyleRaised];
	}
	return self;
}

@end
