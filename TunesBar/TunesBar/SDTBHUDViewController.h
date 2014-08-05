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
@property (readwrite, weak) IBOutlet NSTextField *detailsField;
@property (readwrite, weak) IBOutlet NSButton *playButton;
@property (readwrite, weak) IBOutlet NSButton *previousButton;
@property (readwrite, weak) IBOutlet NSButton *nextButton;

@property (readwrite, weak) IBOutlet NSMenu *advancedMenu;
@property (readwrite, weak) IBOutlet NSButton *advancedButton;

@property (readwrite, weak) IBOutlet NSView *transportView;
@property (readwrite, weak) IBOutlet NSView *detailsView;

@property (readwrite, weak) IBOutlet NSCollectionView *albumView;

@property (readonly, copy) NSString *appCredits;

@property (readwrite, strong, nonatomic) FVColorArt *colors;

@property (readwrite, weak) IBOutlet NSArrayController *tracksController;
- (IBAction)showAdvancedMenu:(id)sender;

@end
