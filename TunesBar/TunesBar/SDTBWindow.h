//
//  SDTBWindow.h
//  TunesBar+
//
//  Created by iain on 24/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FVColorArt;

@protocol SDTBWindowDelegate <NSWindowDelegate>
- (BOOL)handlesKeyDown:(NSEvent *)keyDown inWindow:(NSWindow *)window;
- (BOOL)handlesMouseDown:(NSEvent *)mouseDown inWindow:(NSWindow *)window;
@end

@interface SDTBWindow : NSPanel

@property (readwrite, weak) id<SDTBWindowDelegate> delegate;
@property (readwrite, nonatomic, strong) NSViewController *contentViewController;
@property (readwrite, nonatomic) CGFloat headerWidth;
@property (readwrite, nonatomic) NSImage *backgroundImage;

- (void)setColorArt:(FVColorArt *)colorArt;

@end
