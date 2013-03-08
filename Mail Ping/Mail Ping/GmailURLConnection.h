//
//  GmailURLConnection.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/18/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GmailURLConnection : NSObject

@property NSString* username;
@property NSString* password;
@property (copy) void(^handler)(NSData* data);

@property NSURLConnection *innerConnection;
@property NSMutableData* allData;

+ (void) getGmailFeedDataForUsername:(NSString*)username
                            password:(NSString*)password
                             handler:(void(^)(NSData* data))handler;

@end
