//
//  SDEditTitleController.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDEditTitleController.h"

#import "SDTitleFieldEditor.h"


@interface SDEditTitleController ()

@property (weak) IBOutlet NSTextField *upcomingTitleField;

@property SDTitleFieldEditor *fieldEditor;

@end


@implementation SDEditTitleController

@synthesize forthcomingTitle;

- (NSString*) windowNibName {
    return @"EditTitlePanel";
}

- (IBAction) accept:(id)sender {
	self.forthcomingTitle = [self.upcomingTitleField stringValue];
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
    if (self.fieldEditor == nil)
        self.fieldEditor = [[SDTitleFieldEditor alloc] init];
    
	if (anObject == self.upcomingTitleField)
		return self.fieldEditor;
	else
		return nil;
}

- (void) setTitle:(NSString*)title {
	[self.upcomingTitleField setStringValue:title];
}

- (void) setTitleFieldWidth:(float)width {
	NSSize size = [self.upcomingTitleField frame].size;
	size.width = width;
	[self.upcomingTitleField setFrameSize:size];
	
	NSRect frame = [[self window] frame];
	frame.size.width = width;
	[[self window] setFrame:frame display:NO];
}

@end
