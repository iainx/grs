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
+ (MyWindow*) focusedWindow;

- (NSRect) frame;
- (void) setFrame:(NSRect)frame;

- (NSRect) gridProps;
- (void) moveToGridProps:(NSRect)gridProps;

- (NSString*) title;

@end
