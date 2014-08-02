//
//  SDTBMenuViewController.h
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDTBMenuViewController : NSViewController

@property (readwrite, weak) IBOutlet NSMenu *advancedMenu;

- (IBAction)toggleOpenAtLogin:(id)sender;

@end
