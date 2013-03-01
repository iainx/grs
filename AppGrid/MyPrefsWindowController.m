//
//  MyPrefsWindowController.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyPrefsWindowController.h"

#import "MASShortcutView+UserDefaults.h"
#import "MyShortcuts.h"

@implementation MyPrefsWindowController

- (NSString*) windowNibName {
    return @"MyPrefsWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.alignAllToGridShortcutView.associatedUserDefaultsKey = MyAlignAllToGridShortcutKey;
    
    self.moveLeftShortcutView.associatedUserDefaultsKey = MyMoveLeftShortcutKey;
    self.moveRightShortcutView.associatedUserDefaultsKey = MyMoveRightShortcutKey;
    
    self.growRightShortcutView.associatedUserDefaultsKey = MyGrowRightShortcutKey;
    self.shrinkRightShortcutView.associatedUserDefaultsKey = MyShrinkRightShortcutKey;
    
    self.shrinkToLowerRowShortcutView.associatedUserDefaultsKey = MyShrinkToLowerRowShortcutKey;
    self.shrinkToUpperRowShortcutView.associatedUserDefaultsKey = MyShrinkToUpperRowShortcutKey;
    self.fillEntireColumnShortcutView.associatedUserDefaultsKey = MyFillEntireColumnShortcutKey;
}

@end
