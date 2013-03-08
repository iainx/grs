//
//  TimerWindowController.m
//  Timer
//
//  Created by Steven Degutis on 2/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "TimerWindowController.h"

@interface TimerWindowController ()

@end

@implementation TimerWindowController

- (NSString*) windowNibName {
    return @"TimerWindow";
}

- (IBAction) startTimer:(id)sender {
    self.seconds = [self.inputTimeField.stringValue floatValue] * 60.0;
    self.initialSeconds = self.seconds;
    
    self.progressBar.maxValue = self.initialSeconds;
    
    [self.tabView selectNextTabViewItem:self];
    
    self.outputTimerNameField.stringValue = self.inputTimerNameField.stringValue;
    
    [self buildTimer];
    
    [self tick];
}

- (void) windowWillClose:(NSNotification *)notification {
    [self.timer invalidate];
    self.timer = nil;
    
    [self.closeDelegate windowDidCloseForWindowController:self];
}

- (void) buildTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES];
}

- (IBAction) addMinute:(id)sender {
    self.initialSeconds += 60.0;
    self.progressBar.maxValue = self.initialSeconds;
    
    self.seconds += 60.0;
    
    [self redisplay];
}

- (IBAction) togglePaused:(id)sender {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.outputTimeField.textColor = [NSColor grayColor];
    }
    else {
        [self buildTimer];
        [self redisplay];
    }
}

- (IBAction) subtractMinute:(id)sender {
    self.initialSeconds -= 60.0;
    self.progressBar.maxValue = self.initialSeconds;
    
    self.seconds -= 60.0;
    if (self.seconds <= 0.5)
        self.seconds = 0.0;
    
    [self redisplay];
}

- (void) redisplay {
    self.progressBar.doubleValue = self.initialSeconds - self.seconds;
    
    NSString* str;
    
    if (self.seconds > 0) {
        NSInteger secsDisplay = self.seconds % 60;
        NSInteger minsDisplay = self.seconds / 60;
        
        str = [NSString stringWithFormat:@"%02ld:%02ld", minsDisplay, secsDisplay];
        
        if (self.seconds < 30) {
            self.outputTimeField.textColor = [NSColor redColor];
        }
        else {
            self.outputTimeField.textColor = [NSColor blackColor];
        }
    }
    else {
        self.outputTimeField.textColor = [NSColor colorWithCalibratedRed:0.0 green:0.75 blue:0.0 alpha:1.0];
        
        str = @"DONE";
    }
    
    self.outputTimeField.stringValue = str;
}

- (void) tick {
    self.seconds--;
    
    [self redisplay];
    
    if (self.seconds <= 0.5) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.addMinuteButton.enabled = NO;
        self.subtractMinuteButton.enabled = NO;
        
        [[NSSound soundNamed:@"Glass"] play];
    }
}

@end
