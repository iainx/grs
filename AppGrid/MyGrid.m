//
//  MyGrid.m
//  AppGrid
//
//  Created by Steven Degutis on 3/1/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyGrid.h"

#import "MyShortcuts.h"

#define MyGridWidthDefaultsKey @"MyGridWidthDefaultsKey"
#define MyUseWindowMarginsDefaultsKey @"MyUseWindowMarginsDefaultsKey"

@implementation MyGrid

+ (NSInteger) width {
    return [[NSUserDefaults standardUserDefaults] integerForKey:MyGridWidthDefaultsKey];
}

+ (void) setWidth:(NSInteger)newWidth {
    [[NSUserDefaults standardUserDefaults] setInteger:newWidth forKey:MyGridWidthDefaultsKey];
}

+ (BOOL) usesWindowMargins {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MyUseWindowMarginsDefaultsKey];
}

+ (void) setUsesWindowMargins:(BOOL)usesWindowMargins {
    [[NSUserDefaults standardUserDefaults] setBool:usesWindowMargins forKey:MyUseWindowMarginsDefaultsKey];
}

@end
