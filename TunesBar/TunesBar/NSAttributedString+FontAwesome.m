//
//  NSAttributedString+FontAwesome.m
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "NSAttributedString+FontAwesome.h"

@implementation NSAttributedString (FontAwesome)

+ (NSAttributedString *)attributedFontAwesome:(NSString *)text
{
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:titleRange];
    [colorTitle addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"FontAwesome" size:12.0] range:titleRange];
    return  colorTitle;
}

@end
