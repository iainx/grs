//
//  SDStatusItemController.h
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SDStatusItemController : NSObject {
	NSStatusItem *statusItem;
	
	IBOutlet NSMenu *statusIconMenu;
	IBOutlet NSMenuItem *snapshotsTitleMenuItem;
	IBOutlet NSMenuItem *topDividerMenuItem;
	IBOutlet NSMenuItem *bottomDividerMenuItem;
}

- (void) toggleStatusItemVisible:(BOOL)toVisible;
- (void) toggleStatusItem;

@end
