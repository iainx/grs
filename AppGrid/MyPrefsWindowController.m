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
    
    self.window.level = NSModalPanelWindowLevel;
    
    self.alignAllToGridShortcutView.associatedUserDefaultsKey = MyAlignAllToGridShortcutKey;
    self.alignThisToGridShortcutView.associatedUserDefaultsKey = MyAlignThisToGridShortcutKey;
    
    self.moveNextScreenShortcutView.associatedUserDefaultsKey = MyMoveNextScreenShortcutKey;
    self.movePrevScreenShortcutView.associatedUserDefaultsKey = MyMovePrevScreenShortcutKey;
    
    self.moveLeftShortcutView.associatedUserDefaultsKey = MyMoveLeftShortcutKey;
    self.moveRightShortcutView.associatedUserDefaultsKey = MyMoveRightShortcutKey;
    
    self.growRightShortcutView.associatedUserDefaultsKey = MyGrowRightShortcutKey;
    self.shrinkRightShortcutView.associatedUserDefaultsKey = MyShrinkRightShortcutKey;
    
    self.increaseGridWidthShortcutView.associatedUserDefaultsKey = MyIncreaseGridWidthShortcutKey;
    self.decreaseGridWidthShortcutView.associatedUserDefaultsKey = MyDecreaseGridWidthShortcutKey;
    
    self.maximizeShortcutView.associatedUserDefaultsKey = MyMaximizeShortcutKey;
    
    self.shrinkToLowerRowShortcutView.associatedUserDefaultsKey = MyShrinkToLowerRowShortcutKey;
    self.shrinkToUpperRowShortcutView.associatedUserDefaultsKey = MyShrinkToUpperRowShortcutKey;
    self.fillEntireColumnShortcutView.associatedUserDefaultsKey = MyFillEntireColumnShortcutKey;
}

- (void) resetKeysSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo; {
    if (returnCode == NSAlertAlternateReturn) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        for (NSString* key in defaults) {
            NSData* val = [defaults objectForKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
        }
    }
}

- (IBAction) resetToDefaults:(id)sender {
    NSBeginAlertSheet(@"Really reset to the default keys?",
                      @"Do Nothing",
                      @"Reset Keys",
                      nil,
                      [sender window],
                      self,
                      @selector(resetKeysSheetDidEnd:returnCode:contextInfo:),
                      NULL,
                      NULL,
                      @"This will discard your custom AppGrid hot keys.");
}

@end
