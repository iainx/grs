//
//  SDTBWindowView.m
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SDTBWindowView.h"
#import "Constants.h"

@implementation SDTBWindowView {
    NSBezierPath *_path;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _widthOfHeader = kHeaderWidth;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, NSMaxY(frame));
    CGPathAddArcToPoint(path, NULL, 0, 0, 20, 0, 20);
    CGPathAddArcToPoint(path, NULL, NSMaxX(frame), 0, NSMaxX(frame), 20, 20);
    CGPathAddLineToPoint(path, NULL, NSMaxX(frame), NSMaxY(frame));
    CGPathCloseSubpath(path);
    
    self.wantsLayer = YES;
    
    CAShapeLayer *shapeMask = [CAShapeLayer layer];
    shapeMask.path = path;
    CGPathRelease(path);
    
    self.layer.mask = shapeMask;
    
    self.layer.masksToBounds = YES;
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds;
    NSRect bodyRect;
    
    [[NSColor clearColor] setFill];
    NSRectFill(dirtyRect);
    
    CGFloat alpha = 1.0;

    bounds = self.bounds;

    if (self.backgroundImage) {
        NSSize imageSize = self.backgroundImage.size;
        NSRect imageRect = NSMakeRect((imageSize.width - NSWidth(bounds)) / 2,
                                      (imageSize.height - NSHeight(bounds)) / 2,
                                      NSWidth(bounds), NSHeight(bounds));
        [self.backgroundImage drawInRect:bounds
                                fromRect:imageRect
                               operation:NSCompositeCopy
                                fraction:1.0];
        
        alpha = 0.2;
    }

    if (self.backgroundColour) {
        [[self.backgroundColour colorWithAlphaComponent:alpha] setFill];
    } else {
        [[NSColor colorWithCalibratedRed:40/255. green:39/255. blue:38/255. alpha:alpha] setFill];
    }
    
    bounds = self.bounds;
    bodyRect = bounds;
    
    NSRectFillUsingOperation(bodyRect, NSCompositeSourceOver);
}

- (void)setWidthOfHeader:(CGFloat)widthOfHeader
{
    if (_widthOfHeader == widthOfHeader) {
        return;
    }
    
    _widthOfHeader = widthOfHeader;
    
    [self setNeedsDisplay:YES];
}

- (void)setBackgroundColour:(NSColor *)backgroundColour
{
    if (_backgroundColour == backgroundColour) {
        return;
    }
    
    _backgroundColour = backgroundColour;
    [self setNeedsDisplay:YES];
}

- (void)setBackgroundImage:(NSImage *)backgroundImage
{
    if (_backgroundImage == backgroundImage) {
        return;
    }
    
    _backgroundImage = backgroundImage;
    [self setNeedsDisplay:YES];
}

@end
