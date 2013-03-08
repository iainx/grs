// 
//  DockSnapshot.m
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "DockSnapshot.h"

#import "PersistentOther.h"
#import "PersistentApp.h"

#import "DockIconFile.h"

#import "SDModelController.h"

#import "NSSortDescriptor+Useful.h"

@interface DockSnapshot (Private)

- (void) drawIcon:(NSImage*)icon atPosition:(float)position;

@end

@implementation DockSnapshot 

@dynamic index;
@dynamic spaceToRestoreOn;
@dynamic userDefinedName;
@dynamic creationDate;
@dynamic persistentOthers;
@dynamic persistentApps;

@synthesize wholeDockImage;

+ (NSArray*) orderedSnapshots {
	return [DockSnapshot fetchObjectsInManagedObjectContext:[SDSharedModelController managedObjectContext]
									  returnOnlyFirstResult:NO
										  useSortDescriptor:[NSSortDescriptor sortByIndexAscending:YES]
											predicateFormat:nil];
}

- (void) awakeFromInsert {
	self.creationDate = [NSDate date];
	
	int nextIndex = 0;
	DockSnapshot *highestNumberSnapshot = [DockSnapshot fetchObjectsInManagedObjectContext:[self managedObjectContext]
																	 returnOnlyFirstResult:YES
																		 useSortDescriptor:[NSSortDescriptor sortByIndexAscending:NO]
																		   predicateFormat:@"SELF != %@", self];
	
	if (highestNumberSnapshot)
		nextIndex = [highestNumberSnapshot.index intValue] + 1;
	
	self.index = NSINT(nextIndex);
}

- (void) didTurnIntoFault {
	self.wholeDockImage = nil;
}

- (void) setContentsOfDockWithPersistentApps:(NSArray*)appsArray persistentOthers:(NSArray*)filesArray {
	int i = 0;
	
	PersistentApp *finder = [PersistentApp createObjectInManagedObjectContext:[self managedObjectContext]];
	finder.file = [DockIconFile createObjectInManagedObjectContext:[self managedObjectContext]];
	finder.file.dockIconType = NSINT(SDDockIconTypeFinder);
	finder.snapshot = self;
	finder.index = NSINT(i++);
	
	for (NSDictionary *appDict in appsArray) {
		PersistentApp *app = [PersistentApp createObjectInManagedObjectContext:[self managedObjectContext]];
		
		app.file = [DockIconFile createObjectInManagedObjectContext:[self managedObjectContext]];
		
		if ([[appDict valueForKeyPath:@"tile-type"] isEqualToString: @"dashboard-tile"]) {
			app.file.dockIconType = NSINT(SDDockIconTypeDashboard);
		}
		else {
			NSData *aliasData = [appDict valueForKeyPath:@"tile-data.file-data._CFURLAliasData"];
			app.file.alias = [NDAlias aliasWithData:aliasData];
		}
		
		app.plistDictionary = appDict;
		app.snapshot = self;
		app.index = NSINT(i++);
	}
	
	i = 0;
	for (NSDictionary *fileDict in filesArray) {
		PersistentOther *other = [PersistentOther createObjectInManagedObjectContext:[self managedObjectContext]];
		
		other.file = [DockIconFile createObjectInManagedObjectContext:[self managedObjectContext]];
		
		NSData *aliasData = [fileDict valueForKeyPath:@"tile-data.file-data._CFURLAliasData"];
		other.file.alias = [NDAlias aliasWithData:aliasData];
		
		other.plistDictionary = fileDict;
		other.snapshot = self;
		other.index = NSINT(i++);
	}
	
	PersistentOther *trash = [PersistentOther createObjectInManagedObjectContext:[self managedObjectContext]];
	trash.file = [DockIconFile createObjectInManagedObjectContext:[self managedObjectContext]];
	trash.file.dockIconType = NSINT(SDDockIconTypeTrash);
	trash.snapshot = self;
	trash.index = NSINT(i++);
}

- (NSArray*) persistentAppsArray {
	NSMutableArray *array = [NSMutableArray array];
	for (PersistentApp *app in [PersistentApp orderedIconsInSnapshot:self]) {
		NSDictionary *dict = app.plistDictionary;
		if (dict)
			[array addObject:dict];
	}
	return array;
}

- (NSArray*) persistentOthersArray {
	NSMutableArray *array = [NSMutableArray array];
	for (PersistentOther *other in [PersistentOther orderedIconsInSnapshot:self]) {
		NSDictionary *dict = other.plistDictionary;
		if (dict)
			[array addObject:dict];
	}
	return array;
}

#define SDIconWidth (64.0)
#define SDIconHeight (SDIconWidth)
#define SDIconDividerSpace (6.0)
#define SDStreetAreaWidth (32.0)
#define SDMarginWidth (8.0)
#define SDFullIconWidth (SDIconWidth + SDIconDividerSpace)

- (NSString*) titleOfIconAtPoint:(NSPoint)point withRowHeight:(CGFloat)rowHeight {
	float visibleIconWidth = (rowHeight / 1.5);
	float visibleFactor = visibleIconWidth / SDIconWidth;
	
	float dividerSpace = SDIconDividerSpace * visibleFactor;
	float marginWidth = SDMarginWidth * visibleFactor;
	float streetAreaWidth = SDStreetAreaWidth * visibleFactor;
	
	float fullIconWidth = (visibleIconWidth + dividerSpace);
	
	point.x -= marginWidth;
	
	int itemIndex = point.x / (fullIconWidth);
	
	NSArray *appItems = [PersistentApp orderedIconsInSnapshot:self];
	
	if (itemIndex < [appItems count]) {
		PersistentApp *app = [appItems objectAtIndex:itemIndex];
		return app.file.title;
	}
	else {
		point.x -= streetAreaWidth;
		int itemIndex = point.x / (fullIconWidth);
		
		itemIndex -= [appItems count];
		
		if (itemIndex < 0)
			return nil;
		
		NSArray *otherItems = [PersistentOther orderedIconsInSnapshot:self];
		
		if (itemIndex < [otherItems count]) {
			PersistentOther *other = [otherItems objectAtIndex:itemIndex];
			return other.file.title;
		}
	}
	
	return nil;
}

- (NSImage*) wholeDockImage {
	if (wholeDockImage == nil) {
		NSArray *iconsFromApps = [[PersistentApp orderedIconsInSnapshot:self] valueForKeyPath:@"file.icon"];
		NSArray *iconsFromOthers = [[PersistentOther orderedIconsInSnapshot:self] valueForKeyPath:@"file.icon"];
		
		int totalItemsCount = ([iconsFromApps count] + [iconsFromOthers count]);
		
		NSSize wholeImageSize;
		wholeImageSize.width = (totalItemsCount * SDFullIconWidth) + SDStreetAreaWidth + (SDMarginWidth * 2.0);
		wholeImageSize.height = SDIconHeight * 1.5;
		
		self.wholeDockImage = [[[NSImage alloc] initWithSize:wholeImageSize] autorelease];
		
		[wholeDockImage lockFocus];
		
		float position = 0;
		
		for (NSImage *icon in iconsFromApps)
			[self drawIcon:icon atPosition:(position++)];
		
		float positionOfStreet = SDMarginWidth + (SDFullIconWidth * position) - (SDIconDividerSpace / 2.0);
		
		NSColor *grayishColor = [NSColor colorWithCalibratedWhite:0.60 alpha:0.20];
		[grayishColor setFill];
		
		NSRect streetRect;
		streetRect.size = NSMakeSize(SDStreetAreaWidth / 2.0, (SDIconWidth / 16.0));
		streetRect.origin.x = positionOfStreet + (SDStreetAreaWidth / 4.0);
		
		for (int i = 0; i < 6; i++) {
			streetRect.origin.y = (SDIconWidth / 2.15) + (i * 2 * (SDIconWidth / 12.0));
			[NSBezierPath fillRect:streetRect];
		}
		
		// push the rest of the icons over more
		position += (SDStreetAreaWidth / SDIconWidth); // should be 0.5
		
		for (NSImage *icon in iconsFromOthers)
			[self drawIcon:icon atPosition:(position++)];
		
		[wholeDockImage unlockFocus];
	}
	
	return wholeDockImage;
}

- (void) drawIcon:(NSImage*)icon atPosition:(float)position {
	float x = SDMarginWidth + (position * SDFullIconWidth) + (SDIconDividerSpace / 2.0);
	
	NSRect imageFrame;
	imageFrame.size = NSMakeSize(SDIconWidth, SDIconHeight);
	imageFrame.origin = NSMakePoint(x, (SDIconHeight / 2.5));
	
	NSRect imageUpsideDownFrame = imageFrame;
	imageUpsideDownFrame.origin = NSMakePoint(x, (SDIconWidth / 1.9) - SDIconWidth);
	
	[icon setFlipped:YES];
	[icon drawInRect:imageUpsideDownFrame
			fromRect:NSZeroRect
		   operation:NSCompositeSourceOver
			fraction:0.07];
	
	[icon setFlipped:NO];
	[icon drawInRect:imageFrame
			fromRect:NSZeroRect
		   operation:NSCompositeSourceOver
			fraction:1.0];
}

@end
