//
//  SDDocks1Importer.m
//  Docks
//
//  Created by Steven Degutis on 7/19/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDDocks1Importer.h"

#import "SDModelController.h"
#import "DockSnapshot.h"

#define kSDImportedFromDocks1Key @"kSDImportedFromDocks1Key"

@implementation SDDocks1Importer

+ (void) importDataFileIfNeeded {
	if ([SDDefaults boolForKey:kSDImportedFromDocks1Key] == YES)
		return;
	
	NSMutableArray *snapshots = [NSMutableArray array];
	
	NSString *dockSetsPath = [[NSApp appSupportSubdirectory] stringByAppendingPathComponent:@"Docks.dat"];
	NSData *dockSetsData = [NSData dataWithContentsOfFile:dockSetsPath];
	if (dockSetsData) {
		[snapshots addObjectsFromArray:[NSUnarchiver unarchiveObjectWithData:dockSetsData]];
		
		for (NSDictionary *snapshot in snapshots) {
			NSString *userDefinedName = [snapshot objectForKey:@"name"];
			NSArray *apps = [snapshot objectForKey:@"apps"];
			NSArray *files = [snapshot objectForKey:@"files"];
			
			DockSnapshot *snapshot = [DockSnapshot createObjectInManagedObjectContext:[SDSharedModelController managedObjectContext]];
			[snapshot setContentsOfDockWithPersistentApps:apps persistentOthers:files];
			snapshot.userDefinedName = userDefinedName;
		}
		
		[SDDefaults setBool:YES forKey:kSDImportedFromDocks1Key];
	}
}

@end
