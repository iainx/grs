//
//  iTunesController.m
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "iTunesProxy.h"


@interface iTunesProxy (Private)

- (void) _updatePropertiesUsingDictionary:(NSDictionary*)dictionary;
- (void) _updatePropertiesFromScriptingBridge;

@end


@implementation iTunesProxy

static iTunesProxy* iTunesPrivateSharedController = nil;

@synthesize iTunes;
@synthesize delegate;

@synthesize trackName;
@synthesize trackArtist;
@synthesize trackAlbum;
@synthesize trackGenre;
@synthesize trackTotalTime;

@dynamic isPlaying;

+ (iTunesProxy*) proxy {
	if (iTunesPrivateSharedController == nil)
		iTunesPrivateSharedController = [[iTunesProxy alloc] init];
	
	return iTunesPrivateSharedController;
}

- (id) init {
	if (self = [super init]) {
		iTunes = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
		[iTunes setDelegate:(id)self];
		
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self
															selector:@selector(_iTunesUpdated:)
																name:@"com.apple.iTunes.playerInfo"
															  object:@"com.apple.iTunes.player"];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillTerminate:)
													 name:NSApplicationWillTerminateNotification
												   object:NSApp];
		
		[self _updatePropertiesUsingDictionary:nil];
		[delegate iTunesUpdated];
	}
	return self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void) _iTunesUpdated:(NSNotification*)notification {
	shouldUseCache = YES;
	
	[self _updatePropertiesUsingDictionary:[notification userInfo]];
	[delegate iTunesUpdated];
	
	shouldUseCache = NO;
}

- (void) _updatePropertiesUsingDictionary:(NSDictionary*)dictionary {
	if (dictionary) {
		// this should be called at every update except right after launch
		
		cachedIsRunning = ([dictionary isEqualToDictionary:[NSDictionary dictionaryWithObject:@"Stopped" forKey:@"Player State"]] == NO);
		cachedIsPlaying = ([[dictionary objectForKey:@"Player State"] isEqualToString:@"Playing"] == YES);
	}
	
	[self _updatePropertiesFromScriptingBridge];
}

- (void) _updatePropertiesFromScriptingBridge {
	if ([self isRunning] == NO) {
		[trackName release], trackName = nil;
		[trackArtist release], trackArtist = nil;
		[trackAlbum release], trackAlbum = nil;
		[trackGenre release], trackGenre = nil;
		[trackTotalTime release], trackTotalTime = nil;
	}
	else {
		iTunesTrack *track = nil;
		
		@try {
			track = [[iTunes currentTrack] get];
		}
		@catch (NSException * e) {
			track = nil;
		}
		@finally {
			[trackName release];
			[trackArtist release];
			[trackAlbum release];
			[trackGenre release];
			
			if (track) {
				trackName = [[track name] copy];
				trackArtist = [[track artist] copy];
				trackAlbum = [[track album] copy];
				trackGenre = [[track genre] copy];
			}
			else {
				trackName = [@"Unknown Track Name" copy];
				trackArtist = [@"Unknown Artist" copy];
				trackAlbum = [@"Unknown Album" copy];
				trackGenre = [@"Unknown Genre" copy];
			}
			
			int duration = (int)[track duration];
			int min = (duration / 60);
			int sec = (duration % 60);
			
			[trackTotalTime release];
			trackTotalTime = [NSSTRINGF(@"%02d:%02d", min, sec) copy];
		}
	}
}

- (BOOL) isRunning {
	if (shouldUseCache)
		return cachedIsRunning;
	else
		return [iTunes isRunning];
}

- (BOOL) isPlaying {
	if (shouldUseCache)
		return cachedIsPlaying;
	else {
		if ([self isRunning] == NO)
			return NO;
		
		iTunesEPlS state = [iTunes playerState];
		return (state != iTunesEPlSStopped && state != iTunesEPlSPaused);
	}
}

@end
