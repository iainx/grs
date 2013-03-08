//
//  SDGeneralPrefPane.m
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDGeneralPrefPane.h"

#import <SDGlobalShortcuts/SDGlobalShortcuts.h>

@implementation SDGeneralPrefPane

- (id) init {
	if (self = [super initWithNibName:@"GeneralPrefPane" bundle:nil]) {
		[self setTitle:@"General"];
	}
	return self;
}

- (NSImage*) image {
	return [NSImage imageNamed:@"NSPreferencesGeneral"];
}

- (NSString*) tooltip {
	return nil;
}

- (void) awakeFromNib {
	SDGlobalShortcutsController *globalShortcutsController = [SDGlobalShortcutsController sharedShortcutsController];
	[globalShortcutsController attachControl:takeSnapshotShortcutRecorder toDefaultsKey:kSDTakeSnapshotShortcutKey];
	[globalShortcutsController attachControl:showDocksShortcutRecorder toDefaultsKey:kSDShowDocksShortcutKey];
}

@end
