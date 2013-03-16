//
//  SDMoveAroundView.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/14/13.
//
//

#import <Cocoa/Cocoa.h>

@protocol DLMovableIconGroupViewDelegate <NSObject>

- (void) didStartMoving;
- (void) didStopMoving;
- (void) didMoveByOffset:(NSPoint)offset;

@end

@interface DLMovableIconGroupView : NSBox

@property (weak) IBOutlet id<DLMovableIconGroupViewDelegate> delegate;

@end
