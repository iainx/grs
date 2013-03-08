//
//  MusicManager.m
//  Simple Music
//
//  Created by Steven Degutis on 2/2/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MusicManager.h"

#import <AVFoundation/AVFoundation.h>
#import "NSFileManager+DirectoryLocations.h"

@interface MusicManager ()

@property NSArray* allTracks;

@end

@implementation MusicManager

- (NSString*) musicDataPath {
    return [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"playlist.data"];
}

- (void) loadFromDisk {
    NSArray *urls = [NSKeyedUnarchiver unarchiveObjectWithFile:[self musicDataPath]];
    [self makeUseOfURLs:urls];
}

- (void) importURLs:(NSArray*)urls {
//    NSMutableArray* filtered = [urls mutableCopy];
//    [filtered removeObjectsInArray:self.allTracks];
//    
//    NSLog(@"%@", filtered);
    
    [self makeUseOfURLs:urls];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:urls];
    [data writeToFile:[self musicDataPath] atomically:YES];
}

- (void) makeUseOfURLs:(NSArray*)urls {
//    NSLog(@"%@", urls);
    
    NSMutableArray* newAssets = [NSMutableArray array];
    
    for (NSURL* url in urls) {
        [newAssets addObject:[AVURLAsset assetWithURL:url]];
    }
    
    self.allTracks = newAssets;
}

- (NSArray*) mainPlaylist {
    return self.allTracks;
}

@end
