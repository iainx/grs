//
//  SDGeneralPrefPane.m
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDGeneralPrefPane.h"

@implementation SDGeneralPrefPane

- (NSString*) nibName {
    return @"GeneralPrefPane";
}

- (NSString*) title {
    return @"General";
}

- (NSImage*) image {
	return [NSImage imageNamed:@"NSPreferencesGeneral"];
}

- (IBAction) restoreSeparatorsToDefault:(id)sender {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DefaultValues" ofType:@"plist"];
	NSDictionary *initialValues = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
	NSString *leftSeparator = [initialValues objectForKey:@"leftSeparatorSymbol"];
	NSString *midSeparator = [initialValues objectForKey:@"middleSeparatorSymbol"];
	NSString *rightSeparator = [initialValues objectForKey:@"rightSeparatorSymbol"];
	
	[[NSUserDefaults standardUserDefaults] setObject:leftSeparator forKey:kSDSeparatorLeftKey];
	[[NSUserDefaults standardUserDefaults] setObject:midSeparator forKey:kSDSeparatorMidKey];
	[[NSUserDefaults standardUserDefaults] setObject:rightSeparator forKey:kSDSeparatorRightKey];
}

@end
