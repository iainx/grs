//
//  SDSpacesPopUpButtonCell.m
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDSpacesPopUpButtonCell.h"


@implementation SDSpacesPopUpButtonCell

- (void)selectItemAtIndex:(NSInteger)index {
	[super selectItemAtIndex:(NSInteger)index];
	
	for (NSMenuItem *item in [self itemArray])
		[item setEnabled:YES];
}

@end
