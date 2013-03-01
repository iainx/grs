//
//  MyWindow.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyWindow.h"

@interface MyWindow ()

@property CFTypeRef window;

@end

@implementation MyWindow

+ (NSArray*) allWindows {
    NSMutableArray* windows = [NSMutableArray array];
    
    for (NSRunningApplication* runningApp in [[NSWorkspace sharedWorkspace] runningApplications]) {
        if ([runningApp activationPolicy] == NSApplicationActivationPolicyRegular) {
            AXUIElementRef app = AXUIElementCreateApplication([runningApp processIdentifier]);
            
            CFArrayRef _windows;
            if (AXUIElementCopyAttributeValues(app, kAXWindowsAttribute, 0, 100, &_windows) == kAXErrorSuccess) {
                for (NSInteger i = 0; i < CFArrayGetCount(_windows); i++) {
                    AXUIElementRef win = CFArrayGetValueAtIndex(_windows, i);
                    MyWindow* window = [[MyWindow alloc] init];
                    window.window = win;
                    [windows addObject:window];
                }
            }
        }
    }
    
    return windows;
}

+ (MyWindow*) focusedWindow {
    AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();
    
    CFTypeRef app;
    AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedApplicationAttribute, &app);
    
    CFTypeRef win;
    AXError result = AXUIElementCopyAttributeValue(app, (CFStringRef)NSAccessibilityFocusedWindowAttribute, &win);
    if (result == kAXErrorSuccess) {
        MyWindow* window = [[MyWindow alloc] init];
        window.window = win;
        return window;
    }
    
    return nil;
}

- (CGRect) gridProps {
    CGRect winFrame = [self frame];
    
    CGRect screenRect = [self realScreenFrame];
    double thirdScrenWidth = screenRect.size.width / 3.0;
    double halfScreenHeight = screenRect.size.height / 2.0;
    
    CGRect gridProps;
    
    gridProps.origin.x = round((winFrame.origin.x - NSMinX(screenRect)) / thirdScrenWidth);
    gridProps.origin.y = round((winFrame.origin.y - NSMinY(screenRect)) / halfScreenHeight);
    
    gridProps.size.width = MAX(round(winFrame.size.width / thirdScrenWidth), 1);
    gridProps.size.height = MAX(round(winFrame.size.height / halfScreenHeight), 1);
    
    return gridProps;
}

- (CGRect) realScreenFrame {
    CGRect original = [[NSScreen mainScreen] visibleFrame];
    CGRect reference = [[NSScreen mainScreen] frame];
    return NSMakeRect(original.origin.x,
                      reference.size.height - (reference.origin.y + original.origin.y + original.size.height),
                      original.size.width,
                      original.size.height);
}

- (void) moveToGridProps:(CGRect)gridProps {
    CGRect screenRect = [self realScreenFrame];
    
    double thirdScrenWidth = screenRect.size.width / 3.0;
    double halfScreenHeight = screenRect.size.height / 2.0;
    
    CGRect newFrame;
    
    newFrame.origin.x = (gridProps.origin.x * thirdScrenWidth) + NSMinX(screenRect);
    newFrame.origin.y = (gridProps.origin.y * halfScreenHeight) + NSMinY(screenRect);
    newFrame.size.width = gridProps.size.width * thirdScrenWidth;
    newFrame.size.height = gridProps.size.height * halfScreenHeight;
    
    newFrame = NSInsetRect(newFrame, 5, 5);
    
//    NSLog(@"was: %@", NSStringFromRect([self frame]));
//    NSLog(@" is: %@", NSStringFromRect(newFrame));
    
    [self setFrame:newFrame];
}

- (CGRect) frame {
    CGRect r;
    r.origin = [self topLeft];
    r.size = [self size];
    return r;
}

- (void) setFrame:(CGRect)frame {
    [self setTopLeft:frame.origin];
    [self setSize:frame.size];
}

- (NSString*) title {
    CFTypeRef _title;
    if (AXUIElementCopyAttributeValue(self.window, (CFStringRef)NSAccessibilityTitleAttribute, (CFTypeRef *)&_title) == kAXErrorSuccess) {
        NSString *title = (__bridge NSString *) _title;
        if (_title != NULL) CFRelease(_title);
        return title;
    }
    if (_title != NULL) CFRelease(_title);
    return @"";
}

- (CGPoint) topLeft {
    CFTypeRef positionStorage;
    AXError result = AXUIElementCopyAttributeValue(self.window, (CFStringRef)NSAccessibilityPositionAttribute, &positionStorage);
    
    CGPoint topLeft;
    if (result == kAXErrorSuccess) {
        if (!AXValueGetValue(positionStorage, kAXValueCGPointType, (void *)&topLeft)) {
            NSLog(@"could not decode topLeft");
            topLeft = CGPointZero;
        }
    }
    else {
        NSLog(@"could not get window topLeft");
        topLeft = CGPointZero;
    }
    
    if (positionStorage)
        CFRelease(positionStorage);
    
    return topLeft;
}

- (void) setTopLeft:(CGPoint)thePoint {
    CFTypeRef positionStorage = (CFTypeRef)(AXValueCreate(kAXValueCGPointType, (const void *)&thePoint));
    
    AXError result = AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilityPositionAttribute, positionStorage);
    BOOL success = (result == kAXErrorSuccess);
    
    if (!success)
        NSLog(@"could not move window");
    
    if (positionStorage)
        CFRelease(positionStorage);
}

- (CGSize) size {
    CFTypeRef sizeStorage;
    AXError result = AXUIElementCopyAttributeValue(self.window, (CFStringRef)NSAccessibilitySizeAttribute, &sizeStorage);
    
    CGSize size;
    if (result == kAXErrorSuccess) {
        if (!AXValueGetValue(sizeStorage, kAXValueCGSizeType, (void *)&size)) {
            NSLog(@"could not decode topLeft");
            size = CGSizeZero;
        }
    }
    else {
        NSLog(@"could not get window size");
        size = CGSizeZero;
    }
    
    if (sizeStorage)
        CFRelease(sizeStorage);
    
    return size;
}

- (void) setSize:(CGSize)theSize {
    CFTypeRef sizeStorage = (CFTypeRef)(AXValueCreate(kAXValueCGSizeType, (const void *)&theSize));
    
    AXError result = AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilitySizeAttribute, (CFTypeRef *)sizeStorage);
    BOOL success = (result == kAXErrorSuccess);
    
    if (!success)
        NSLog(@"could not set window size");
    
    if (sizeStorage)
        CFRelease(sizeStorage);
}

@end
