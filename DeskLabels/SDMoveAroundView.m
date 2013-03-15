//
//  SDMoveAroundView.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/14/13.
//
//

#import "SDMoveAroundView.h"

@implementation SDMoveAroundView

//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect box = [self bounds];
    
    [[[NSColor whiteColor] colorWithAlphaComponent:0.1] setFill];
    [NSBezierPath fillRect:box];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.4] setFill];
    [NSBezierPath strokeRect:box];
}

@end
