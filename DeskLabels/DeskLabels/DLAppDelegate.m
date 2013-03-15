//
//  DLAppDelegate.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLAppDelegate.h"

#import <ServiceManagement/ServiceManagement.h>

#import "SDPreferencesWindowController.h"
#import "SDGeneralPrefPane.h"

#import "SharedDefines.h"
#import "DLNoteWindowController.h"

#import "SDHowToWindowController.h"


@interface DLAppDelegate ()

@property NSStatusItem *statusItem;
@property IBOutlet NSMenu *statusItemMenu;

@property NSMutableArray* noteControllers;

@property SDPreferencesWindowController* prefsController;

@end


@implementation DLAppDelegate

- (void) awakeFromNib {
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	[self.statusItem setImage:[NSImage imageNamed:@"statusimage"]];
	[self.statusItem setAlternateImage:[NSImage imageNamed:@"statusimage_pressed"]];
	[self.statusItem setHighlightMode:YES];
	[self.statusItem setMenu:self.statusItemMenu];
}

- (void) someNoteChangedSomehow:(NSNotification*)note {
    [self saveNotes];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self loadNotes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(someNoteChangedSomehow:)
                                                 name:SDSomeNoteChangedSomehowNotification
                                               object:nil];
    
	if ([self.noteControllers count] == 0)
        [SDHowToWindowController showInstructionsWindow];
}

- (void) loadNotes {
    self.noteControllers = [NSMutableArray array];
    
	NSArray *notes = [[NSUserDefaults standardUserDefaults] arrayForKey:@"notes"];
	
	for (NSDictionary *dict in notes)
		[self createNoteWithDictionary:dict];
}

- (void) saveNotes {
	NSMutableArray *array = [NSMutableArray array];
	
	for (DLNoteWindowController *controller in self.noteControllers)
		[array addObject:[controller dictionaryRepresentation]];
	
	[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"notes"];
}

- (void) createNoteWithDictionary:(NSDictionary*)dictionary {
	DLNoteWindowController *controller = [[DLNoteWindowController alloc] init];
    controller.dictionaryToLoadFrom = dictionary;
    controller.noteKilled = ^(DLNoteWindowController* deadController) {
        [self.noteControllers removeObject:deadController];
        [self saveNotes];
    };
	[self.noteControllers addObject:controller];
    [controller showWindow:self];
}

- (IBAction) addNote:(id)sender {
	[self createNoteWithDictionary:nil];
    [self saveNotes];
}

- (IBAction) removeAllNotes:(id)sender {
	NSAlert *alert = [[NSAlert alloc] init];
	
	[alert setMessageText:@"Remove all desktop labels?"];
	[alert setInformativeText:@"This operation cannot be undone. Seriously."];
	
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	
	if ([alert runModal] == NSAlertFirstButtonReturn) {
		[self.noteControllers removeAllObjects];
        [self saveNotes];
    }
}

- (IBAction) reallyShowAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) showPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.prefsController == nil) {
        self.prefsController = [[SDPreferencesWindowController alloc] init];
        [self.prefsController usePreferencePaneControllerClasses:@[[SDGeneralPrefPane self]]];
    }
    
    [self.prefsController showWindow:sender];
}

- (IBAction) showHowToWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [SDHowToWindowController showInstructionsWindow];
}

- (IBAction) arrangeDesktop:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    NSLog(@"todo");
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
        return [self.noteControllers count] > 0;
    else
        return YES;
}

- (void)menuNeedsUpdate:(NSMenu *)menu {
    BOOL opensAtLogin = [self opensAtLogin];
    [[menu itemWithTitle:@"Open at Login"] setState:(opensAtLogin ? NSOnState : NSOffState)];
}

@end
