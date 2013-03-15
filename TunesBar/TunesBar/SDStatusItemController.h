//
//  SDMainWindowController.h
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "iTunesProxy.h"

@interface SDStatusItemController : NSResponder <iTunesDelegate>

- (void) setupStatusItem;

@end
