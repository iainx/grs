//
//  TimerWindowController.h
//  Timer
//
//  Created by Steven Degutis on 2/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TimerGoneDelegate.h"

@interface TimerWindowController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet NSTabView *tabView;

@property (weak) IBOutlet NSTextField *inputTimerNameField;
@property (weak) IBOutlet NSTextField *inputTimeField;

@property (weak) IBOutlet NSTextField *outputTimeField;
@property (weak) IBOutlet NSTextField *outputTimerNameField;

@property (weak) IBOutlet NSProgressIndicator *progressBar;

@property (weak) IBOutlet NSButton* addMinuteButton;
@property (weak) IBOutlet NSButton* subtractMinuteButton;

@property NSInteger initialSeconds;
@property NSInteger seconds;

@property NSTimer* timer;

@property (weak) id<TimerGoneDelegate> closeDelegate;

@end
