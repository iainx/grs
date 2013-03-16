//
//  SDPreferencesController.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "DLGeneralPrefPane.h"

#import "SharedDefines.h"

@implementation DLGeneralPrefPane

- (NSString*) title {
    return @"General";
}

- (NSString*) nibName {
    return @"GeneralPrefPane";
}

- (IBAction) changeAppearance:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:SDNoteAppearanceDidChangeNotification object:nil];
}

- (NSString*) tooltip {
	return nil;
}

@end
