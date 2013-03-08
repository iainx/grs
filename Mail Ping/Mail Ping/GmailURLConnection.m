//
//  GmailURLConnection.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/18/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "GmailURLConnection.h"

@implementation GmailURLConnection

- (void) startConnection {
//    NSURL* url = [NSURL URLWithString:@"https://mail.google.com/mail/u/2/"];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse* r, NSData* d, NSError* e) {
//                               NSLog(@"%@", [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]);
//                           }];
    
    NSURL* url = [NSURL URLWithString:@"https://mail.google.com/mail/feed/atom"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    self.allData = [[NSMutableData alloc] init];
    self.innerConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

+ (void) getGmailFeedDataForUsername:(NSString*)username
                            password:(NSString*)password
                             handler:(void(^)(NSData* data))handler
{
    GmailURLConnection* gmailConn = [[GmailURLConnection alloc] init];
    
    gmailConn.username = username;
    gmailConn.password = password;
    gmailConn.handler = handler;
    
    [gmailConn startConnection];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[challenge sender] useCredential:[NSURLCredential credentialWithUser:self.username
                                                                 password:self.password
                                                              persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.allData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.handler(self.allData);
}

@end
