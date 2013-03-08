//
//  GmailFeed.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GmailFeed : NSObject

@property NSString* lastModified;
@property NSInteger unreadCount;
@property NSArray* unreadEntries;

+ (void) getFeedForUsername:(NSString*)username
                   password:(NSString*)password
                    handler:(void(^)(GmailFeed* feed))handler;

@end
