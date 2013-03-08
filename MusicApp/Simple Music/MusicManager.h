//
//  MusicManager.h
//  Simple Music
//
//  Created by Steven Degutis on 2/2/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicManager : NSObject

- (void) loadFromDisk;

- (void) importURLs:(NSArray*)urls;

- (NSArray*) mainPlaylist;

@end
