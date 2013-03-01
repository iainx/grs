//
//  MyWindow.h
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWindow : NSObject

+ (MyWindow*) focusedWindow;

- (NSPoint) topLeft;
- (void) setTopLeft:(NSPoint)thePoint;

- (NSSize) size;
- (void) setSize:(NSSize)theSize;

@end
