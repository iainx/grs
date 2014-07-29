//
//  NSAttributedString+FontAwesome.m
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "NSAttributedString+FontAwesome.h"

@implementation NSAttributedString (FontAwesome)

+ (NSAttributedString *)attributedFontAwesome:(NSString *)text withColor:(NSColor *)colour
{
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    
    if (colour == nil) {
        colour = [NSColor grayColor];
    }
    [colorTitle addAttribute:NSForegroundColorAttributeName value:colour range:titleRange];
    [colorTitle addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"FontAwesome" size:12.0] range:titleRange];
    return  colorTitle;
}

+ (NSAttributedString *)attributedFontAwesome:(NSString *)text
{
    return [NSAttributedString attributedFontAwesome:text withColor:[NSColor whiteColor]];
}
@end
