//
//  DLNoteWindowController.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DLNoteWindowController : NSWindowController <NSWindowDelegate>

@property NSDictionary *dictionaryToLoadFrom;

@property (copy) void(^noteKilled)(DLNoteWindowController* controller);

- (NSDictionary*) dictionaryRepresentation;

@end
