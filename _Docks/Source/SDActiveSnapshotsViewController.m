//
//  SDActiveSnapshotsViewController.m
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDActiveSnapshotsViewController.h"

#import "SDModelController.h"
#import "DockSnapshot.h"

#import "NSSortDescriptor+Useful.h"

@implementation SDActiveSnapshotsViewController

#define kSDDockSnapshotPboardType @"kSDDockSnapshotPboardType"

- (id) init {
	if (self = [super initWithNibName:@"ActiveSnapshotsView" bundle:nil]) {
	}
	return self;
}

- (void) awakeFromNib {
	[tableView registerForDraggedTypes:[NSArray arrayWithObject:kSDDockSnapshotPboardType]];
	[tableView setDoubleAction:@selector(restoreSnapshot:)];
	
	[snapshotCell setImageAlignment:NSImageAlignTopLeft];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortByIndexAscending:YES];
	[snapshotsArrayController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	int spacesCount = [SDDefaults integerForKey:@"spacesCount"];
	for (int i = 0; i < spacesCount; i++)
		[restoreSpacePopupButton addItemWithTitle:NSSTRINGF(@"Space %d", (i + 1))];
}

// MARK: -
// MARK: Enabling the Spaces menu items

- (void) menuNeedsUpdate:(NSMenu*)menu {
	if (menu == [restoreSpacePopupButton menu]) {
		for (NSMenuItem *item in [menu itemArray])
			[item setEnabled:YES];
		
		for (DockSnapshot *snapshot in [DockSnapshot orderedSnapshots]) {
			int space = [snapshot.spaceToRestoreOn intValue];
			
			if (space > 0)
				[[menu itemAtIndex:(space)] setEnabled:NO];
		}
	}
}

- (void)menuDidClose:(NSMenu *)menu {
	if (menu == [restoreSpacePopupButton menu])
		[self performSelector:@selector(enableSelectedPopUpButtonMenuItem)
				   withObject:nil
				   afterDelay:0.0];
}

- (void) enableSelectedPopUpButtonMenuItem {
	for (NSMenuItem *item in [restoreSpacePopupButton itemArray]) {
		[item setEnabled:YES];
	}
}

// MARK: -
// MARK: Reordering Table

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
	[pboard declareTypes:[NSArray arrayWithObject:kSDDockSnapshotPboardType] owner:self];
	[pboard setString:[NSString stringWithFormat:@"%d", [rowIndexes firstIndex]] forType:kSDDockSnapshotPboardType];
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation {
	if (operation == NSTableViewDropAbove)
		return NSDragOperationMove;
	else
		return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
	int sourceRow = [[[info draggingPasteboard] stringForType:kSDDockSnapshotPboardType] intValue];
	
	if (row > sourceRow)
		row--;
	
	if (row == sourceRow)
		return NO;
	
	NSMutableArray *snapshots = [[[DockSnapshot orderedSnapshots] mutableCopy] autorelease];
	
	[snapshots moveObjectFromIndex:sourceRow toIndex:row];
	
	int i = 0;
	for (DockSnapshot *snapshot in snapshots)
		snapshot.index = NSINT(i++);
	
	[SDSharedModelController save];
	
	return YES;
}

@end
