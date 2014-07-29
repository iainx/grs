//
//  iTunesController.h
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <ScriptingBridge/ScriptingBridge.h>
#import "iTunes.h"

@protocol iTunesDelegate

- (void) iTunesUpdated;

@end


@interface iTunesProxy : NSObject

@property (readonly) iTunesApplication *iTunes;
@property (weak) id <iTunesDelegate> delegate;

@property (readonly) BOOL isRunning;
@property (readonly) BOOL isPlaying;

@property (copy, readonly) NSString* trackName;
@property (copy, readonly) NSString* trackArtist;
@property (copy, readonly) NSString* trackAlbum;
@property (copy, readonly) NSString* trackGenre;
@property (copy, readonly) NSImage *coverArtwork;
@property (copy, readonly) NSString *artworkMD5;

+ (iTunesProxy*) proxy;

- (void) loadInitialTunesBarInfo;

@end
