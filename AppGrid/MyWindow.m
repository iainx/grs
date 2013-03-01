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
    
    if (pos)
        CFRelease(pos);
    
    return topLeft;
}

- (void) setTopLeft:(NSPoint)thePoint {
    CFTypeRef pos = (CFTypeRef)(AXValueCreate(kAXValueCGPointType, (const void *)&thePoint));
    
    AXError result = AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilityPositionAttribute, pos);
    BOOL success = (result != kAXErrorSuccess);
    
    if (!success)
        NSLog(@"could not move window");
    
    if (pos)
        CFRelease(pos);
}

- (NSSize) size {
    CFTypeRef sizeStorage;
    AXError result = AXUIElementCopyAttributeValue(self.window, (CFStringRef)NSAccessibilitySizeAttribute, &sizeStorage);
    
    NSSize size = NSMakeSize(0, 0);
    if (result == kAXErrorSuccess) {
        AXValueGetValue(sizeStorage, kAXValueCGSizeType, (void *)&size);
    }
    
    if (sizeStorage)
        CFRelease(sizeStorage);
    
    return size;
}

- (void) setSize:(NSSize)theSize {
    CFTypeRef _size = (CFTypeRef)(AXValueCreate(kAXValueCGSizeType, (const void *)&theSize));
    
    AXUIElementSetAttributeValue(self.window, (CFStringRef)NSAccessibilitySizeAttribute, (CFTypeRef *)_size);
    
    if (_size)
        CFRelease(_size);
}

@end
