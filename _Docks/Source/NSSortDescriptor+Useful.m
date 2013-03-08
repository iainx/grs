//
//  NSSortDescriptor+Ordering.m
//  Docks
//
//  Created by Steven Degutis on 7/18/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "NSSortDescriptor+Useful.h"


@implementation NSSortDescriptor (Useful)

+ (NSSortDescriptor*) sortDescriptorWithKey:(NSString*)key ascending:(BOOL)asc {
	return [[[NSSortDescriptor alloc] initWithKey:key ascending:asc] autorelease];
}

+ (NSSortDescriptor*) sortByIndexAscending:(BOOL)asc {
	return [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:asc];
}

@end
