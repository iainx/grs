//
//  TimerGoneDelegate.h
//  Timer
//
//  Created by Steven Degutis on 2/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimerGoneDelegate <NSObject>

- (void) windowDidCloseForWindowController:(id)wc;

@end
