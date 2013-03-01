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
