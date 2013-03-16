//
//  SDEditTitleController.h
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DLTitleFieldEditor;

@interface DLEditTitleController : NSWindowController

@property (copy) NSString *forthcomingTitle;

- (IBAction) accept:(id)sender;
- (IBAction) cancel:(id)sender;

- (void) setTitle:(NSString*)title;
- (void) setTitleFieldWidth:(float)width;

@end
