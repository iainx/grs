//
//  SDTBWindow.m
//  TunesBar+
//
//  Created by iain on 24/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "SDTBWindow.h"
#import "SDTBWindowView.h"
@implementation SDTBWindow {
    SDTBWindowView *_realContentView;
}

@dynamic delegate;

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
        
        _realContentView = [[SDTBWindowView alloc] initWithFrame:contentRect];
        self.contentView = _realContentView;
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
/*
- (void)setContentView:(NSView *)aView
{
    if ([childContentView isEqualTo:aView])
    {
        return;
    }
    
    NSRect bounds = [self frame];
    bounds.origin = NSZeroPoint;
    
    RoundWindowFrameView *frameView = [super contentView];
    if (!frameView)
    {
        frameView =
        [[[RoundWindowFrameView alloc]
          initWithFrame:bounds]
         autorelease];
        
        [super setContentView:frameView];
    }
    
    if (childContentView)
    {
        [childContentView removeFromSuperview];
    }
    childContentView = aView;
    [childContentView setFrame:[self contentRectForFrameRect:bounds]];
    [childContentView
     setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [frameView addSubview:childContentView];
}
*/
#define WINDOW_FRAME_PADDING 22
- (NSRect)contentRectForFrameRect:(NSRect)windowFrame
{
    windowFrame.origin = NSZeroPoint;
    windowFrame.size.height -= WINDOW_FRAME_PADDING;
    
    return windowFrame;
}

+ (NSRect)frameRectForContentRect:(NSRect)windowContentRect
                        styleMask:(NSUInteger)windowStyle
{
    //return NSInsetRect(windowContentRect, -WINDOW_FRAME_PADDING, -WINDOW_FRAME_PADDING);
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

@end
