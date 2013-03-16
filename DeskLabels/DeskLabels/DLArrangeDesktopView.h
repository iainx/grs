//
//  SDResizeJunkView.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/1/13.
//
//

#import <Cocoa/Cocoa.h>

@interface DLArrangeDesktopView : NSBox

@property (copy) void(^wantsBoxInRect)(NSRect box);

@end
