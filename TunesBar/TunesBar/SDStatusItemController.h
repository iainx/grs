//
//  SDMainWindowController.h
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "iTunesProxy.h"

@interface SDStatusItemController : NSResponder <iTunesDelegate>

@property (readwrite, weak) IBOutlet NSView *hubView;
@property (readwrite, weak) IBOutlet NSImageView *imageView;
@property (readwrite, weak) IBOutlet NSTextField *titleField;
@property (readwrite, weak) IBOutlet NSTextField *albumField;
@property (readwrite, weak) IBOutlet NSTextField *artistField;
@property (readwrite, weak) IBOutlet NSButton *playButton;
@property (readwrite, weak) IBOutlet NSButton *previousButton;
@property (readwrite, weak) IBOutlet NSButton *nextButton;

- (void) setupStatusItem;

@end
