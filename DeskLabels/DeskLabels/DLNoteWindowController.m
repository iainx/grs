//
//  DLNoteWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "DLNoteWindowController.h"

#import "SharedDefines.h"
#import "DLEditTitleController.h"
#import <QuartzCore/QuartzCore.h>

@interface DLNoteWindowController ()

@property DLEditTitleController *currentEditTitleController;

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSBox *backgroundBox;
@property (weak) IBOutlet NSButton *closeButton;

@property BOOL mouseHoveringOverBox;
@property BOOL mouseHoveringOverButton;
@property BOOL isEditing;

@property BOOL shouldShowCloseButton;

@property NSTrackingArea *boxTrackingArea;
@property NSTrackingArea *buttonTrackingArea;

@end

@implementation DLNoteWindowController

- (NSString*) windowNibName {
    return @"NoteWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noteAppearanceDidChange:)
                                                 name:SDNoteAppearanceDidChangeNotification
                                               object:nil];
    
	[[self window] setMovableByWindowBackground:YES];
	//[[[self window] contentView] setWantsLayer:YES];
	
	[self updateNoteAppearance];
	
	if (self.dictionaryToLoadFrom) {
		NSString *title = [self.dictionaryToLoadFrom objectForKey:@"title"];
		NSString *frameString = [self.dictionaryToLoadFrom objectForKey:@"frame"];
		
		NSRect frame = NSRectFromString(frameString);
		
		[self setTitle:title];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self window] setFrame:frame display:NO];
        });
		
		[self showWindowWithAnimation:NO];
		
		self.dictionaryToLoadFrom = nil;
	}
	else {
		[self showWindowWithAnimation:YES];
	}
	
	int options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect);
	self.boxTrackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                        options:options
                                                          owner:self
                                                       userInfo:nil];
	
	self.buttonTrackingArea = [self.boxTrackingArea copy];
	
	[self.backgroundBox addTrackingArea:self.boxTrackingArea];
	[self.closeButton addTrackingArea:self.buttonTrackingArea];
}

- (void) updateNoteAppearance {
	switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"appearance"]) {
		case 0: // dark
			[self.backgroundBox setFillColor:[[NSColor blackColor] colorWithAlphaComponent:0.5]];
			[self.titleLabel setTextColor:[NSColor whiteColor]];
			[[self.titleLabel cell] setBackgroundStyle:NSBackgroundStyleLowered];
			break;
		case 1: // light
			[self.backgroundBox setFillColor:[[NSColor whiteColor] colorWithAlphaComponent:0.5]];
			[[self.titleLabel cell] setBackgroundStyle:NSBackgroundStyleRaised];
			[self.titleLabel setTextColor:[NSColor blackColor]];
			break;
	}
}

- (void) noteAppearanceDidChange:(NSNotification*)notification {
	[self updateNoteAppearance];
}

- (void) showWindowWithAnimation:(BOOL)animate {
	if (animate) {
		[[self window] setAlphaValue:0.0];
		[[self window] orderFront:self];
		[[[self window] animator] setAlphaValue:1.0];
	}
	else {
		[[self window] orderFront:self];
	}
}

- (NSDictionary*) dictionaryRepresentation {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:NSStringFromRect([[self window] frame]) forKey:@"frame"];
	[dictionary setObject:[self.titleLabel stringValue] forKey:@"title"];
	return dictionary;
}

// MARK: -
// MARK: Close Button

- (void) conditionallyShowCloseButton {
	self.shouldShowCloseButton = ((self.mouseHoveringOverBox || self.mouseHoveringOverButton) && (self.isEditing == NO));
	[[self.closeButton animator] setHidden:!self.shouldShowCloseButton];
}

// shoot

- (void) setHoveringOverNote:(NSNumber*)hovering {
	self.mouseHoveringOverBox = [hovering boolValue];
	[self conditionallyShowCloseButton];
}

- (void) futureSetHoveringOverNote:(BOOL)hovering {
	[self performSelector:@selector(setHoveringOverNote:) withObject:[NSNumber numberWithBool:hovering] afterDelay:0.5];
}

- (void) futureCancelSetHoveringOverNote:(BOOL)hovering {
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(setHoveringOverNote:) object:[NSNumber numberWithBool:hovering]];
}

// end shoot

- (void) mouseEntered:(NSEvent*)event {
	if ([event trackingArea] == self.boxTrackingArea) {
		[self futureCancelSetHoveringOverNote:NO];
		[self futureSetHoveringOverNote:YES];
	}
	else if ([event trackingArea] == self.buttonTrackingArea)
		self.mouseHoveringOverButton = YES;
	
	[self conditionallyShowCloseButton];
}

- (void) mouseExited:(NSEvent*)event {
	if ([event trackingArea] == self.boxTrackingArea) {
		[self futureCancelSetHoveringOverNote:YES];
		[self futureSetHoveringOverNote:NO];
	}
	else if ([event trackingArea] == self.buttonTrackingArea)
		self.mouseHoveringOverButton = NO;
	
	[self conditionallyShowCloseButton];
}

- (IBAction) deleteNote:(id)sender {
	NSWindow *window = [self window];
	
	CAAnimation *animation = [[window animationForKey:@"alphaValue"] copy];
	[window setAnimations:[NSDictionary dictionaryWithObject:animation forKey:@"alphaValue"]];
	animation.delegate = self;
	[[window animator] setAlphaValue:0.0];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    self.noteKilled(self);
}

- (void)windowDidMove:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:SDSomeNoteChangedSomehowNotification object:nil];
}

// MARK: -
// MARK: Setting Title

- (void) setTitle:(NSString*)title {
	NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *newTitle = [title stringByTrimmingCharactersInSet:characterSet];
	
	[self.titleLabel setStringValue:newTitle];
	[self.titleLabel sizeToFit];
	
	NSSize boxSize = [self.backgroundBox frame].size;
	boxSize.width = NSWidth([self.titleLabel frame]) + 26.0;
	[self.backgroundBox setFrameSize:boxSize];
	
	NSRect windowFrame = [[self window] frame];
	
	float difference = boxSize.width - NSWidth(windowFrame);
	
	windowFrame.origin.x -= difference / 2.0 + 20.0;
	windowFrame.size.width = boxSize.width + 40.0;
	
	[[self window] setFrame:windowFrame display:YES];
}

- (void) editTitle {
	self.currentEditTitleController = [[DLEditTitleController alloc] init];
	
	[self.currentEditTitleController setTitleFieldWidth:NSWidth([self.titleLabel frame])];
	[self.currentEditTitleController setTitle:[self.titleLabel stringValue]];
	
	self.isEditing = YES;
	
	[[self window] setLevel:kCGNormalWindowLevel];
	
	[NSApp beginSheet:[self.currentEditTitleController window]
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(editTitleSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:NULL];
}

- (void) editTitleSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	[[self window] setLevel:kCGDesktopIconWindowLevel + 1];
	
	[sheet orderOut:self];
	self.isEditing = NO;
	
	if (returnCode == YES)
		[self setTitle:self.currentEditTitleController.forthcomingTitle];
    
    self.currentEditTitleController = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDSomeNoteChangedSomehowNotification object:nil];
}

@end
