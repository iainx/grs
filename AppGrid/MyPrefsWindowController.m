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

- (void) resetKeysSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo; {
    if (returnCode == 0) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        for (NSString* key in defaults) {
            NSData* val = [defaults objectForKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
        }
    }
}

- (IBAction) resetToDefaults:(id)sender {
    NSBeginAlertSheet(@"Are you sure you want to reset to the default keys?",
                      @"Do Nothing",
                      @"Reset Keys",
                      nil,
                      [sender window],
                      self,
                      @selector(resetKeysSheetDidEnd:returnCode:contextInfo:),
                      NULL,
                      NULL,
                      @"This can't be undone. Well, not easily at least.");
}

@end
