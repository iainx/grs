//
//  SDViewController.h
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SDViewController : NSViewController {
	NSView *initialFirstResponder;
}

@property (assign) IBOutlet NSView *initialFirstResponder;

@end
