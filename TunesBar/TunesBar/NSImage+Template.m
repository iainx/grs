//
//  NSImage+Template.m
//  TunesBar+
//
//  Created by iain on 28/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "NSImage+Template.h"

@implementation NSImage (Template)

+ (NSImage *)templateImage:(NSString *)templateName
                 withColor:(NSColor *)tint
                   andSize:(CGSize)targetSize
{
    NSImage *template = [NSImage imageNamed:templateName];
    NSSize size = (CGSizeEqualToSize(targetSize, CGSizeZero)
                   ? [template size]
                   : targetSize);
    NSRect imageBounds = NSMakeRect(0, 0, size.width, size.height);
    
    NSImage *copiedImage = [template copy];
    [copiedImage setTemplate:NO];
    [copiedImage setSize:size];
    
    [copiedImage lockFocus];
    
    [tint set];
    NSRectFillUsingOperation(imageBounds, NSCompositeSourceAtop);
    
    [copiedImage unlockFocus];
    
    return copiedImage;
}

@end
