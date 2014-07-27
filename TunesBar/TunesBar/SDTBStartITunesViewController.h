//
//  SDTBStartITunesViewController.h
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDTBStartITunesViewController : NSViewController

@property (readwrite, weak) IBOutlet NSButton *advancedButton;

- (IBAction)startiTunes:(id)sender;
- (IBAction)showAdvancedMenu:(id)sender;
@end
