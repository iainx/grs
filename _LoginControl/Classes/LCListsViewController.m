//
//  SDListsViewController.m
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import "LCListsViewController.h"

#import "LCList.h"

#import "LCTableView.h"

@interface LCListsViewController ()

- (void) createList;
- (void) insertList:(LCList*)list atIndex:(NSInteger)someIndex;
- (void) deleteList:(LCList*)list;

- (BOOL) moveList:(LCList*)list toIndex:(NSInteger)newIndex;

- (void) setTitle:(NSString*)newTitle forList:(LCList*)list;

- (void) makeListLive:(LCList*)list;

// conveniences

- (LCList*) currentlyLiveList;

- (LCList*) listUponWhichToAct;

- (void) selectList:(LCList*)list beginEditingTitle:(BOOL)shouldEditTitle;
- (void) keepDetailViewInSync;

- (NSString*) savedListsDataFilePath;

@end

#define kLCListBeingDragged @"kLCListBeingDragged"

@implementation LCListsViewController

@synthesize delegate;

- (id) init {
    if ((self = [super initWithNibName:@"ListsView" bundle:nil])) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillTerminate:)
													 name:NSApplicationWillTerminateNotification
												   object:NSApp];
        
		lists = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self savedListsDataFilePath]] mutableCopy];
		
		if (lists == nil) {
			lists = [[NSMutableArray array] retain];
            
            LCList *initialList = [[[LCList alloc] init] autorelease];
            initialList.isLive = YES;
            initialList.title = @"Initial List";
            
            [lists addObject:initialList];
        }
    }
    return self;
}

- (void) dealloc {
	[lists release];
    
    [super dealloc];
}

- (void) loadView {
    [super loadView];
    
    [listsTableView registerForDraggedTypes:[NSArray arrayWithObject:kLCListBeingDragged]];
    
    [listsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (void) applicationWillTerminate:(NSNotification*)notification {
	[NSKeyedArchiver archiveRootObject:lists toFile:[self savedListsDataFilePath]];
}

#pragma mark -
#pragma mark creating/deleting lists

- (void) createList {
    LCList *list = [[[LCList alloc] init] autorelease];
    list.isLive = NO;
    list.title = @"Initial List";
    
    [self insertList:list atIndex:[lists count]];
}

- (void) insertList:(LCList*)list atIndex:(NSInteger)someIndex {
    [[[self undoManager] prepareWithInvocationTarget:self] deleteList:list];
    [lists insertObject:list atIndex:someIndex];
    
    [listsTableView reloadData];
    [self keepDetailViewInSync];
}

- (void) deleteList:(LCList*)list {
    if ([listsTableView editedRow] == [lists indexOfObject:list])
        return;
    
    if (list && list.isLive)
        return;
    
    NSInteger oldIndex = [lists indexOfObject:list];
    [[[self undoManager] prepareWithInvocationTarget:self] insertList:list atIndex:oldIndex];
    [lists removeObjectAtIndex:oldIndex];
    
    [listsTableView reloadData];
    [self keepDetailViewInSync];
}

- (void) setTitle:(NSString*)newTitle forList:(LCList*)list {
    [[[self undoManager] prepareWithInvocationTarget:self] setTitle:[list title] forList:list];
    [list setTitle:newTitle];
    
    [listsTableView reloadData];
}

- (void) makeListLive:(LCList*)list {
    if (list && list.isLive)
        return;
    
    LCList *oldLiveList = [self currentlyLiveList];
    [[[self undoManager] prepareWithInvocationTarget:self] makeListLive:oldLiveList];
    
    [oldLiveList makeDeadened];
    [list makeLivened];
    
    [listsTableView reloadData];
    [self keepDetailViewInSync];
}

- (BOOL) moveList:(LCList*)list toIndex:(NSInteger)newIndex {
    LCList *originallySelectedList = nil;
    NSInteger selectedRow = [listsTableView selectedRow];
    if (selectedRow != -1)
        originallySelectedList = [lists objectAtIndex:[listsTableView selectedRow]];
    
    NSInteger oldIndex = [lists indexOfObject:list];
    
    if (newIndex == oldIndex || newIndex - 1 == oldIndex)
        return NO;
    
    NSInteger undoIndex = oldIndex;
    if (undoIndex > newIndex)
        undoIndex++;
    
    [[[self undoManager] prepareWithInvocationTarget:self] moveList:list
                                                            toIndex:undoIndex];
    
    [list retain];
    
    [lists replaceObjectAtIndex:oldIndex
                     withObject:[NSNull null]];
    
    [lists insertObject:list
                atIndex:newIndex];
    
    [lists removeObject:[NSNull null]];
    
    [list release];
    
    [listsTableView reloadData];
    
    if (originallySelectedList) {
        NSInteger originallySelectedListRow = [lists indexOfObject:originallySelectedList];
        [listsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:originallySelectedListRow]
                    byExtendingSelection:NO];
    }
    
    [self keepDetailViewInSync];
    
    return YES;
}

#pragma mark -
#pragma mark actions

- (IBAction) performNewList:(id)sender {
    [self createList];
    [self selectList:[lists lastObject] beginEditingTitle:YES];
}

- (IBAction) performDuplicateList:(id)sender {
    LCList *list = [[[self listUponWhichToAct] copy] autorelease];
    list.title = [NSString stringWithFormat:@"%@ Copy", list.title];
    [self insertList:list atIndex:[lists count]];
    
    [self selectList:list beginEditingTitle:YES];
}

- (IBAction) performDeleteList:(id)sender {
    if ([self listUponWhichToAct].isLive) {
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:@"Live Lists cannot be deleted."];
        [alert setInformativeText:@"To delete this list, first set another list as the Live List"];
        [alert runModal];
        return;
    }
    
    [self deleteList:[self listUponWhichToAct]];
}

- (IBAction) performMakeListLive:(id)sender {
    [self makeListLive:[self listUponWhichToAct]];
}

#pragma mark -
#pragma mark table view: data source

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [lists count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    LCList *list = [lists objectAtIndex:row];
    
    if ([[tableColumn identifier] isEqualToString:@"isLive"]) {
        return (list.isLive ? [NSImage imageNamed:@"OrbGreen"] : nil);
    }
    else if ([[tableColumn identifier] isEqualToString:@"title"]) {
        return list.title;
    }
	
	return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    LCList *list = [lists objectAtIndex:row];
    
    if ([[tableColumn identifier] isEqualToString:@"title"]) {
        [self setTitle:object forList:list];
    }
}

#pragma mark -
#pragma mark table view: drag+drop

- (BOOL)tableView:(LCTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    NSArray *types = [NSArray arrayWithObject:kLCListBeingDragged];
    
    [pboard declareTypes:types
                   owner:self];
    
    listBeingDragged = [lists objectAtIndex:[rowIndexes firstIndex]];
    
    if (listBeingDragged.isLive == NO)
        [aTableView registerDragOffTypes:types];
    
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView
                validateDrop:(id < NSDraggingInfo >)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)operation
{
    if (operation == NSTableViewDropAbove)
        return NSDragOperationMove;
    else
        return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView
       acceptDrop:(id < NSDraggingInfo >)info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)operation
{
    return [self moveList:listBeingDragged
                  toIndex:row];
    
    listBeingDragged = nil;
}

- (BOOL) tableView:(NSTableView*)tableView shouldDragOffToDelete:(id<NSDraggingInfo>)info {
    [self deleteList:listBeingDragged];
    return YES;
}

#pragma mark -
#pragma mark table view: delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    [self keepDetailViewInSync];
}

- (NSMenu*) tableView:(NSTableView*)tableView menuForRow:(NSInteger)row {
    if (row == -1)
        return noSelectedListContextMenu;
    else
        return listContextMenu;
}

- (void) tableViewDidReceiveDeleteRequest:(NSTableView*)tableView {
    [self performDeleteList:self];
}

#pragma mark -
#pragma mark conveniences

- (void) selectList:(LCList*)list beginEditingTitle:(BOOL)shouldEditTitle {
    NSInteger row = [lists indexOfObject:list];
    
    [listsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row]
                byExtendingSelection:NO];
    
    if (shouldEditTitle)
        [listsTableView editColumn:1
                               row:row
                         withEvent:nil
                            select:YES];
}

- (LCList*) currentlyLiveList {
    for (LCList *list in lists)
        if (list.isLive)
            return list;
    return nil;
}

- (LCList*) listUponWhichToAct {
    if ([listsTableView clickedRow] != -1)
        return [lists objectAtIndex:[listsTableView clickedRow]];
    else
        return selectedList;
}

- (NSUndoManager*) undoManager {
    return [[self view] undoManager];
}

- (NSString*) savedListsDataFilePath {
	return [[NSApp appSupportSubdirectory] stringByAppendingPathComponent:@"SavedLists3.dat"];
}

- (void) keepDetailViewInSync {
    NSInteger row = [listsTableView selectedRow];
    if (row == -1)
        selectedList = nil;
    else
        selectedList = [lists objectAtIndex:row];
    
    [deleteListButton setEnabled:(selectedList != nil)];
    
    [self.delegate listsViewController:self
                       didSwitchToList:selectedList];
}

#pragma mark -
#pragma mark misc

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem {
    if ([anItem action] == @selector(performDuplicateList:))
        return ([self listUponWhichToAct] != nil);
    if ([anItem action] == @selector(performMakeListLive:))
        return ([self listUponWhichToAct] != nil && [self listUponWhichToAct].isLive == NO);
    else if ([anItem action] == @selector(performDeleteList:))
        return ([self listUponWhichToAct] != nil && [self listUponWhichToAct].isLive == NO);
    else
        return YES;
}

@end
