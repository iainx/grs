//
//  SDMoveAroundView.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/14/13.
//
//

#import <Cocoa/Cocoa.h>

@interface SDMoveAroundView : NSView

- (void) takeNoticeOfIcons;
- (void) takeNoticeOfLabels:(NSArray*)labels;

@end
