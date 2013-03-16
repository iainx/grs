//
//  DLNotesManager.h
//  DeskLabels
//
//  Created by Steven Degutis on 3/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLNotesManager : NSObject

@property NSMutableArray* noteControllers;

- (void) loadNotes;

- (void) addNote;
- (void) removeAllNotes;

@end
