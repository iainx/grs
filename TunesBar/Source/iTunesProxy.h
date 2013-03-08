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


@interface iTunesProxy : NSObject {
	BOOL shouldUseCache;
	
	BOOL cachedIsRunning;
	BOOL cachedIsPlaying;
	
	iTunesApplication *iTunes;
	id <iTunesDelegate> delegate;
	
	NSString *trackName;
	NSString *trackArtist;
	NSString *trackAlbum;
	NSString *trackGenre;
	NSString *trackTotalTime;
}

@property (readonly) iTunesApplication *iTunes;
@property (assign) id <iTunesDelegate> delegate;

@property (readonly) BOOL isRunning;
@property (readonly) BOOL isPlaying;

@property (readonly) NSString* trackName;
@property (readonly) NSString* trackArtist;
@property (readonly) NSString* trackAlbum;
@property (readonly) NSString* trackGenre;
@property (readonly) NSString* trackTotalTime;

+ (iTunesProxy*) proxy;

@end
