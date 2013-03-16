//
//  DLFinderProxy.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLDesktopIcon.h"

@interface DLFinderProxy : NSObject

+ (DLFinderProxy*) finderProxy;

- (NSArray*) desktopIcons;

+ (void) showDesktop;

@end
