//
//  NSImage+SDAttributedStringAdditions.h
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSImage (SDAttributedStringAdditions)

+ (NSImage*) imageFromString:(NSString*)title attributes:(NSDictionary*)attributes;

@end
