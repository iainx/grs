//
//  MyFeedbackWindowController.h
//  AppGrid
//
//  Created by Steven Degutis on 3/5/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyFeedbackWindowController : NSWindowController <NSWindowDelegate>

@property NSString* type;
@property NSString* name;
@property NSString* email;
@property NSString* body;

@property BOOL isSending;

@end
