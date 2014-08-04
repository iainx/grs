//
//  CIImage+SoftwareBitmapRep.m
//  TunesBar+
//
//  Created by iain on 04/08/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "CIImage+SoftwareBitmapRep.h"

@implementation CIImage (SoftwareBitmapRep)

- (NSBitmapImageRep *)RGBABitmapImageRep
{
    int width = self.extent.size.width;
    int rows = self.extent.size.height;
    int rowBytes = (width * 4);
    
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
                                                                    pixelsWide:width
                                                                    pixelsHigh:rows
                                                                 bitsPerSample:8
                                                               samplesPerPixel:4
                                                                      hasAlpha:YES
                                                                      isPlanar:NO
                                                                colorSpaceName:NSCalibratedRGBColorSpace
                                                                  bitmapFormat:0
                                                                   bytesPerRow:rowBytes
                                                                  bitsPerPixel:0];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName (kCGColorSpaceGenericRGB);
    CGContextRef context = CGBitmapContextCreate([rep bitmapData], width, rows,
                                                 8, rowBytes, colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CIContext* ciContext = [CIContext contextWithCGContext:context options:@{kCIContextUseSoftwareRenderer: @YES}];
    [ciContext drawImage:self inRect:CGRectMake(0, 0, width, rows) fromRect:self.extent];
    ciContext = nil;
    
 	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
    
	return rep;
}

@end
