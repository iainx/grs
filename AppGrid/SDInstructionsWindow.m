//
//  Created by Steven Degutis
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDInstructionsWindow.h"


@implementation SDInstructionsWindow

- (void) swipeWithEvent:(NSEvent*)event {
	NSInteger dir = (NSInteger)[event deltaX];
	if (dir > 0)
		[self tryToPerform:@selector(navigateInDirection:) with:[NSNumber numberWithInt:(-1)]];
	if (dir < 0)
		[self tryToPerform:@selector(navigateInDirection:) with:[NSNumber numberWithInt:(+1)]];
}

@end
