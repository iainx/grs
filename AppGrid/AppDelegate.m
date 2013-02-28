//
//  AppDelegate.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL) moveWindow:(CFTypeRef)window to:(NSPoint)thePoint {
    CFTypeRef _position = (CFTypeRef)(AXValueCreate(kAXValueCGPointType, (const void *)&thePoint));
    
    AXError result = AXUIElementSetAttributeValue(window, (CFStringRef)NSAccessibilityPositionAttribute, _position);
    BOOL success = (result != kAXErrorSuccess);
    
    if (!success)
        NSLog(@"ERROR: Could not change position");
    
    if (_position != NULL) CFRelease(_position);
    return success;
}

//- (NSString*) titleFor:(CFTypeRef)_window2 {
//    CFTypeRef _title;
//    if (AXUIElementCopyAttributeValue(_window2, (CFStringRef)NSAccessibilityTitleAttribute, (CFTypeRef *)&_title) == kAXErrorSuccess) {
//        NSString *title = (__bridge NSString *) _title;
//        if (_title != NULL) CFRelease(_title);
//        return title;
//    }
//    if (_title != NULL) CFRelease(_title);
//    return @"";
//}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        NSLog(@"%d", AXAPIEnabled());
        
        AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();
        
        CFTypeRef _app;
        AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedApplicationAttribute, &_app);
        
//        NSLog(@"%@", _app);
        
        CFTypeRef _window2;
        if (AXUIElementCopyAttributeValue(_app, (CFStringRef)NSAccessibilityFocusedWindowAttribute, &_window2) == kAXErrorSuccess) {
            
            
            BOOL a =
            [self moveWindow:_window2 to:NSMakePoint(0, 0)];
            
            NSLog(@"%d", a);
            
            
//            NSLog(@"%@", [self titleFor:_window2]);
        }
        else {
            NSLog(@"ERROR: Could not fetch focused window");
        }
    });
}

@end
