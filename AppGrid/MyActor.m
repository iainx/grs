//
//  MyActor.m
//  AppGrid
//
//  Created by Steven Degutis on 3/1/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyActor.h"

#import "MyUniversalAccessHelper.h"
#import "MASShortcut+UserDefaults.h"
#import "MyShortcuts.h"
#import "MyWindow.h"
#import "MyGrid.h"

@interface MyActor ()

@property BOOL keysAreUnbound;

@end

@implementation MyActor

- (void) bindMyKeys {
    [self bindDefaultsKey:MyAlignAllToGridShortcutKey action:^{ [self alignAllWindows]; }];
    
    [self bindDefaultsKey:MyMoveLeftShortcutKey action:^{ [self moveLeft]; }];
    [self bindDefaultsKey:MyMoveRightShortcutKey action:^{ [self moveRight]; }];
    
    [self bindDefaultsKey:MyGrowRightShortcutKey action:^{ [self growRight]; }];
    [self bindDefaultsKey:MyShrinkRightShortcutKey action:^{ [self shrinkRight]; }];
    
    [self bindDefaultsKey:MyShrinkToLowerRowShortcutKey action:^{ [self shrinkToLower]; }];
    [self bindDefaultsKey:MyShrinkToUpperRowShortcutKey action:^{ [self shrinkToUpper]; }];
    [self bindDefaultsKey:MyFillEntireColumnShortcutKey action:^{ [self fillEntierColumn]; }];
}

- (void) alignAllWindows {
    for (MyWindow* win in [MyWindow allWindows]) {
        [win moveToGridProps:[win gridProps]];
    }
}

- (void) moveLeft {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.x = MAX(r.origin.x - 1, 0);
    [win moveToGridProps:r];
}

- (void) moveRight {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.x = MIN(r.origin.x + 1, [MyGrid width] - r.size.width);
    [win moveToGridProps:r];
}

- (void) growRight {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MIN(r.size.width + 1, [MyGrid width] - r.origin.x);
    [win moveToGridProps:r];
}

- (void) shrinkRight {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.size.width = MAX(r.size.width - 1, 1);
    [win moveToGridProps:r];
}

- (void) shrinkToLower {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 1;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) shrinkToUpper {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 1;
    [win moveToGridProps:r];
}

- (void) fillEntierColumn {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 2;
    [win moveToGridProps:r];
}

- (void) bindDefaultsKey:(NSString*)key action:(dispatch_block_t)action {
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:key handler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.keysAreUnbound)
                return;
            
            if ([MyUniversalAccessHelper complainIfNeeded])
                return;
            
            action();
        });
    }];
}

- (void) unbindMyKeys {
    self.keysAreUnbound = YES;
}

@end
