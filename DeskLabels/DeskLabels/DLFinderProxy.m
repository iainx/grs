//
//  DLFinderProxy.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLFinderProxy.h"

#import "Finder.h"

void CoreDockSendNotification(CFStringRef, void *);


@interface DLFinderProxy ()

@property FinderApplication* finder;

@end


@implementation DLFinderProxy

+ (DLFinderProxy*) finderProxy {
    static DLFinderProxy* finderProxy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        finderProxy = [[DLFinderProxy alloc] init];
		finderProxy.finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
    });
    return finderProxy;
}

- (SBElementArray*) desktopIcons {
    return self.finder.desktop.items;
}

+ (void) showDesktop {
    CoreDockSendNotification(CFSTR("com.apple.showdesktop.awake"), NULL);
}

@end
