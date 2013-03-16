//
//  SDMoveAroundView.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/14/13.
//
//

#import <Cocoa/Cocoa.h>

@interface DLIconGroupView : NSView

- (void) takeNoticeOfIcons;
- (void) takeNoticeOfLabels:(NSArray*)labels;

@end
