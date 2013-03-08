//
//  PersistentOther.h
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DockIcon.h"


@interface PersistentOther :  DockIcon  
{
}

@property (nonatomic, retain) NSManagedObject * snapshot;

@end



