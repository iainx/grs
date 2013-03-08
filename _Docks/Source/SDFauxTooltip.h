//
//  SDFauxTooltip.h
//  Docks
//
//  Created by Steven Degutis on 7/19/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SDFauxTooltip : NSWindowController {
	IBOutlet NSTextField *titleField;
	NSString *title;
}

+ (id) tooltipWithString:(NSString*)newTitle;

- (id) initWithString:(NSString*)newTitle;

@end
