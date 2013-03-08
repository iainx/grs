//
//  LCList.m
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import "LCList.h"

#import "LCLiveListArray.h"
#import "LCLoginItem.h"


@interface LCList ()

- (void) notifyAboutUpdatedItems;

@end


@implementation LCList

@synthesize isLive;
@synthesize title;

- (id) init {
    if ((self = [super init])) {
        self.isLive = NO;
        self.title = @"Untitled";
        lc_items = [[NSMutableArray array] retain];
    }
    return self;
}

- (void) dealloc {
    self.title = nil;
    [lc_items release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSCoding support

- (id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.isLive = [aDecoder decodeBoolForKey:@"isLive"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        lc_items = [[aDecoder decodeObjectForKey:@"lc_items"] retain];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.isLive forKey:@"isLive"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:lc_items forKey:@"lc_items"];
}

#pragma mark -
#pragma mark accessors

- (NSMutableArray*) items {
    if (self.isLive)
        return [LCLiveListArray sharedArray];
    else
        return lc_items;
}

#pragma mark -
#pragma mark NSCopying support

- (id)copyWithZone:(NSZone *)zone {
    LCList *newList = [[LCList alloc] init];
    newList.title = self.title;
    newList.isLive = NO;
    for (LCLoginItem *item in [self items]) {
        LCLoginItem *itemCopy = [[item copy] autorelease];
        [newList.items addObject:itemCopy];
    }
    return newList;
}

#pragma mark -
#pragma mark livening

- (void) makeLivened {
    self.isLive = YES;
    
    NSMutableArray *liveArray = [LCLiveListArray sharedArray];
    
    [liveArray removeAllObjects];
    for (LCLoginItem *item in lc_items)
        [liveArray addObject:item];
    
    // we wont be using *this* anymore, bwahahaha!
    [lc_items removeAllObjects];
}

- (void) makeDeadened {
    for (LCLoginItem *item in [self items]) {
        LCLoginItem *itemCopy = [[item copy] autorelease];
        [lc_items addObject:itemCopy];
    }
    
    self.isLive = NO;
}

#pragma mark -
#pragma mark critical methods

- (void) deleteItem:(LCLoginItem*)item withUndoManager:(NSUndoManager*)undoManager {
    NSInteger oldIndex = [self.items indexOfObject:item];
    [[undoManager prepareWithInvocationTarget:self] insertItem:item atIndex:oldIndex withUndoManager:undoManager];
    
    [self.items removeObject:item];
    
    [self notifyAboutUpdatedItems];
}

- (void) insertItem:(LCLoginItem*)item atIndex:(NSInteger)newIndex withUndoManager:(NSUndoManager*)undoManager {
    [[undoManager prepareWithInvocationTarget:self] deleteItem:item withUndoManager:undoManager];
    
    [self.items insertObject:item atIndex:newIndex];
    
    [self notifyAboutUpdatedItems];
}

- (void) moveItems:(NSArray*)someItems toIndex:(NSInteger)newIndex withUndoManager:(NSUndoManager*)undoManager {
    for (LCLoginItem *item in [someItems reverseObjectEnumerator])
        [self moveItem:item
               toIndex:newIndex
       withUndoManager:undoManager];
    
    [self notifyAboutUpdatedItems];
}

- (void) moveItem:(LCLoginItem*)item toIndex:(NSInteger)newIndex withUndoManager:(NSUndoManager*)undoManager {
    NSInteger oldIndex = [self.items indexOfObject:item];
    NSInteger undoIndex = oldIndex;
    
    if (oldIndex < newIndex)
        newIndex--;
    else
        undoIndex++;
    
    [[undoManager prepareWithInvocationTarget:self] moveItem:item
                                                     toIndex:undoIndex
                                             withUndoManager:undoManager];
    
    [item retain];
    
    [self deleteItem:item withUndoManager:undoManager];
    [self insertItem:item atIndex:newIndex withUndoManager:undoManager];
    
    [item release];
    
    [self notifyAboutUpdatedItems];
}


#pragma mark -
#pragma mark conveniences

- (void) notifyAboutUpdatedItems {
    NSNotification* note = [NSNotification notificationWithName:LCListItemsChangedNotification
                                                         object:self];
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:note
                                               postingStyle:NSPostWhenIdle
                                               coalesceMask:(NSNotificationCoalescingOnName | NSNotificationCoalescingOnSender)
                                                   forModes:nil];
}

@end
