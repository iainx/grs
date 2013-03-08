//
//  PersistentApp.h
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DockIcon.h"

@class DockSnapshot;

@interface PersistentApp :  DockIcon  
{
}

@property (nonatomic, retain) DockSnapshot * snapshot;

@end



