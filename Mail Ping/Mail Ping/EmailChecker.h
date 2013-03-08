//
//  EmailChecker.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UnreadEmailsColorizer <NSObject>

- (void) markSomeUnread:(BOOL)someUnread;

@end

@interface EmailChecker : NSObject <NSUserNotificationCenterDelegate>

@property NSMutableDictionary* lastCheckedTimes;

- (void) checkEmail;
- (void) forceCheckEmail;

@property NSDate *lastChecked;

@property (weak) id<UnreadEmailsColorizer> delegate;

@end
