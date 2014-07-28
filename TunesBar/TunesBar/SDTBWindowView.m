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
        /*
        _transportViewController = [[SDTBTransportViewController alloc] init];
        
        [self addSubview:_transportViewController.view];
        _transportViewController.view.frame = NSMakeRect((frame.size.width - kHeaderWidth) / 2, frame.size.height - 22, kHeaderWidth, 22);
         */
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds;
    NSRect headerRect;
    NSRect bodyRect;
    
    [[NSColor clearColor] setFill];
    NSRectFill(dirtyRect);
    
    // rgb(142, 68, 173)
    //[[NSColor colorWithCalibratedRed:230/255. green:126/255. blue:34/255. alpha:1.0] setFill];
    if (self.backgroundColour) {
        [self.backgroundColour setFill];
    } else {
        [[NSColor colorWithCalibratedRed:40/255. green:39/255. blue:38/255. alpha:1.0] setFill];
    }
    
    bounds = self.bounds;
    bodyRect = bounds;
    bodyRect.size.height -= 21.0;
    
    NSRectFill(bodyRect);

    CGFloat leftSideX = (NSWidth(bounds) - self.widthOfHeader) / 2;
    //CGFloat rightSideX = NSWidth(bounds) - leftSideX;

    headerRect = NSMakeRect(leftSideX, bounds.size.height - 21, self.widthOfHeader, 21);
    
    NSRectFill(headerRect);
}
/*
- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
 
    CGFloat leftSideX = (NSWidth(bounds) - self.widthOfHeader) / 2;
    CGFloat rightSideX = NSWidth(bounds) - leftSideX;
    
    [super drawRect:dirtyRect];
    
    [[NSColor clearColor] setFill];
    NSRectFill(bounds);

    //rgb(230, 126, 34)
    [[NSColor colorWithCalibratedRed:230/255. green:126/255. blue:34/255. alpha:1.0] setFill];
//    [[NSColor colorWithCalibratedRed:41/255. green:40/255. blue:39/255. alpha:1.0] setFill];
    NSBezierPath *path = [[NSBezierPath alloc] init];

    CGFloat radius = 5.0;
    
    radius = MIN(radius, 0.5f * MIN(NSWidth(bounds), NSHeight(bounds)));
    
    NSRect rect = NSInsetRect(bounds, radius, radius);
    
    CGFloat thickness = 22.0;
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect))
                                     radius:radius
                                 startAngle:180.0
                                   endAngle:270.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect))
                                     radius:radius
                                 startAngle:270.0
                                   endAngle:360.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect) - thickness)
                                     radius:radius
                                 startAngle:0.0
                                   endAngle:90.0];
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(rightSideX + radius,
                                                        NSMaxY(rect) - (thickness - (radius * 2)))
                                     radius:radius
                                 startAngle:270.0
                                   endAngle:180.0
                                  clockwise:YES];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(rightSideX - radius, NSMaxY(rect))
                                     radius:radius
                                 startAngle:0.0
                                   endAngle:90.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(leftSideX + radius, NSMaxY(rect))
                                     radius:radius
                                 startAngle:90.0
                                   endAngle:180.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(leftSideX - radius, NSMaxY(rect) - (thickness - (radius * 2)))
                                     radius:radius
                                 startAngle:360.0
                                   endAngle:270.0
                                  clockwise:YES];

    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect) - thickness)
                                     radius:radius
                                 startAngle:90.0
                                   endAngle:180.0];
    [path closePath];
    
    [path fill];
    
    path = [NSBezierPath bezierPath];
    [path setLineWidth:0.5];
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(rightSideX + radius + 0.5,
                                                        NSMaxY(rect) + 0.5 - (thickness - (radius * 2)))
                                     radius:radius
                                 startAngle:270.0
                                   endAngle:180.0
                                  clockwise:YES];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(rightSideX - radius + 0.5, NSMaxY(rect))
                                     radius:radius
                                 startAngle:0.0
                                   endAngle:90.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(leftSideX + radius + 0.5, NSMaxY(rect))
                                     radius:radius
                                 startAngle:90.0
                                   endAngle:180.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(leftSideX - radius + 0.5, NSMaxY(rect) - (thickness - (radius * 2)) + 0.5)
                                     radius:radius
                                 startAngle:360.0
                                   endAngle:270.0
                                  clockwise:YES];
    
    [[NSColor blackColor] setStroke];
    [path stroke];
}
*/

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
@end
