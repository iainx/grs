//
//  SDTBStatusItemHelper.h
//  TunesBar
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDTBStatusItemHelper : NSObject

+ (void) setImagesWithTitle:(NSString*)title
                       font:(NSFont*)font
                  foreColor:(NSColor*)foreColor
               onStatusItem:(NSStatusItem*)statusItem;

+ (NSImage*) imageFromString:(NSString*)title attributes:(NSDictionary*)attributes;

@end
