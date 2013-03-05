//
//  MyWindow.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyWindow.h"

#import "MyGrid.h"

@interface MyWindow ()

@property CFTypeRef window;

@end

@implementation MyWindow

+ (CGRect) realFrameForScreen:(NSScreen*)screen {
    NSScreen* primaryScreen = [[NSScreen screens] objectAtIndex:0];
    CGRect f = [screen visibleFrame];
    f.origin.y = NSHeight([primaryScreen frame]) - NSHeight(f) - f.origin.y;
    return f;
}

+ (NSArray*) allWindows {
    NSMutableArray* windows = [NSMutableArray array];
    
    for (NSRunningApplication* runningApp in [[NSWorkspace sharedWorkspace] runningApplications]) {
//        if ([runningApp activationPolicy] == NSApplicationActivationPolicyRegular) {
            AXUIElementRef app = AXUIElementCreateApplication([runningApp processIdentifier]);
            
            CFArrayRef _windows;
            AXError result = AXUIElementCopyAttributeValues(app, kAXWindowsAttribute, 0, 100, &_windows);
            if (result == kAXErrorSuccess) {
                for (NSInteger i = 0; i < CFArrayGetCount(_windows); i++) {
                    AXUIElementRef win = CFArrayGetValueAtIndex(_windows, i);
                    MyWindow* window = [[MyWindow alloc] init];
                    window.window = CFRetain(win);
                    [windows addObject:window];
                }
                CFRelease(_windows);
            }
            
            CFRelease(app);
//        }
    }
    
    return windows;
}

- (void) dealloc {
    if (self.window)
        CFRelease(self.window);
}

+ (MyWindow*) focusedWindow {
    static AXUIElementRef systemWideElement;
    if (systemWideElement == NULL)
        systemWideElement = AXUIElementCreateSystemWide();
    
    CFTypeRef app;
    AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedApplicationAttribute, &app);
    
    CFTypeRef win;
    AXError result = AXUIElementCopyAttributeValue(app, (CFStringRef)NSAccessibilityFocusedWindowAttribute, &win);
    CFRelease(app);
    
    if (result == kAXErrorSuccess) {
        MyWindow* window = [[MyWindow alloc] init];
        window.window = win;
        return window;
    }
    
    return nil;
}

- (CGRect) gridProps {
    CGRect winFrame = [self frame];
    
    CGRect screenRect = [MyWindow realFrameForScreen:[self screen]];
    double thirdScrenWidth = screenRect.size.width / [MyGrid width];
    double halfScreenHeight = screenRect.size.height / 2.0;
    
    CGRect gridProps;
    
    gridProps.origin.x = round((winFrame.origin.x - NSMinX(screenRect)) / thirdScrenWidth);
    gridProps.origin.y = round((winFrame.origin.y - NSMinY(screenRect)) / halfScreenHeight);
    
    gridProps.size.width = MAX(round(winFrame.size.width / thirdScrenWidth), 1);
    gridProps.size.height = MAX(round(winFrame.size.height / halfScreenHeight), 1);
    
    return gridProps;
}

- (void) moveToGridProps:(CGRect)gridProps onScreen:(NSScreen*)screen {
    CGRect screenRect = [MyWindow realFrameForScreen:screen];
    
    double thirdScrenWidth = screenRect.size.width / [MyGrid width];
    double halfScreenHeight = screenRect.size.height / 2.0;
    
    CGRect newFrame;
    
    newFrame.origin.x = (gridProps.origin.x * thirdScrenWidth) + NSMinX(screenRect);
    newFrame.origin.y = (gridProps.origin.y * halfScreenHeight) + NSMinY(screenRect);
    newFrame.size.width = gridProps.size.width * thirdScrenWidth;
    newFrame.size.height = gridProps.size.height * halfScreenHeight;
    
    newFrame = NSInsetRect(newFrame, 5, 5);
    newFrame = NSIntegralRect(newFrame);
    
    [self setFrame:newFrame];
}

- (void) moveToGridProps:(CGRect)gridProps {
    [self moveToGridProps:gridProps onScreen:[self screen]];
}

- (CGRect) frame {
    CGRect r;
    r.origin = [self topLeft];
    r.size = [self size];
    return r;
}

- (void) setFrame:(CGRect)frame {
    [self setSize:frame.size];
    [self setTopLeft:frame.origin];
    [self setSize:frame.size];
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

- (void) setTopLeft:(CGPoint)thePoint {
    CFTypeRef positionStorage = (CFTypeRef)(AXValueCreate(kAXValueCGPointType, (const void *)&thePoint));
    AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilityPositionAttribute, positionStorage);
    if (positionStorage)
        CFRelease(positionStorage);
}

- (void) setSize:(CGSize)theSize {
    CFTypeRef sizeStorage = (CFTypeRef)(AXValueCreate(kAXValueCGSizeType, (const void *)&theSize));
    AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilitySizeAttribute, sizeStorage);
    if (sizeStorage)
        CFRelease(sizeStorage);
}

- (NSScreen*) screen {
    CGRect windowFrame = [self frame];
    
    CGFloat lastVolume = 0;
    NSScreen* lastScreen = nil;
    
    for (NSScreen* screen in [NSScreen screens]) {
        CGRect screenFrame = [MyWindow realFrameForScreen:screen];
        CGRect intersection = CGRectIntersection(windowFrame, screenFrame);
        CGFloat volume = intersection.size.width * intersection.size.height;
        
        if (volume > lastVolume) {
            lastVolume = volume;
            lastScreen = screen;
        }
    }
    
    return lastScreen;
}

- (void) moveToNextScreen {
    NSArray* screens = [NSScreen screens];
    NSScreen* currentScreen = [self screen];
    
    NSUInteger idx = [screens indexOfObject:currentScreen];
    
    idx += 1;
    if (idx == [screens count])
        idx = 0;
    
    NSScreen* nextScreen = [screens objectAtIndex:idx];
    [self moveToGridProps:[self gridProps] onScreen:nextScreen];
}

- (void) moveToPreviousScreen {
    NSArray* screens = [NSScreen screens];
    NSScreen* currentScreen = [self screen];
    
    NSUInteger idx = [screens indexOfObject:currentScreen];
    
    idx -= 1;
    if (idx == -1)
        idx = [screens count] - 1;
    
    NSScreen* nextScreen = [screens objectAtIndex:idx];
    [self moveToGridProps:[self gridProps] onScreen:nextScreen];
}

@end
