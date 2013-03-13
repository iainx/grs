//
//  MyWindow.h
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWindow : NSObject

+ (NSArray*) allWindows;
+ (NSArray*) visibleWindows;
+ (MyWindow*) focusedWindow;

- (CGRect) frame;
- (void) setFrame:(CGRect)frame;

- (CGRect) gridProps;
- (void) moveToGridProps:(CGRect)gridProps;

- (void) moveToNextScreen;
- (void) moveToPreviousScreen;

- (void) maximize;

- (void) focusWindow;

- (NSArray*) otherWindowsOnSameScreen;

- (NSString *) title;

@end
