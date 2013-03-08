//
//  GmailFeed.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "GmailFeed.h"

#import "GmailEntry.h"

#import "GmailURLConnection.h"

@implementation GmailFeed

+ (void) getFeedForUsername:(NSString*)username
                   password:(NSString*)password
                    handler:(void(^)(GmailFeed* feed))handler
{
    [GmailURLConnection getGmailFeedDataForUsername:username
                                           password:password
                                            handler:^(NSData *d) {
                                                NSError* __autoreleasing error;
                                                
                                                NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData:d options:0 error:&error];
                                                if (doc == nil) {
                                                    NSLog(@"error reading feed: %@", error);
                                                    return;
                                                }
                                                
                                                GmailFeed* feed = [[GmailFeed alloc] init];
                                                
                                                feed.unreadCount = [[[[doc nodesForXPath:@"//feed/fullcount" error:NULL] lastObject] stringValue] integerValue];
                                                feed.lastModified = [[[doc nodesForXPath:@"//feed/modified" error:NULL] lastObject] stringValue];
                                                feed.unreadEntries = [GmailEntry entriesFromNodes:[doc nodesForXPath:@"//entry" error:NULL]];
                                                
                                                handler(feed);
                                            }];
}

@end
