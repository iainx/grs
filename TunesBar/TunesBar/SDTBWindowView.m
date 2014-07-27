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
    NSRect bounds = [self bounds];
 
    CGFloat leftSideX = (NSWidth(bounds) - self.widthOfHeader) / 2;
    CGFloat rightSideX = NSWidth(bounds) - leftSideX;
    
    [super drawRect:dirtyRect];
    
    [[NSColor clearColor] setFill];
    NSRectFill(bounds);
    
    [[NSColor colorWithCalibratedRed:41/255. green:40/255. blue:39/255. alpha:1.0] setFill];
    NSBezierPath *path = [[NSBezierPath alloc] init];

    CGFloat radius = 5.0;
    
    radius = MIN(radius, 0.5f * MIN(NSWidth(bounds), NSHeight(bounds)));
    
    NSRect rect = NSInsetRect(bounds, radius, radius);
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect))
                                     radius:radius
                                 startAngle:180.0
                                   endAngle:270.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect))
                                     radius:radius
                                 startAngle:270.0
                                   endAngle:360.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect) - 22)
                                     radius:radius
                                 startAngle:0.0
                                   endAngle:90.0];
    
    [path appendBezierPathWithArcWithCenter:NSMakePoint(rightSideX + radius, NSMaxY(rect) - (22 - (radius * 2)))
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
    [path appendBezierPathWithArcWithCenter:NSMakePoint(leftSideX - radius, NSMaxY(rect) - (22 - (radius * 2)))
                                     radius:radius
                                 startAngle:360.0
                                   endAngle:270.0
                                  clockwise:YES];

    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect) - 22)
                                     radius:radius
                                 startAngle:90.0
                                   endAngle:180.0];
    [path closePath];
    
    [path fill];
}

- (void)setWidthOfHeader:(CGFloat)widthOfHeader
{
    if (_widthOfHeader == widthOfHeader) {
        return;
    }
    
    _widthOfHeader = widthOfHeader;
    
    [self setNeedsDisplay:YES];
}
@end
