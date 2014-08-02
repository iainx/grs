//
//  SDTBAppDelegate.h
//  TunesBar
//
//  Created by Steven Degutis on 3/14/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDStatusItemController.h"

@interface SDTBAppDelegate : NSObject <NSApplicationDelegate>

@property IBOutlet SDStatusItemController* statusItemController;

- (IBAction)showAbout:(id)sender;
@end
