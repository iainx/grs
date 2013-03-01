//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDHowToWindowInsetTextField.h"


@implementation SDHowToWindowInsetTextField

- (id) initWithCoder:(NSCoder*)coder {
	if (self = [super initWithCoder:coder]) {
		[[self cell] setBackgroundStyle:NSBackgroundStyleRaised];
	}
	return self;
}

@end
