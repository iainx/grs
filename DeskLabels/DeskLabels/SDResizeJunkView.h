//
//  SDResizeJunkView.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/1/13.
//
//

#import <Cocoa/Cocoa.h>

@interface SDResizeJunkView : NSBox

@property (copy) void(^wantsBoxInRect)(NSRect box);

@end
