//
//  AppDelegate.h
//  Timer
//
//  Created by Steven Degutis on 2/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TimerGoneDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, TimerGoneDelegate>

@property NSMutableArray* windowControllers;

@end
