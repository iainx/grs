//
//  NSMainTableView.h
//  Docks
//
//  Created by Steven Degutis on 7/16/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SDFauxTooltip;

@interface SDMainTableView : NSTableView {
	NSGradient *highlightGradient;
	BOOL safeToResize;
	
	SDFauxTooltip *tooltip;
}

@end
