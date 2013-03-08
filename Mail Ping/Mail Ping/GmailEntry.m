//
//  GmailEntry.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "GmailEntry.h"

@implementation GmailEntry

+ (NSArray*) entriesFromNodes:(NSArray*)nodes {
    NSMutableArray* entries = [NSMutableArray array];
    for (NSXMLNode* node in nodes)
        [entries addObject:[self entryFromNode:node]];
    return entries;
}

+ (GmailEntry*) entryFromNode:(NSXMLNode*)node {
    GmailEntry* entry = [[GmailEntry alloc] init];
    entry.title = [[[node nodesForXPath:@"title" error:NULL] lastObject] stringValue];
    entry.summary = [[[node nodesForXPath:@"summary" error:NULL] lastObject] stringValue];
    entry.authorName = [[[node nodesForXPath:@"author/name" error:NULL] lastObject] stringValue];
    entry.authorEmail = [[[node nodesForXPath:@"author/email" error:NULL] lastObject] stringValue];
    entry.link = [[[node nodesForXPath:@"link/@href" error:NULL] lastObject] stringValue];
    return entry;
}

@end
