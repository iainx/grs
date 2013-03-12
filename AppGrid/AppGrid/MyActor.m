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

@property BOOL keysDisabled;

@end

@implementation MyActor

- (void) bindMyKeys {
    [MASShortcut setAllowsAnyHotkeyWithOptionModifier:YES];
    
    [self bindDefaultsKey:MyAlignAllToGridShortcutKey action:^{ [self alignAllWindows]; }];
    [self bindDefaultsKey:MyAlignThisToGridShortcutKey action:^{ [self alignThisWindow]; }];
    
    [self bindDefaultsKey:MyMovePrevScreenShortcutKey action:^{ [self moveToNextScreen]; }];
    [self bindDefaultsKey:MyMoveNextScreenShortcutKey action:^{ [self moveToPreviousScreen]; }];
    
    [self bindDefaultsKey:MyMoveLeftShortcutKey action:^{ [self moveLeft]; }];
    [self bindDefaultsKey:MyMoveRightShortcutKey action:^{ [self moveRight]; }];
    
    [self bindDefaultsKey:MyGrowRightShortcutKey action:^{ [self growRight]; }];
    [self bindDefaultsKey:MyShrinkRightShortcutKey action:^{ [self shrinkRight]; }];
    
    [self bindDefaultsKey:MyIncreaseGridWidthShortcutKey action:^{ [self increaseGridWidth]; }];
    [self bindDefaultsKey:MyDecreaseGridWidthShortcutKey action:^{ [self decreaseGridWidth]; }];
    
    [self bindDefaultsKey:MyMaximizeShortcutKey action:^{ [self maximize]; }];
    
    [self bindDefaultsKey:MyFocusWindowLeftShortcutKey action:^{ [self focusWindowLeft]; }];
    [self bindDefaultsKey:MyFocusWindowRightShortcutKey action:^{ [self focusWindowRight]; }];
    [self bindDefaultsKey:MyFocusWindowUpShortcutKey action:^{ [self focusWindowUp]; }];
    [self bindDefaultsKey:MyFocusWindowDownShortcutKey action:^{ [self focusWindowDown]; }];
    
    [self bindDefaultsKey:MyShrinkToLowerRowShortcutKey action:^{ [self shrinkToLower]; }];
    [self bindDefaultsKey:MyShrinkToUpperRowShortcutKey action:^{ [self shrinkToUpper]; }];
    [self bindDefaultsKey:MyFillEntireColumnShortcutKey action:^{ [self fillEntireColumn]; }];
}

- (void) bindDefaultsKey:(NSString*)key action:(dispatch_block_t)action {
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:key handler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.keysDisabled)
                return;
            
            if ([MyUniversalAccessHelper complainIfNeeded])
                return;
            
            action();
        });
    }];
}

- (void) disableKeys {
    self.keysDisabled = YES;
}

- (void) enableKeys {
    self.keysDisabled = NO;
}

#pragma mark -

- (void) focusWindowLeft {
    
    static int i = 0;
    i++;
    
//    NSLog(@"%@", [[MyWindow allWindows] valueForKey:@"frame"]);
    
    NSArray* wins = [[MyWindow focusedWindow] otherWindowsOnSameScreen];
    NSLog(@"%@", wins);
    
    if (i == [wins count])
        i = 0;
    
    [[wins objectAtIndex:i] focusWindow];
    
    NSLog(@"focusing left");
}

- (void) focusWindowRight {
//    NSLog(@"%@", [[MyWindow visibleWindows] valueForKey:@"frame"]);
//    NSLog(@"%@", [[MyWindow visibleWindows] valueForKey:@"title"]);
//    NSLog(@"%@", [[MyWindow visibleWindows] valueForKey:@"role"]);
//    NSLog(@"%@", [[MyWindow visibleWindows] valueForKey:@"isAppHidden"]);
//    NSLog(@"%@", [[MyWindow visibleWindows] valueForKey:@"isWindowMinimized"]);
    
    NSLog(@"focusing right");
}

- (void) focusWindowUp {
    NSLog(@"focusing up");
}

- (void) focusWindowDown {
    NSLog(@"focusing down");
}

- (void) maximize {
    [[MyWindow focusedWindow] maximize];
}

- (void) increaseGridWidth {
    [MyGrid setWidth:[MyGrid width] + 1];
    [self alignAllWindows];
}

- (void) decreaseGridWidth {
    [MyGrid setWidth:MAX(2, [MyGrid width] - 1)];
    [self alignAllWindows];
}

- (void) alignAllWindows {
    for (MyWindow* win in [MyWindow visibleWindows]) {
        [win moveToGridProps:[win gridProps]];
    }
}

- (void) alignThisWindow {
    MyWindow* win = [MyWindow focusedWindow];
    [win moveToGridProps:[win gridProps]];
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
    r.origin.x = MIN(r.origin.x + 1, [MyGrid width] - 1);
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

- (void) moveToNextScreen {
    MyWindow* win = [MyWindow focusedWindow];
    [win moveToNextScreen];
}

- (void) moveToPreviousScreen {
    MyWindow* win = [MyWindow focusedWindow];
    [win moveToPreviousScreen];
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

- (void) fillEntireColumn {
    MyWindow* win = [MyWindow focusedWindow];
    CGRect r = [win gridProps];
    r.origin.y = 0;
    r.size.height = 2;
    [win moveToGridProps:r];
}

@end
