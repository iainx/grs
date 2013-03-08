//
//  NSSortDescriptor+Ordering.h
//  Docks
//
//  Created by Steven Degutis on 7/18/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSSortDescriptor (Useful)

+ (NSSortDescriptor*) sortDescriptorWithKey:(NSString*)key ascending:(BOOL)asc;

+ (NSSortDescriptor*) sortByIndexAscending:(BOOL)asc;

@end
