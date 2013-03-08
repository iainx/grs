//
//  SDGeneralPrefPane.m
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDGeneralPrefPane.h"

@implementation SDGeneralPrefPane

- (id) init {
	if (self = [super initWithNibName:@"GeneralPrefPane" bundle:nil]) {
		[self setTitle:@"General"];
	}
	return self;
}

- (NSImage*) image {
	return [NSImage imageNamed:@"NSPreferencesGeneral"];
}

- (NSString*) tooltip {
	return nil;
}

- (IBAction) restoreSeparatorsToDefault:(id)sender {
	NSString *leftSeparator = NSLocalizedStringFromTable(@"LeftSeparatorSymbol", @"UI", @"Separator between items");
	NSString *midSeparator = NSLocalizedStringFromTable(@"MiddleSeparatorSymbol", @"UI", @"Separator between items");
	NSString *rightSeparator = NSLocalizedStringFromTable(@"RightSeparatorSymbol", @"UI", @"Separator between items");
	
	[SDDefaults setObject:leftSeparator forKey:kSDSeparatorLeftKey];
	[SDDefaults setObject:midSeparator forKey:kSDSeparatorMidKey];
	[SDDefaults setObject:rightSeparator forKey:kSDSeparatorRightKey];
}

@end
