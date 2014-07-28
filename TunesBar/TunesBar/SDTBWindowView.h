//
//  SDTBWindowView.h
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDTBWindowView : NSView

@property (readwrite, nonatomic) CGFloat widthOfHeader;
@property (readwrite, nonatomic, strong) NSColor *backgroundColour;
@end
