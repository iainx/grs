//
//  SDRunningApplication.h
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SDRunningApplication : NSObject {
	ProcessSerialNumber psn;
	NSString *bundleID;
}

+ (id) appWithBundleID:(NSString*)newBundleID;
- (id) initWithBundleID:(NSString*)newBundleID;

- (void) quit;

@end
