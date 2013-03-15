//
//  AppDelegate.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "AppDelegate.h"

#import "SDNoteWindowController.h"

#import "SDGeneralPrefPane.h"

#import "Finder.h"
#import "SDArrangeDesktopWindowController.h"

@interface AppDelegate (Private)

- (void) createNoteWithDictionary:(NSDictionary*)dictionary;
- (void) loadNotes;
- (void) saveNotes;

@end

@implementation AppDelegate

- (id) init {
	if (self = [super init]) {
		noteControllers = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) awakeFromNib {
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	[statusItem setImage:[NSImage imageNamed:@"statusimage"]];
	[statusItem setAlternateImage:[NSImage imageNamed:@"statusimage_pressed"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];
}

// app delegate methods

- (void) applicationDidFinishLaunching:(NSNotification*)notification {
	[self loadNotes];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[self saveNotes];
}

// persistance

- (void) loadNotes {
	NSArray *notes = [SDDefaults arrayForKey:@"notes"];
	
	if ([notes count] == 0) {
		[self showInstructionsWindow:self];
		[self setOpensAtLogin:YES];
		return;
	}
	
	for (NSDictionary *dict in notes)
		[self createNoteWithDictionary:dict];
}

- (void) saveNotes {
	NSMutableArray *array = [NSMutableArray array];
	
	for (SDNoteWindowController *controller in noteControllers)
		[array addObject:[controller dictionaryRepresentation]];
	
	[SDDefaults setObject:array forKey:@"notes"];
}

// validate menu items

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(addNote:))
		return YES;
	if ([menuItem action] == @selector(removeAllNotes:))
		return ([noteControllers count] > 0);
	else
		return [super validateMenuItem:menuItem];
}

// adding and creating notes

- (IBAction)arrangeDesktop:(id)sender {
//    FinderApplication* finder = [[SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"] retain];
//    NSLog(@"%@", finder);
    
    SDArrangeDesktopWindowController* wc = [[SDArrangeDesktopWindowController alloc] init];
    
    [wc showWindow:self];
}

- (void) createNoteWithDictionary:(NSDictionary*)dictionary {
	SDNoteWindowController *controller = [[[SDNoteWindowController alloc] initWithDictionary:dictionary] autorelease];
	[noteControllers addObject:controller];
}

- (void) removeNoteFromCollection:(SDNoteWindowController*)controller {
	[noteControllers removeObject:controller];
}

- (IBAction) addNote:(id)sender {
	[self createNoteWithDictionary:nil];
}

- (IBAction) removeAllNotes:(id)sender {
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	
	[alert setMessageText:@"Remove all desktop labels?"];
	[alert setInformativeText:@"This operation cannot be undone. Seriously."];
	
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	
	if ([alert runModal] == NSAlertFirstButtonReturn)
		[noteControllers removeAllObjects];
}

// specifics

- (void) appRegisteredSuccessfully {
	[self loadNotes];
}

- (NSArray*) instructionImageNames {
	return [NSArray arrayWithObjects:@"intro1.png", @"intro2.png", @"intro3.png", nil];
}

- (BOOL) showsPreferencesToolbar {
	return NO;
}

- (NSArray*) preferencePaneControllerClasses {
	return [NSArray arrayWithObjects:
			[SDGeneralPrefPane class],
			nil];
}

@end
