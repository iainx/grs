//
//  SDResizeJunkView.m
//  DeskLabels
//
//  Created by Steven Degutis on 3/1/13.
//
//

#import "SDResizeJunkView.h"

@implementation SDResizeJunkView

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self setBoxType:NSBoxCustom];
    [self setFillColor:[[NSColor blackColor] colorWithAlphaComponent:0.25]];
}

//- (void) drawRect:(NSRect)dirtyRect {
//    [[NSColor blackColor] setFill];
//    [NSBezierPath fillRect:dirtyRect];
//}

- (void) resetCursorRects {
    [self addCursorRect:[self visibleRect] cursor:[NSCursor crosshairCursor]];
}

@end
