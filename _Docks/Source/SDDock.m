//
//  SDDock.m
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDDock.h"

#import "SDApplication.h"
#import "SDRunningApplication.h"

#import "DockSnapshot.h"

#import "SDModelController.h"

#define kSDDockAppBundleID @"com.apple.Dock"
#define kSDDockAppPersistentAppsKey @"persistent-apps"
#define kSDDockAppPersistentOthersKey @"persistent-others"

@implementation SDDock

static SDDock* sharedDock = nil;

@synthesize dockIsBusy;

+ (SDDock*) dock {
	if (sharedDock == nil)
		sharedDock = [[SDDock alloc] init];
	
	return sharedDock;
}

- (id) init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dockDied:)
													 name:SDDockDiedNotification
												   object:NSApp];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dockRestarted:)
													 name:SDDockRestartedNotification
												   object:NSApp];
	}
	return self;
}

- (void) restoreSnapshot:(DockSnapshot*)snapshot {
	if (self.dockIsBusy == YES)
		return;
	
	CFPreferencesSetAppValue((CFStringRef)kSDDockAppPersistentAppsKey, [snapshot persistentAppsArray], (CFStringRef)kSDDockAppBundleID);
	CFPreferencesSetAppValue((CFStringRef)kSDDockAppPersistentOthersKey, [snapshot persistentOthersArray], (CFStringRef)kSDDockAppBundleID);
	CFPreferencesAppSynchronize((CFStringRef)kSDDockAppBundleID);
	
	[[SDRunningApplication appWithBundleID:kSDDockAppBundleID] quit];
}

- (void) takeSnapshotWithDelegate:(id<SDDockDelegate>)newDelegate {
	if (self.dockIsBusy == YES)
		return;
	
	delegate = newDelegate;
	thisAppKilledDock = YES;
	
	[[SDRunningApplication appWithBundleID:kSDDockAppBundleID] quit];
}

- (void) dockDied:(NSNotification*)notification {
	self.dockIsBusy = YES;
}

- (void) dockRestarted:(NSNotification*)notification {
	self.dockIsBusy = NO;
	
	if (thisAppKilledDock == YES) {
		thisAppKilledDock = NO;
		
		[SDDefaults synchronize];
		NSDictionary *docksDefaults = [SDDefaults persistentDomainForName:kSDDockAppBundleID];
		
		NSArray *appsArray = [docksDefaults objectForKey:kSDDockAppPersistentAppsKey];
		NSArray *filesArray = [docksDefaults objectForKey:kSDDockAppPersistentOthersKey];
		
		DockSnapshot *snapshot = [DockSnapshot createObjectInManagedObjectContext:[SDSharedModelController managedObjectContext]];
		[snapshot setContentsOfDockWithPersistentApps:appsArray persistentOthers:filesArray];
		
		[delegate dock:self tookSnapshotSuccessfully:snapshot];
	}
}

@end
