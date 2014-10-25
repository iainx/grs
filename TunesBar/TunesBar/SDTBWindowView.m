//
//  SDTBWindowView.m
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "SDTBWindowView.h"
#import "Constants.h"

@implementation SDTBWindowView {
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _widthOfHeader = kHeaderWidth;
    }
    
    self.wantsLayer = YES;
    self.layer.cornerRadius = 20.0;
    self.layer.masksToBounds = YES;
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds;
    NSRect headerRect;
    NSRect bodyRect;
    
    [[NSColor clearColor] setFill];
    NSRectFill(dirtyRect);
    
    CGFloat alpha = 1.0;
    if (self.backgroundImage) {
        bounds = self.bounds;
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        CGFloat sideWidth = (bounds.size.width - self.widthOfHeader) / 2;
        
        [path moveToPoint:NSMakePoint(0, 0)];

        [path lineToPoint:NSMakePoint(NSMaxX(bounds), 0)];
        [path lineToPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds) - 21)];
        [path lineToPoint:NSMakePoint(NSMaxX(bounds) - sideWidth, NSMaxY(bounds) - 21)];
        [path lineToPoint:NSMakePoint(NSMaxX(bounds) - sideWidth, NSMaxY(bounds))];
        [path lineToPoint:NSMakePoint(sideWidth, NSMaxY(bounds))];
        [path lineToPoint:NSMakePoint(sideWidth, NSMaxY(bounds) - 21)];
        [path lineToPoint:NSMakePoint(0, NSMaxY(bounds) - 21)];
        [path closePath];
        
        [path addClip];
        
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
    bodyRect.size.height -= 21.0;
    
    NSRectFillUsingOperation(bodyRect, NSCompositeSourceOver);

    CGFloat leftSideX = (NSWidth(bounds) - self.widthOfHeader) / 2;
    //CGFloat rightSideX = NSWidth(bounds) - leftSideX;

    headerRect = NSMakeRect(leftSideX, bounds.size.height - 21, self.widthOfHeader, 21);
    
    NSRectFillUsingOperation(headerRect, NSCompositeSourceOver);
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
