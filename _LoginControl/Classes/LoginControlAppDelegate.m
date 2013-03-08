//
//  AppDelegate.m
//  CocoaApp
//
//  Created by Steven Degutis on 7/23/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "LoginControlAppDelegate.h"

#import "NSApplication+AppInfo.h"

@implementation LoginControlAppDelegate

+ (void) initialize {
	if (self == [LoginControlAppDelegate class]) {
		[NSApp registerDefaultsFromMainBundleFile:@"DefaultValues.plist"];
	}
}

- (id) init {
	if (self = [super init]) {
	}
	return self;
}

- (LCMainWindowController*) mainWindowController {
	if (mainWindowController == nil)
		mainWindowController = [[LCMainWindowController alloc] init];
	
	return mainWindowController;
}

- (void) applicationDidFinishLaunching:(NSNotification*)notification {
    [self showMainWindow:self];
}

- (IBAction) showMainWindow:(id)sender {
	[[self mainWindowController] showWindow:sender];
}

- (NSArray*) instructionImageNames {
	return [NSArray array];
}

- (BOOL) showsPreferencesToolbar {
	return NO;
}

- (NSArray*) preferencePaneControllerClasses {
	return [NSArray arrayWithObjects:
			nil];
}

@end
