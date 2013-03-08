//
//  LCList.h
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class LCLoginItem;

#define LCListItemsChangedNotification @"LCListItemsChangedNotification"

@interface LCList : NSObject <NSCopying, NSCoding> {
    BOOL isLive;
    NSString *title;
    NSMutableArray *lc_items;
}

@property BOOL isLive;
@property (copy) NSString *title;
@property (readonly) NSMutableArray *items;

- (void) makeLivened;
- (void) makeDeadened;

- (void) deleteItem:(LCLoginItem*)item withUndoManager:(NSUndoManager*)undoManager;
- (void) insertItem:(LCLoginItem*)item atIndex:(NSInteger)newIndex withUndoManager:(NSUndoManager*)undoManager;

- (void) moveItems:(NSArray*)items toIndex:(NSInteger)newIndex withUndoManager:(NSUndoManager*)undoManager;
- (void) moveItem:(LCLoginItem*)item toIndex:(NSInteger)newIndex withUndoManager:(NSUndoManager*)undoManager;

@end
