//
//  SDTBVolumeSlider.h
//  TunesBar+
//
//  Created by iain on 26/10/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDTBVolumeSlider : NSSlider

@property (readwrite, strong) NSColor *activeColor;
@property (readwrite, strong) NSColor *inactiveColor;
@end
