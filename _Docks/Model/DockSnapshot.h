//
//  DockSnapshot.h
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PersistentApp;
@class PersistentOther;

@interface DockSnapshot :  NSManagedObject {
	NSImage *wholeDockImage;
}

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * spaceToRestoreOn;
@property (nonatomic, retain) NSString * userDefinedName;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSSet* persistentOthers;
@property (nonatomic, retain) NSSet* persistentApps;

@property (nonatomic, retain) NSImage *wholeDockImage;

@end


@interface DockSnapshot (CoreDataGeneratedAccessors)

- (void)addPersistentOthersObject:(PersistentOther *)value;
- (void)removePersistentOthersObject:(PersistentOther *)value;
- (void)addPersistentOthers:(NSSet *)value;
- (void)removePersistentOthers:(NSSet *)value;

- (void)addPersistentAppsObject:(PersistentApp *)value;
- (void)removePersistentAppsObject:(PersistentApp *)value;
- (void)addPersistentApps:(NSSet *)value;
- (void)removePersistentApps:(NSSet *)value;

@end

@interface DockSnapshot (MyStuff)

- (void) setContentsOfDockWithPersistentApps:(NSArray*)appsArray persistentOthers:(NSArray*)filesArray;

- (NSString*) titleOfIconAtPoint:(NSPoint)point withRowHeight:(CGFloat)rowHeight;

+ (NSArray*) orderedSnapshots;

- (NSArray*) persistentAppsArray;
- (NSArray*) persistentOthersArray;

@end
