//
//  SDGeneralPrefPane.h
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <ShortcutRecorder/ShortcutRecorder.h>

#import "SDPreferencesController.h"

#define kSDTakeSnapshotShortcutKey @"TakeSnapshotShortcutKey"
#define kSDShowDocksShortcutKey @"ShowDocksShortcutKey"
#define kSDHideDockIconKey @"hideDockIcon"

@interface SDGeneralPrefPane : NSViewController <SDPreferencePane> {
	IBOutlet SRRecorderControl *takeSnapshotShortcutRecorder;
	IBOutlet SRRecorderControl *showDocksShortcutRecorder;
}

@end
