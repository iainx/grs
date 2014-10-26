//
//  SDTBVolumeSliderCell.m
//  TunesBar+
//
//  Created by iain on 26/10/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "SDTBVolumeSliderCell.h"
#import "SDTBVolumeSlider.h"

@implementation SDTBVolumeSliderCell

- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped
{
    CGFloat value = ([self doubleValue]  - [self minValue])/ ([self maxValue] - [self minValue]);
    
    NSRect bounds = self.controlView.bounds;
    SDTBVolumeSlider *slider = (SDTBVolumeSlider *)self.controlView;
    
    NSRect leftRect = NSMakeRect(bounds.origin.x + 2, (bounds.size.height / 2) - 2.5, (bounds.size.width - 5) * value, 5.0);
    NSRect rightRect = NSMakeRect(NSMaxX(leftRect), leftRect.origin.y, (bounds.size.width - 5) - leftRect.size.width, 5.0);
    
    NSBezierPath *leftPath = [NSBezierPath bezierPathWithRoundedRect:leftRect
                                                             xRadius:2.0
                                                             yRadius:2.0];
    [slider.activeColor setFill];
    [leftPath fill];
    
    NSBezierPath *rightPath = [NSBezierPath bezierPathWithRoundedRect:rightRect
                                                              xRadius:2.0
                                                              yRadius:2.0];
    [slider.inactiveColor setFill];
    [rightPath fill];
}

@end
