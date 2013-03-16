//
//  SDPreferencesController.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDPreferencesWindowController.h"

@interface DLGeneralPrefPane : NSViewController <SDPreferencePane>

- (IBAction) changeAppearance:(id)sender;

@end
