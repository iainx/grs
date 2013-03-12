//
//  MyPrefsWindowController.h
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MASShortcutView.h"

@interface MyPrefsWindowController : NSWindowController

@property (nonatomic, weak) IBOutlet MASShortcutView *alignAllToGridShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *alignThisToGridShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *moveNextScreenShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *movePrevScreenShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *moveLeftShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *moveRightShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *growRightShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *shrinkRightShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *increaseGridWidthShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *decreaseGridWidthShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *maximizeShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *shrinkToUpperRowShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *shrinkToLowerRowShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *fillEntireColumnShortcutView;

@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowLeftShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowRightShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowUpShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *focusWindowDownShortcutView;

@end
