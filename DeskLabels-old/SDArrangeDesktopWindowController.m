//
//  SDArrangeDesktopWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 2/25/13.
//
//

#import "SDArrangeDesktopWindowController.h"

@implementation SDArrangeDesktopWindowController

- (NSString*) windowNibName {
    return @"ArrangeDesktopWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
//    NSMutableArray* apps = [NSMutableArray array];
//    
//    for (NSRunningApplication* app in [[NSWorkspace sharedWorkspace] runningApplications]) {
//        if (app.hidden == NO) {
//            [apps addObject:app];
//            //            [app hide];
//        }
//    }
//    
//    self.apps = apps;
//    
//    [NSMenu setMenuBarVisible:NO];
//    
//    [[NSWorkspace sharedWorkspace] hideOtherApplications];
//    
//    [self performSelector:@selector(finishTheJob) withObject:nil afterDelay:0];
}

//- (void) finishTheJob {
//    [NSApp activateIgnoringOtherApps:YES];
//}

- (IBAction) doneArrangingDesktop:(id)sender {
    [self close];
//    [NSMenu setMenuBarVisible:YES];
//    
//    for (NSRunningApplication* app in self.apps) {
//        [app unhide];
//    }
}

@end
