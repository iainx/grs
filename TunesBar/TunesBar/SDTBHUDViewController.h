//
//  SDTBHUDViewController.h
//  TunesBar+
//
//  Created by iain on 25/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class iTunesProxy;
@class FVColorArt;
@interface SDTBHUDViewController : NSViewController

@property (readwrite, weak) IBOutlet NSImageView *imageView;
@property (readwrite, weak) IBOutlet NSTextField *titleField;
@property (readwrite, weak) IBOutlet NSTextField *albumField;
@property (readwrite, weak) IBOutlet NSTextField *artistField;
@property (readwrite, weak) IBOutlet NSButton *playButton;
@property (readwrite, weak) IBOutlet NSButton *previousButton;
@property (readwrite, weak) IBOutlet NSButton *nextButton;

@property (readwrite, weak) IBOutlet NSMenu *advancedMenu;
@property (readwrite, weak) IBOutlet NSButton *advancedButton;

@property (readwrite, strong, nonatomic) FVColorArt *colors;
- (IBAction)showAdvancedMenu:(id)sender;

@end
