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

- (NSRect) gridProps {
    NSRect winFrame = [self frame];
    
    NSRect screenRect = [self realScreenFrame];
    double thirdScrenWidth = screenRect.size.width / 3.0;
    double halfScreenHeight = screenRect.size.height / 2.0;
    
    NSRect gridProps;
    
    gridProps.origin.x = round((winFrame.origin.x - NSMinX(screenRect)) / thirdScrenWidth);
    gridProps.origin.y = round((winFrame.origin.y - NSMaxY(screenRect)) / halfScreenHeight);
    
    gridProps.size.width = round(winFrame.size.width / thirdScrenWidth);
    gridProps.size.height = round(winFrame.size.height / halfScreenHeight);
    
    return gridProps;
}

- (NSRect) realScreenFrame {
    NSRect original = [[NSScreen mainScreen] visibleFrame];
    NSRect reference = [[NSScreen mainScreen] frame];
    return NSMakeRect(original.origin.x,
                      reference.size.height - (reference.origin.y + original.origin.y + original.size.height),
                      original.size.width,
                      original.size.height);
}

- (void) moveToGridProps:(NSRect)gridProps {
    NSRect screenRect = [self realScreenFrame];
    
    double thirdScrenWidth = screenRect.size.width / 3.0;
    double halfScreenHeight = screenRect.size.height / 2.0;
    
    NSRect newFrame;
    
    newFrame.origin.x = (gridProps.origin.x * thirdScrenWidth) + NSMinX(screenRect);
    newFrame.origin.y = (gridProps.origin.y * halfScreenHeight) + NSMaxY(screenRect);
    newFrame.size.width = gridProps.size.width * thirdScrenWidth;
    newFrame.size.height = gridProps.size.height * halfScreenHeight;
    
    newFrame = NSInsetRect(newFrame, 5, 5);
    
    [self setFrame:newFrame];
}

- (NSRect) frame {
    NSRect r;
    r.origin = [self topLeft];
    r.size = [self size];
    return r;
}

- (void) setFrame:(NSRect)frame {
    [self setSize:frame.size];
    [self setTopLeft:frame.origin];
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

- (NSPoint) topLeft {
    CFTypeRef pos;
    
    AXError result = AXUIElementCopyAttributeValue(self.window, (CFStringRef)NSAccessibilityPositionAttribute, &pos);
    
    NSPoint topLeft = NSMakePoint(0, 0);
    if (result == kAXErrorSuccess)
        AXValueGetValue(pos, kAXValueCGPointType, (void *)&topLeft);
    else
        NSLog(@"could not get window topLeft");
    
    if (pos)
        CFRelease(pos);
    
    return topLeft;
}

- (void) setTopLeft:(NSPoint)thePoint {
    CFTypeRef pos = (CFTypeRef)(AXValueCreate(kAXValueCGPointType, (const void *)&thePoint));
    
    AXError result = AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilityPositionAttribute, pos);
    BOOL success = (result == kAXErrorSuccess);
    
    if (!success)
        NSLog(@"could not move window");
    
    if (pos)
        CFRelease(pos);
}

- (NSSize) size {
    CFTypeRef sizeStorage;
    AXError result = AXUIElementCopyAttributeValue(self.window, (CFStringRef)NSAccessibilitySizeAttribute, &sizeStorage);
    
    NSSize size = NSMakeSize(0, 0);
    if (result == kAXErrorSuccess)
        AXValueGetValue(sizeStorage, kAXValueCGSizeType, (void *)&size);
    else
        NSLog(@"could not get window size");
    
    if (sizeStorage)
        CFRelease(sizeStorage);
    
    return size;
}

- (void) setSize:(NSSize)theSize {
    CFTypeRef _size = (CFTypeRef)(AXValueCreate(kAXValueCGSizeType, (const void *)&theSize));
    
    AXError result = AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilitySizeAttribute, (CFTypeRef *)_size);
    
    if (result == kAXErrorSuccess)
        NSLog(@"could not set window size");
    
    if (_size)
        CFRelease(_size);
}

@end
