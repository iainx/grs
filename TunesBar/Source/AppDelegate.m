//
//  AppDelegate.m
//  CocoaApp
//
//  Created by Steven Degutis on 7/23/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "AppDelegate.h"

#import "NSApplication+AppInfo.h"

#import "SDGeneralPrefPane.h"

#import "SDDefines.h"

#define kSDFirstTimeUsing_v3_0_Key @"firstTimeUsing_v3_0"

@implementation AppDelegate

+ (void) initialize {
	if (self == [AppDelegate class]) {
		[NSApp registerDefaultsFromMainBundleFile:@"DefaultValues.plist"];
	}
}

- (id) init {
	if ((self = [super init])) {
	}
	return self;
}

- (SDStatusItemController*) statusItemController {
	if (statusItemController == nil)
		statusItemController = [[SDStatusItemController alloc] init];
	
	return statusItemController;
}

- (void) applicationDidFinishLaunching:(NSNotification*)notification {
	[self statusItemController];
	
	if ([SDDefaults boolForKey:kSDFirstTimeUsing_v3_0_Key] == YES) {
		[self showInstructionsWindow:self];
		[SDDefaults setBool:NO forKey:kSDFirstTimeUsing_v3_0_Key];
	}
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
