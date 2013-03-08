//
//  LCLiveListArray.m
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import "LCLiveListArray.h"


#import "LCLoginItem.h"


@interface LCLiveListArray ()

void LCSharedFileListObservance(LSSharedFileListRef inList, void *context);
- (void) recacheList;

@end



@implementation LCLiveListArray

+ (LCLiveListArray*) sharedArray {
    static LCLiveListArray *sharedArray;
    if (!sharedArray)
        sharedArray = [[LCLiveListArray alloc] init];
    return sharedArray;
}

void LCSharedFileListObservance(LSSharedFileListRef inList, void *context) {
	[(id)context recacheList];
}

- (id) init {
    if ((self = [super init])) {
		sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
		LSSharedFileListAddObserver(sharedFileList,
									CFRunLoopGetMain(),
									kCFRunLoopDefaultMode,
									LCSharedFileListObservance,
									self);
        [self recacheList];
    }
    return self;
}

- (void) dealloc {
    CFRelease(sharedFileList);
    [internalArray release];
    
    [super dealloc];
}

- (void) recacheList {
	UInt32 seed;
    CFArrayRef newList = LSSharedFileListCopySnapshot(sharedFileList, &seed);
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (CFIndex i = 0; i < CFArrayGetCount(newList); i++) {
        LSSharedFileListItemRef sharedFileItem = (void*)CFArrayGetValueAtIndex(newList, i);
        LCLoginItem *item = [[[LCLoginItem alloc] initWithSharedFileItem:sharedFileItem] autorelease];
        [tempArray addObject:item];
    }
    
    [internalArray release];
    internalArray = [tempArray copy];
    
    CFRelease(newList);
    
    NSNotification *note = [NSNotification notificationWithName:LCLiveListArrayDidChangeNotification
                                                         object:self];
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:note
                                               postingStyle:NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName | NSNotificationCoalescingOnSender)
                                                   forModes:nil];
}

#pragma mark NSArray compliance

- (NSUInteger) count {
    return [internalArray count];
}

- (id)objectAtIndex:(NSUInteger)idx {
    return [internalArray objectAtIndex:idx];
}

#pragma mark NSMutableArray compliance

- (void)insertObject:(id)anObject atIndex:(NSUInteger)idx {
    if ([anObject isBroken])
        return;
    
    NSString *path = [[anObject alias] path];
    NSURL *URL = [NSURL fileURLWithPath:path];
    
    LSSharedFileListItemRef sharedItemToInsertAfter;
    if (idx == 0)
        sharedItemToInsertAfter = kLSSharedFileListItemBeforeFirst;
    else
        sharedItemToInsertAfter = [[internalArray objectAtIndex:idx-1] sharedFileItem];
    
    LSSharedFileListItemRef newItem;
    newItem = LSSharedFileListInsertItemURL(sharedFileList,
                                            sharedItemToInsertAfter,
                                            NULL,
                                            NULL,
                                            (CFURLRef)URL,
                                            NULL,
                                            NULL);
    CFRelease(newItem);
    
    [self recacheList];
}

- (void)removeObjectAtIndex:(NSUInteger)idx {
    LSSharedFileListItemRemove(sharedFileList, [[internalArray objectAtIndex:idx] sharedFileItem]);
    
    [self recacheList];
}

- (void)addObject:(id)anObject {
    [self insertObject:anObject atIndex:[internalArray count]];
}

- (void)removeLastObject {
    LSSharedFileListItemRemove(sharedFileList, [[internalArray lastObject] sharedFileItem]);
    
    [self recacheList];
}

- (void)replaceObjectAtIndex:(NSUInteger)idx withObject:(id)anObject {
    [self removeObjectAtIndex:idx];
    [self insertObject:anObject atIndex:idx];
}

- (void) removeAllObjects {
    LSSharedFileListRemoveAllItems(sharedFileList);
    
    [self recacheList];
}

@end
