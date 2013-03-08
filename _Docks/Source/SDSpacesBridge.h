//
//  SDSpacesListener.h
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SDSpacesDelegate

- (void) spacesDidSwitchToSpaceWithNumber:(int)currentSpace;

@end


@interface SDSpacesBridge : NSObject {

}

+ (void) addObserverToChangingSpacesEvent:(id<SDSpacesDelegate>)newDelegate;

@end
