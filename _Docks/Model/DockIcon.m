// 
//  DockIcon.m
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "DockIcon.h"

#import "DockIconFile.h"

#import "SDModelController.h"

#import "NSSortDescriptor+Useful.h"

@implementation DockIcon 

@dynamic file;
@dynamic plistDictionary;
@dynamic index;

+ (NSArray*) orderedIconsInSnapshot:(DockSnapshot*)snapshot {
	return [self fetchObjectsInManagedObjectContext:[SDSharedModelController managedObjectContext]
							  returnOnlyFirstResult:NO
								  useSortDescriptor:[NSSortDescriptor sortByIndexAscending:YES]
									predicateFormat:@"snapshot == %@", snapshot];
}

@end
