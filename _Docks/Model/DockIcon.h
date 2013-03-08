//
//  DockIcon.h
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DockIconFile;
@class DockSnapshot;

@interface DockIcon :  NSManagedObject  
{
}

@property (nonatomic, retain) DockIconFile * file;
@property (nonatomic, retain) NSDictionary * plistDictionary;
@property (nonatomic, retain) NSNumber * index;

@end

@interface DockIcon (Private)

+ (NSArray*) orderedIconsInSnapshot:(DockSnapshot*)snapshot;

@end
