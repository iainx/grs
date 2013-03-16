//
//  DLFinderProxy.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ScriptingBridge/ScriptingBridge.h>

@interface DLFinderProxy : NSObject

+ (DLFinderProxy*) finderProxy;

- (SBElementArray*) desktopIcons;

+ (void) showDesktop;

@end
