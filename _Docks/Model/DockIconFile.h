//
//  DockIconFile.h
//  Docks
//
//  Created by Steven Degutis on 7/18/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <CoreData/CoreData.h>

#import <NDAlias/NDAlias.h>

@class DockIcon;

typedef enum _SDDockIconType {
	SDDockIconTypeNormal,
	SDDockIconTypeFinder,
	SDDockIconTypeDashboard,
	SDDockIconTypeTrash,
} SDDockIconType;

@interface DockIconFile :  NSManagedObject {
	NSImage *icon;
	NSString *title;
}

@property (nonatomic, retain) NDAlias * alias;
@property (nonatomic, retain) NSNumber * dockIconType;
@property (nonatomic, retain) NSSet* dockIcons;

@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, retain) NSString * title;

@end


@interface DockIconFile (CoreDataGeneratedAccessors)
- (void)addDockIconsObject:(DockIcon *)value;
- (void)removeDockIconsObject:(DockIcon *)value;
- (void)addDockIcons:(NSSet *)value;
- (void)removeDockIcons:(NSSet *)value;

@end

