//
//  NSColor+FVAdditions.m
//  TunesBar+
//
//  Created by iain on 04/08/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "NSColor+FVAdditions.h"

@implementation NSColor (FVAdditions)

- (CGColorRef)fv_CGColor
{
    NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    [self getComponents:(CGFloat *)&components];
    CGColorRef cgColor = CGColorCreate(colorSpace, components);
    
    return cgColor;
}

@end
