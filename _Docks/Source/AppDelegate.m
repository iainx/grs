//
//  AppDelegate.m
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "AppDelegate.h"

#import "SDMainWindowController.h"
#import "SDStatusItemController.h"

#import "SDGeneralPrefPane.h"
#import <SDGlobalShortcuts/SDGlobalShortcuts.h>

#import "SDModelController.h"

#import "DockSnapshot.h"

#import "SDDocks1Importer.h"

@interface AppDelegate (Private)
@end

#define kSDRelaunchingFromInterfaceTypeChangeKey @"relaunchingFromInterfaceTypeChange"
#define kSDFirstTimeKey @"firstTime"

@implementation AppDelegate

+ (void) initialize {
	if (self == [AppDelegate class]) {
		[NSApp registerDefaultsFromMainBundleFile:@"DefaultValues.plist"];
	}
}

- (id) init {
	if (self = [super init]) {
		SDGlobalShortcutsController *globalShortcutsController = [SDGlobalShortcutsController sharedShortcutsController];
		
		[globalShortcutsController addShortcutFromDefaultsKey:kSDShowDocksShortcutKey
													   target:self
													 selector:@selector(showMainWindowFromGlobalShortcut:)];
		
		[globalShortcutsController addShortcutFromDefaultsKey:kSDTakeSnapshotShortcutKey
													   target:self
													 selector:@selector(takeSnapshot:)];
		
		[SDSpacesBridge addObserverToChangingSpacesEvent:self];
		
		[SDDocks1Importer importDataFileIfNeeded];
	}
	return self;
}

- (SDStatusItemController*) statusItemController {
	if (statusItemController == nil)
		statusItemController = [[SDStatusItemController alloc] init];
	
	return statusItemController;
}

- (SDMainWindowController*) mainWindowController {
	if (mainWindowController == nil)
		mainWindowController = [[SDMainWindowController alloc] init];
	
	return mainWindowController;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	BOOL hideDockIcon = [SDDefaults boolForKey:kSDHideDockIconKey];
	if (hideDockIcon) {
		[[self statusItemController] toggleStatusItemVisible:YES];
	}
	else {
		ProcessSerialNumber psn;
		if (GetCurrentProcess(&psn) == noErr) {
			TransformProcessType(&psn, kProcessTransformToForegroundApplication);
			SetFrontProcess(&psn);
		}
	}
	
	if ([SDDefaults boolForKey:kSDFirstTimeKey]) {
		[self showInstructionsWindow:self];
		[SDDefaults setBool:NO forKey:kSDFirstTimeKey];
	}
}

- (void) applicationDidFinishLaunching:(NSNotification*)notification {
	if ([SDDefaults boolForKey:@"showMainWindowOnLaunch"])
		[[self mainWindowController] showWindow:self];
	
	if ([SDDefaults boolForKey:kSDRelaunchingFromInterfaceTypeChangeKey]) {
		[SDDefaults setBool:NO forKey:kSDRelaunchingFromInterfaceTypeChangeKey];
		[self showPreferencesPanel:self];
	}
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication {
	[self showMainWindow:self];
	return YES;
}

- (IBAction) toggleInterfaceType:(id)sender {
	[SDDefaults setBool:YES forKey:kSDRelaunchingFromInterfaceTypeChangeKey];
	[SDDefaults synchronize];
	
	[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]
														 options:(NSWorkspaceLaunchAsync | NSWorkspaceLaunchNewInstance)
								  additionalEventParamDescriptor:nil
												launchIdentifier:NULL];
	
	[NSApp terminate:self];
}

- (IBAction) showMainWindowFromGlobalShortcut:(id)sender {
	[self mainWindowController].windowWasShownFromGlobalShortcut = YES;
	[self showMainWindow:sender];
}

- (IBAction) showMainWindow:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	[[self mainWindowController] showWindow:sender];
}

- (IBAction) takeSnapshot:(id)sender {
	if ([SDDefaults boolForKey:@"playCameraSound"]) {
		NSSound *sound = [NSSound soundNamed:@"ShutterSound.wav"];
		[sound play];
	}
	
	[[SDDock dock] takeSnapshotWithDelegate:nil];
}

- (IBAction) toggleStatusItem:(id)sender {
	[[self statusItemController] toggleStatusItem];
}

- (void) spacesDidSwitchToSpaceWithNumber:(int)currentSpace {
	DockSnapshot *snapshot = [DockSnapshot fetchObjectsInManagedObjectContext:[SDSharedModelController managedObjectContext]
														returnOnlyFirstResult:YES
															useSortDescriptor:nil
															  predicateFormat:@"spaceToRestoreOn == %d", currentSpace];
	
	if (snapshot)
		[[SDDock dock] restoreSnapshot:snapshot];
}

// MARK: -
// MARK: SDKit-related Stuff

- (void) appRegisteredSuccessfully {
}

- (NSArray*) instructionImageNames {
	return [NSArray arrayWithObjects:
			@"intro1",
			@"intro2",
			@"intro3",
			nil];
}

- (BOOL) showsPreferencesToolbar {
	return NO;
}

- (NSArray*) preferencePaneControllerClasses {
	return [NSArray arrayWithObjects:
			[SDGeneralPrefPane class],
			nil];
}

@end
