//
//  SDTBPlaylistItemView.m
//  TunesBar+
//
//  Created by iain on 05/08/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "SDTBPlaylistItemView.h"

@implementation SDTBPlaylistItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _trackNumberLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 23, 13)];
    _trackNumberLabel.drawsBackground = NO;
    _trackNumberLabel.bezeled = NO;
    _trackNumberLabel.font = [NSFont systemFontOfSize:11.0];
    _trackNumberLabel.editable = NO;
    _trackNumberLabel.alignment = NSRightTextAlignment;
    [self addSubview:_trackNumberLabel];
    
    _titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(25, 0, 150, 13)];
    _titleLabel.drawsBackground = NO;
    _titleLabel.bezeled = NO;
    _titleLabel.font = [NSFont systemFontOfSize:11.0];
    _titleLabel.editable = NO;
    [_titleLabel.cell setLineBreakMode:NSLineBreakByTruncatingTail];

    [self addSubview:_titleLabel];
    
    return self;
}

@end
