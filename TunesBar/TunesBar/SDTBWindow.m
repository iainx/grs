//
//  SDTBWindow.m
//  TunesBar+
//
//  Created by iain on 24/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "SDTBWindow.h"
#import "SDTBWindowView.h"
#import "FVColorArt.h"

static void *windowContext = &windowContext;

@implementation SDTBWindow {
    SDTBWindowView *_realContentView;
}

@dynamic delegate;
@synthesize contentViewController = _contentViewController;

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation {
    
    if (self = [super initWithContentRect:contentRect
                                styleMask:NSBorderlessWindowMask
                                  backing:NSBackingStoreBuffered defer:deferCreation]) {
        [self setOpaque:NO];
        [self setExcludedFromWindowsMenu:NO];
        
        [self setLevel:kCGPopUpMenuWindowLevel];
        
        self.opaque = NO;
        self.backgroundColor = [NSColor clearColor];
        
        _realContentView = [[SDTBWindowView alloc] initWithFrame:contentRect];
        self.contentView = _realContentView;
        
        [_realContentView bind:@"backgroundImage" toObject:self withKeyPath:@"backgroundImage" options:nil];
    }
    return self;
}

// NSWindow will refuse to become the main window unless it has a title bar.
// Overriding lets us become the main window anyway.
//
- (BOOL)canBecomeMainWindow
{
    return YES;
}

// Much like above method.
- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (NSRect)constrainFrameRect:(NSRect)frameRect
                    toScreen:(NSScreen *)screen
{
    return frameRect;
}

// Ask our delegate if it wants to handle keystroke or mouse events before we route them.
- (void)sendEvent:(NSEvent *)theEvent
{
    if ([theEvent type] == NSKeyDown) {
        if ([self.delegate handlesKeyDown:theEvent inWindow:self]) {
            return;
        }
    }
    
    //  Offer mouse-down events (lefty or righty) to the delegate
    if (([theEvent type] == NSLeftMouseDown) || ([theEvent type] == NSRightMouseDown)) {
        if ([self.delegate handlesMouseDown:theEvent inWindow:self]) {
            return;
        }
    }
    
    //  Delegate wasn't interested, so do the usual routing.
    [super sendEvent:theEvent];
}

- (void)setContentViewController:(NSViewController *)contentViewController
{
    if (_contentViewController == contentViewController) {
        return;
    }
    
    [_contentViewController.view removeFromSuperview];
    
    _contentViewController = contentViewController;
    NSView *view = contentViewController.view;
    NSRect bounds = view.bounds;
    
    NSRect frame = self.frame;
    frame.size = bounds.size;
    
    //[self setFrame:frame display:YES];
    
    [self.contentView addSubview:view];
}

#define WINDOW_FRAME_PADDING 21
- (NSRect)contentRectForFrameRect:(NSRect)windowFrame
{
    windowFrame.origin = NSZeroPoint;
    windowFrame.size.height -= WINDOW_FRAME_PADDING;
    
    return windowFrame;
}

+ (NSRect)frameRectForContentRect:(NSRect)windowContentRect
                        styleMask:(NSUInteger)windowStyle
{
    windowContentRect.size.height += WINDOW_FRAME_PADDING;
    return windowContentRect;
}

- (void)setHeaderWidth:(CGFloat)headerWidth
{
    if (_headerWidth == headerWidth) {
        return;
    }
    
    _headerWidth = headerWidth;
    [_realContentView setWidthOfHeader:headerWidth];
}

- (void)setColorArt:(FVColorArt *)colorArt
{
    [_realContentView bind:@"backgroundColour" toObject:colorArt withKeyPath:@"backgroundColor" options:nil];
}

@end
