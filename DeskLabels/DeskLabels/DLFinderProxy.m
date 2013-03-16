//
//  DLFinderProxy.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLFinderProxy.h"

#import "Finder.h"

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

- (NSArray*) desktopIcons {
    SBElementArray* icons = self.finder.desktop.items;
    NSArray* positions = [icons arrayByApplyingSelector:@selector(desktopPosition)];
    NSArray* finderItems = [icons get];
    
    NSMutableArray* desktopIcons = [NSMutableArray array];
    
    for (int i = 0; i < [icons count]; i++) {
        DLDesktopIcon* desktopIcon = [[DLDesktopIcon alloc] init];
        desktopIcon.finderItem = [finderItems objectAtIndex:i];
        desktopIcon.initialPosition = [[positions objectAtIndex:i] pointValue];
        [desktopIcons addObject:desktopIcon];
    }
    
    return desktopIcons;
}

+ (void) showDesktop {
    [NSTask launchedTaskWithLaunchPath:@"/Applications/Mission Control.app/Contents/MacOS/Mission Control" arguments:@[@"1"]];
}

@end
