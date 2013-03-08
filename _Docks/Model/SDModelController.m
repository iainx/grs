//
//  SDModelController.m
//  Grapevine
//
//  Created by Steven on 1/7/09.
//  Copyright 2009 Giant Robot Software. All rights reserved.
//

#import "SDModelController.h"

@implementation SDModelController

SDSingletonInit(SDModelController, sharedModelController) {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:NSApp];
}

- (void) applicationWillTerminate:(NSNotification*)notification {
	[self save];
}

- (void) save {
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error])
        [NSApp presentError:error];
}

- (NSManagedObjectModel*) managedObjectModel {
	if (managedObjectModel == nil)
		managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
	if (persistentStoreCoordinator == nil) {
		NSString *filepath = [[NSApp appSupportSubdirectory] stringByAppendingPathComponent:@"Docks2.dat"];
		NSURL *url = [NSURL fileURLWithPath:filepath];
		
		persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		
		NSError *error = nil;
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
			[NSApp presentError:error];
	}
	return persistentStoreCoordinator;
}

- (NSManagedObjectContext*) managedObjectContext {
	if (managedObjectContext == nil) {
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		if (coordinator) {
			managedObjectContext = [[NSManagedObjectContext alloc] init];
			[managedObjectContext setPersistentStoreCoordinator: coordinator];
		}
	}
	return managedObjectContext;
}

@end
