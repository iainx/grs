//
//  SDEditTitleController.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDEditTitleController.h"

#import "SDTitleFieldEditor.h"

@implementation SDEditTitleController

@synthesize forthcomingTitle;

- (id) init {
	if (self = [super initWithWindowNibName:@"EditTitlePanel"]) {
		fieldEditor = [[SDTitleFieldEditor alloc] init];
	}
	return self;
}

- (void) dealloc {
	[forthcomingTitle release];
	[fieldEditor release];
	[super dealloc];
}

- (IBAction) accept:(id)sender {
	self.forthcomingTitle = [newTitleField stringValue];
	[[self window] setDelegate:nil];
	[NSApp endSheet:[self window] returnCode:YES];
}

- (IBAction) cancel:(id)sender {
	[[self window] setDelegate:nil];
	[NSApp endSheet:[self window] returnCode:NO];
}

- (void)windowDidResignKey:(NSNotification *)notification {
	[self accept:self];
}

- (id)windowWillReturnFieldEditor:(NSWindow *)window toObject:(id)anObject {
	if (anObject == newTitleField)
		return fieldEditor;
	else
		return nil;
}

- (void) setTitle:(NSString*)title {
	[newTitleField setStringValue:title];
}

- (void) setTitleFieldWidth:(float)width {
	NSSize size = [newTitleField frame].size;
	size.width = width;
	[newTitleField setFrameSize:size];
	
	NSRect frame = [[self window] frame];
	frame.size.width = width;
	[[self window] setFrame:frame display:NO];
}

@end
