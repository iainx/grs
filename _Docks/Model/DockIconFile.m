// 
//  DockIconFile.m
//  Docks
//
//  Created by Steven Degutis on 7/18/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "DockIconFile.h"

#import "DockIcon.h"

@implementation DockIconFile 

@dynamic alias;
@dynamic dockIconType;
@dynamic dockIcons;

@synthesize icon;
@synthesize title;

static NSImage *finderIcon = nil;
static NSImage *dashboardIcon = nil;
static NSImage *trashIcon = nil;
static NSImage *missingIcon = nil;

+ (void) initialize {
	if (self == [DockIconFile class]) {
		NSBundle *finderBundle = [NSBundle bundleWithPath:@"/System/Library/CoreServices/Finder.app"];
		NSBundle *dockBundle = [NSBundle bundleWithPath:@"/System/Library/CoreServices/Dock.app"];
		NSBundle *coreTypesBundle = [NSBundle bundleWithPath:@"/System/Library/CoreServices/CoreTypes.bundle"];
		
		NSString *finderIconPath = [finderBundle pathForResource:@"Finder" ofType:@"icns"];
		NSString *dashboardIconPath = [dockBundle pathForResource:@"dashboard" ofType:@"png"];
		NSString *missingIconPath = [dockBundle pathForResource:@"notfound" ofType:@"png"];
		NSString *trashIconPath = [coreTypesBundle pathForResource:@"TrashIcon" ofType:@"icns"];
		
		finderIcon = [[NSImage alloc] initWithContentsOfFile:finderIconPath];
		dashboardIcon = [[NSImage alloc] initWithContentsOfFile:dashboardIconPath];
		trashIcon = [[NSImage alloc] initWithContentsOfFile:trashIconPath];
		missingIcon = [[NSImage alloc] initWithContentsOfFile:missingIconPath];
	}
}

- (NSString*) title {
	if (title == nil) {
		switch ([self.dockIconType intValue]) {
			case SDDockIconTypeNormal:
				self.title = [self.alias displayName];
				break;
			case SDDockIconTypeDashboard:
				self.title = @"Dashboard";
				break;
			case SDDockIconTypeFinder:
				self.title = @"Finder";
				break;
			case SDDockIconTypeTrash:
				self.title = @"Trash";
				break;
		}
	}
	
	return title;
}

- (NSImage*) icon {
	if (icon == nil) {
		switch ([self.dockIconType intValue]) {
			case SDDockIconTypeNormal:
			{
				NSString *fullPath = [self.alias path];
				if (fullPath)
					self.icon = [[NSWorkspace sharedWorkspace] iconForFile:fullPath];
				else
					self.icon = missingIcon;
				break;
			}
			case SDDockIconTypeDashboard:
				self.icon = dashboardIcon;
				break;
			case SDDockIconTypeFinder:
				self.icon = finderIcon;
				break;
			case SDDockIconTypeTrash:
				self.icon = trashIcon;
				break;
		}
	}
	return icon;
}

- (void) didTurnIntoFault {
	self.icon = nil;
	self.title = nil;
}

@end
