//
//  DLNotesManager.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLNotesManager.h"


#import "SharedDefines.h"

#import "DLNoteWindowController.h"


@interface DLNotesManager ()

@end


@implementation DLNotesManager

- (void) loadNotes {
    self.noteControllers = [NSMutableArray array];
    
	NSArray *notes = [[NSUserDefaults standardUserDefaults] arrayForKey:@"notes"];
	
	for (NSDictionary *dict in notes)
		[self createNoteWithDictionary:dict];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(someNoteChangedSomehow:)
                                                 name:SDSomeNoteChangedSomehowNotification
                                               object:nil];
    
}

- (void) someNoteChangedSomehow:(NSNotification*)note {
    [self saveNotes];
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

- (void) saveNotes {
	NSMutableArray *array = [NSMutableArray array];
	
	for (DLNoteWindowController *controller in self.noteControllers)
		[array addObject:[controller dictionaryRepresentation]];
	
	[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"notes"];
}

- (void) addNote {
	[self createNoteWithDictionary:nil];
    [self saveNotes];
}

- (void) removeAllNotes {
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

@end
