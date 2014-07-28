//
//  NSImage+Template.h
//  TunesBar+
//
//  Created by iain on 28/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Template)

+ (NSImage *)templateImage:(NSString *)templateName
                 withColor:(NSColor *)tint
                   andSize:(CGSize)targetSize;
@end
