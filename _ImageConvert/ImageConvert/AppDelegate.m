//
//  AppDelegate.m
//  ImageConvert
//
//  Created by Steven Degutis on 3/1/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString* file = @"/Users/sdegutis/projects/AppGrid/appgrid.png";
    NSImage* image = [[NSImage alloc] initWithContentsOfFile:file];
    
    NSArray* sizes = @[@16, @32, @128, @256, @512];
    
    for (NSNumber* size in sizes) {
        NSInteger realSize = [size integerValue];
        
        NSString* newFilename1 = [NSString stringWithFormat:@"/Users/sdegutis/Desktop/iconset/icon_%ldx%ld.png", realSize, realSize];
        NSString* newFilename2 = [NSString stringWithFormat:@"/Users/sdegutis/Desktop/iconset/icon_%ldx%ld@2x.png", realSize, realSize];
        
        NSImage* image1 = [self resizeImage:image to:realSize];
        NSImage* image2 = [self resizeImage:image to:realSize * 2];
        
        [self saveImage:image1 withName:newFilename1];
        [self saveImage:image2 withName:newFilename2];
    }
}

- (NSImage*) resizeImage:(NSImage*)oldImage to:(NSInteger)size {
    NSImage* newImage = [[NSImage alloc] initWithSize:NSMakeSize(size, size)];
    
    NSSize sourceSize = [oldImage size];
    NSRect sourceRect = NSMakeRect(0, 0, sourceSize.width, sourceSize.height);
    NSRect targetRect = NSMakeRect(0, 0, size, size);
    [newImage lockFocus];
    [oldImage drawInRect:targetRect fromRect:sourceRect  operation: NSCompositeSourceOver fraction: 1.0];
    [newImage unlockFocus];
    
    return newImage;
}

- (void) saveImage:(NSImage*)image withName:(NSString*) fileName {
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
    [imageData writeToFile:fileName atomically:NO];
}

@end
