//
//  SDItemsViewController.m
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import "LCItemsViewController.h"

#import "LCList.h"
#import "LCLiveListArray.h"
#import "LCLoginItem.h"

#import "LCTableView.h"

@interface LCItemsViewController ()

// conveniences

- (void) addFilesAtPaths:(NSArray*)filenames toIndex:(NSInteger)newIndex;

- (NSArray*) itemsUponWhichToAct;

- (void) autoenableDeleteButton;

- (void) saveSelectedItems;

@end


#define kLCLoginItemsBeingDragged @"kLCLoginItemsBeingDragged"


@implementation LCItemsViewController

@synthesize representedList;

- (id) init {
    if ((self = [super initWithNibName:@"ItemsView" bundle:nil])) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(someListsContentsDidChange:)
         name:LCLiveListArrayDidChangeNotification
         object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(someListsContentsDidChange:)
         name:LCListItemsChangedNotification
         object:nil];
    }
    return self;
}

- (void) dealloc {
    [selectedItems release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void) loadView {
    [super loadView];
    
    [itemsTableView setDoubleAction:@selector(performRevealItemsInFinder:)];
    
    [itemsTableView registerForDraggedTypes:[NSArray arrayWithObjects:
                                             kLCLoginItemsBeingDragged,
                                             NSFilenamesPboardType,
                                             nil]];
    
    [self autoenableDeleteButton];
}

#pragma mark -
#pragma mark actions

- (IBAction) performAddItem:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setResolvesAliases:NO];
    
    [openPanel beginSheetForDirectory:nil
                                 file:nil
                                types:nil
                       modalForWindow:[[self view] window]
                        modalDelegate:self
                       didEndSelector:@selector(addLoginItemsOpenPanelDidEnd:returnCode:contextInfo:)
                          contextInfo:NULL];
}

- (void) addLoginItemsOpenPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo {
    if (returnCode == NSOKButton)
        [self addFilesAtPaths:[panel filenames]
                      toIndex:[representedList.items count]];
}

- (void) addFilesAtPaths:(NSArray*)filenames toIndex:(NSInteger)newIndex {
    for (NSString *path in [filenames reverseObjectEnumerator]) {
        NDAlias *alias = [NDAlias aliasWithPath:path];
        LCLoginItem *item = [[[LCLoginItem alloc] initWithAlias:alias] autorelease];
        
        if ([representedList.items indexOfObject:item] != NSNotFound)
            continue;
        
        [representedList insertItem:item
                            atIndex:newIndex
                    withUndoManager:[self undoManager]];
    }
}

- (IBAction) performRemoveSelectedItems:(id)sender {
    [self performSelector:@selector(performRemoveSelectedItemsOnNextRunloop:)
               withObject:[self itemsUponWhichToAct]
               afterDelay:0.0];
}

- (void) performRemoveSelectedItemsOnNextRunloop:(NSArray*)items {
    for (LCLoginItem *item in items) {
        [representedList deleteItem:item
                    withUndoManager:[self undoManager]];
    }
}

- (IBAction) performRevealItemsInFinder:(id)sender {
	for (LCLoginItem *item in [self itemsUponWhichToAct])
		[[NSWorkspace sharedWorkspace] selectFile:[[item alias] path]
                         inFileViewerRootedAtPath:nil];
}

#pragma mark -
#pragma mark table view: data source

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [representedList.items count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    LCLoginItem *item = [representedList.items objectAtIndex:row];
    
    if ([[tableColumn identifier] isEqualToString:@"displayName"]) {
        return item;
    }
    else if ([[tableColumn identifier] isEqualToString:@"kind"]) {
        return item.kind;
    }
    return nil;
}

#pragma mark -
#pragma mark table view: drag + drop

- (BOOL)tableView:(LCTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObjects:
                          NSFilenamesPboardType,
                          kLCLoginItemsBeingDragged,
                          nil]
                   owner:self];
    
    NSArray *selectedLoginItems = [representedList.items objectsAtIndexes:rowIndexes];
    NSMutableArray *filenames = [[[selectedLoginItems valueForKeyPath:@"alias.path"] mutableCopy] autorelease];
    [filenames removeObject:[NSNull null]];
    
    [aTableView registerDragOffTypes:[NSArray arrayWithObject:kLCLoginItemsBeingDragged]];
    
    [pboard setPropertyList:[[filenames copy] autorelease]
                    forType:NSFilenamesPboardType];
    
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:rowIndexes]
            forType:kLCLoginItemsBeingDragged];
    
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView
                validateDrop:(id < NSDraggingInfo >)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)operation
{
    if (operation == NSTableViewDropOn)
        // uhhh, no. sorry.
        return NSDragOperationNone;
    else if ([info draggingSource] == itemsTableView)
        // just reordering
        return NSDragOperationMove;
    else
        // holy shit, its coming from outside the app!!!
        return NSDragOperationLink;
}

- (BOOL)tableView:(NSTableView *)aTableView
       acceptDrop:(id < NSDraggingInfo >)info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)operation
{
    NSPasteboard *pboard = [info draggingPasteboard];
    
    if ([[pboard types] containsObject:kLCLoginItemsBeingDragged]) {
        // came from us
        
        NSData *indexesData = [pboard dataForType:kLCLoginItemsBeingDragged];
        NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:indexesData];
        
        NSArray *itemsToMove = [representedList.items objectsAtIndexes:rowIndexes];
        
        [representedList moveItems:itemsToMove
                           toIndex:row
                   withUndoManager:[self undoManager]];
    }
    else {
        // came from another app
        
        NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
        
        [self addFilesAtPaths:filenames
                      toIndex:row];
    }
    
//    [itemsTableView reloadData];
    
    return YES;
}

- (BOOL) tableView:(NSTableView*)tableView shouldDragOffToDelete:(id<NSDraggingInfo>)info {
    NSPasteboard *pboard = [info draggingPasteboard];
    NSData *indexesData = [pboard dataForType:kLCLoginItemsBeingDragged];
    NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:indexesData];
    
    NSArray *itemsToDelete = [representedList.items objectsAtIndexes:rowIndexes];
    
    for (LCLoginItem *item in itemsToDelete)
        [representedList deleteItem:item
                    withUndoManager:[self undoManager]];
    
    [itemsTableView reloadData];
    
    return YES;
}

#pragma mark -
#pragma mark table view: delegate

- (NSMenu*) tableView:(NSTableView*)tableView menuForRow:(NSInteger)row {
    if (row == -1)
        return noSelectedFileContextMenu;
    else
        return fileContextMenu;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification {
    [self saveSelectedItems];
    [self autoenableDeleteButton];
}

- (void) tableViewDidReceiveDeleteRequest:(NSTableView*)tableView {
    [self performRemoveSelectedItems:self];
}

#pragma mark -
#pragma mark conveniences

- (void) autoenableDeleteButton {
    [deleteFilesButton setEnabled:(representedList != nil) && ([[itemsTableView selectedRowIndexes] count] > 0)];
}

- (void) didSwitchToDifferentList {
    [addFilesButton setEnabled:(representedList != nil)];
    [self autoenableDeleteButton];
    
    [itemsTableView reloadData];
    [itemsTableView deselectAll:self];
    [self saveSelectedItems];
}

- (void) saveSelectedItems {
    [selectedItems release];
    selectedItems = nil;
    
    NSIndexSet *indexSet = [itemsTableView selectedRowIndexes];
    if (indexSet)
        selectedItems = [[representedList.items objectsAtIndexes:indexSet] retain];
}

- (void) someListsContentsDidChange:(NSNotification*)note {
    BOOL isLiveList = ([[note name] isEqualToString:LCLiveListArrayDidChangeNotification] && representedList.isLive);
    if (representedList == [note object] || isLiveList) {
        [itemsTableView reloadData];
        
        if ([selectedItems count] > 0) {
            NSMutableIndexSet *updatedRowIndexes = [NSMutableIndexSet indexSet];
            for (NSUInteger i = 0; i < [representedList.items count]; i++) {
                NSObject *item = [representedList.items objectAtIndex:i];
                
                if ([selectedItems containsObject:item])
                    [updatedRowIndexes addIndex:i];
            }
            
            [itemsTableView selectRowIndexes:updatedRowIndexes
                        byExtendingSelection:NO];
        }
        [self saveSelectedItems];
    }
}

- (NSUndoManager*) undoManager {
    return [[self view] undoManager];
}

- (NSArray*) itemsUponWhichToAct {
//    NSArray *itemsForContextMenu = nil;
    NSIndexSet *indexes = nil;
    
    NSInteger clickedRow = [itemsTableView clickedRow];
    NSIndexSet *selectedRowIndexes = [itemsTableView selectedRowIndexes];
    
    if (clickedRow != -1) {
        if ([selectedRowIndexes containsIndex:clickedRow])
            indexes = selectedRowIndexes;
        else
            indexes = [NSIndexSet indexSetWithIndex:clickedRow];
    }
    else {
        indexes = selectedRowIndexes;
    }
    
    return [representedList.items objectsAtIndexes:indexes];
}

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem {
    if ([anItem action] == @selector(performAddItem:))
        return (representedList != nil);
    else if ([anItem action] == @selector(performRemoveSelectedItems:))
        return (representedList != nil) && ([[self itemsUponWhichToAct] count] > 0);
    else
        return YES;
}

@end
