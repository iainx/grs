//
//  SDModelController.h
//  Grapevine
//
//  Created by Steven on 1/7/09.
//  Copyright 2009 Giant Robot Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDSingleton.h"

#define SDSharedModelController [SDModelController sharedModelController]

@interface SDModelController : NSObject {
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

- (void) save;

- (NSManagedObjectModel*) managedObjectModel;
- (NSPersistentStoreCoordinator*) persistentStoreCoordinator;
- (NSManagedObjectContext*) managedObjectContext;

SDSingletonDeclare(SDModelController, sharedModelController);

@end
