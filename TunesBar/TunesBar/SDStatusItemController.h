//
//  SDMainWindowController.h
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "iTunesProxy.h"

@interface SDStatusItemController : NSResponder <iTunesDelegate, NSPopoverDelegate>

@property (readonly) NSStatusItem *statusItem;
@property (readwrite, weak) IBOutlet NSViewController *startViewController;
@property (readwrite, weak) IBOutlet NSViewController *infoViewController;
@property (readwrite, weak) IBOutlet NSView *hudView;
@property (readwrite, weak) IBOutlet NSView *startHudView;
@property (readwrite, weak) IBOutlet NSImageView *imageView;
@property (readwrite, weak) IBOutlet NSTextField *titleField;
@property (readwrite, weak) IBOutlet NSTextField *albumField;
@property (readwrite, weak) IBOutlet NSTextField *artistField;
@property (readwrite, weak) IBOutlet NSButton *playButton;
@property (readwrite, weak) IBOutlet NSButton *previousButton;
@property (readwrite, weak) IBOutlet NSButton *nextButton;
@property (readwrite, weak) IBOutlet NSMenu *advancedMenu;
@property (readwrite, weak) IBOutlet NSButton *startITunesButton;

- (void)setupStatusItem;
- (IBAction)startiTunes:(id)sender;
- (IBAction)showAdvancedMenu:(id)sender;
- (void)hideInfoPanel;

@end
