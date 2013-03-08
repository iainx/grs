//
//  GmailEntry.h
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GmailEntry : NSObject

@property NSString* title;
@property NSString* summary;
@property NSString* authorName;
@property NSString* authorEmail;
@property NSString* link;

+ (NSArray*) entriesFromNodes:(NSArray*)nodes;
+ (GmailEntry*) entryFromNode:(NSXMLNode*)node;

@end
