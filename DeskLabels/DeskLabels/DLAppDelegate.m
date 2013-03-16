//
//  DLAppDelegate.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLAppDelegate.h"


#import "DLArrangeDesktopWindowController.h"

#import <ServiceManagement/ServiceManagement.h>

#import "DLFinderProxy.h"

#import "SDPreferencesWindowController.h"
#import "DLGeneralPrefPane.h"

#import "SDHowToWindowController.h"

#import "DLNotesManager.h"


@interface DLAppDelegate ()

@property NSStatusItem *statusItem;
@property IBOutlet NSMenu *statusItemMenu;

@property DLNotesManager* notesManager;

@property SDPreferencesWindowController* prefsController;

@property DLArrangeDesktopWindowController* arrangeDesktopWindowController;

@end


@implementation DLAppDelegate

- (void) awakeFromNib {
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	[self.statusItem setImage:[NSImage imageNamed:@"statusimage"]];
	[self.statusItem setAlternateImage:[NSImage imageNamed:@"statusimage_pressed"]];
	[self.statusItem setHighlightMode:YES];
	[self.statusItem setMenu:self.statusItemMenu];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.notesManager = [[DLNotesManager alloc] init];
    [self.notesManager loadNotes];
    
	if ([self.notesManager.noteControllers count] == 0)
        [SDHowToWindowController showInstructionsWindow];
}

- (IBAction) addNote:(id)sender {
    [self.notesManager addNote];
}

- (IBAction) removeAllNotes:(id)sender {
    [self.notesManager removeAllNotes];
}

- (IBAction) reallyShowAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) showPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.prefsController == nil) {
        self.prefsController = [[SDPreferencesWindowController alloc] init];
        [self.prefsController usePreferencePaneControllerClasses:@[[DLGeneralPrefPane self]]];
    }
    
    [self.prefsController showWindow:sender];
}

- (IBAction) showHowToWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [SDHowToWindowController showInstructionsWindow];
}

- (IBAction) arrangeDesktop:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.arrangeDesktopWindowController == nil) {
        self.arrangeDesktopWindowController = [[DLArrangeDesktopWindowController alloc] init];
        
        __weak DLAppDelegate* weakSelf = self;
        
        self.arrangeDesktopWindowController.doneArrangingDesktop = ^{
            weakSelf.arrangeDesktopWindowController = nil;
        };
    }
    
    [DLFinderProxy showDesktop];
    
    self.arrangeDesktopWindowController.noteControllers = self.notesManager.noteControllers;
    [self.arrangeDesktopWindowController showWindow:self];
}

- (IBAction) toggleOpenAtLogin:(id)sender {
	NSInteger changingToState = ![sender state];
    if (!SMLoginItemSetEnabled(CFSTR("org.degutis.DeskLabelsHelper"), changingToState)) {
        NSRunAlertPanel(@"Could not change Open at Login status",
                        @"For some reason, this failed. Most likely it's because the app isn't in the Applications folder.",
                        @"OK",
                        nil,
                        nil);
    }
}

- (BOOL) opensAtLogin {
    CFArrayRef jobDictsCF = SMCopyAllJobDictionaries( kSMDomainUserLaunchd );
    NSArray* jobDicts = (__bridge_transfer NSArray*)jobDictsCF;
    // Note: Sandbox issue when using SMJobCopyDictionary()
    
    if ((jobDicts != nil) && [jobDicts count] > 0) {
        BOOL bOnDemand = NO;
        
        for (NSDictionary* job in jobDicts) {
            if ([[job objectForKey:@"Label"] isEqualToString: @"org.degutis.DeskLabelsHelper"]) {
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
        
        return bOnDemand;
    }
    return NO;
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
    if ([menuItem action] == @selector(removeAllNotes:))
        return [self.notesManager.noteControllers count] > 0;
    else
        return YES;
}

- (void)menuNeedsUpdate:(NSMenu *)menu {
    BOOL opensAtLogin = [self opensAtLogin];
    [[menu itemWithTitle:@"Open at Login"] setState:(opensAtLogin ? NSOnState : NSOffState)];
}

@end
