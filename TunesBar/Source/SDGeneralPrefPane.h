//
//  SDGeneralPrefPane.h
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SDPreferencesController.h"

#define kSDSeparatorLeftKey @"leftSeparatorSymbol"
#define kSDSeparatorMidKey @"middleSeparatorSymbol"
#define kSDSeparatorRightKey @"rightSeparatorSymbol"

@interface SDGeneralPrefPane : NSViewController <SDPreferencePane> {
}

- (IBAction) restoreSeparatorsToDefault:(id)sender;

@end
