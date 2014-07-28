//
//  iTunesController.m
//  TunesBar
//
//  Created by Steven Degutis on 7/28/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "iTunesProxy.h"


@interface iTunesProxy ()

@property BOOL shouldUseCache;

@property BOOL cachedIsRunning;
@property BOOL cachedIsPlaying;

@property iTunesApplication *iTunes;

@property (copy) NSString *trackName;
@property (copy) NSString *trackArtist;
@property (copy) NSString *trackAlbum;
@property (copy) NSString *trackGenre;
@property (copy) NSImage *coverArtwork;

@end


@implementation iTunesProxy

@dynamic isPlaying;

+ (iTunesProxy*) proxy {
    static iTunesProxy* iTunesPrivateSharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iTunesPrivateSharedController = [[iTunesProxy alloc] init];
    });
	return iTunesPrivateSharedController;
}

- (id) init {
	if (self = [super init]) {
		self.iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        
        if (self.iTunes == nil) {
            NSLog(@"No proxy");
        }
		[self.iTunes setDelegate:(id)self];
		
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self
															selector:@selector(_iTunesUpdated:)
																name:@"com.apple.iTunes.playerInfo"
															  object:@"com.apple.iTunes.player"];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillTerminate:)
													 name:NSApplicationWillTerminateNotification
												   object:NSApp];
	}
	return self;
}

- (void) loadInitialTunesBarInfo {
    [self _updatePropertiesUsingDictionary:nil];
    [self.delegate iTunesUpdated];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void) _iTunesUpdated:(NSNotification*)notification {
	self.shouldUseCache = YES;
	
	[self _updatePropertiesUsingDictionary:[notification userInfo]];
	[self.delegate iTunesUpdated];
	
 	self.shouldUseCache = NO;
}

- (void) _updatePropertiesUsingDictionary:(NSDictionary*)dictionary {
	if (dictionary) {
		// this should be called at every update except right after launch
		
		self.cachedIsRunning = ([dictionary isEqualToDictionary:[NSDictionary dictionaryWithObject:@"Stopped" forKey:@"Player State"]] == NO);
		self.cachedIsPlaying = ([[dictionary objectForKey:@"Player State"] isEqualToString:@"Playing"] == YES);
	}
	
	[self _updatePropertiesFromScriptingBridge];
}

- (void) _updatePropertiesFromScriptingBridge {
	if ([self isRunning] == NO) {
		self.trackName = nil;
		self.trackArtist = nil;
		self.trackAlbum = nil;
		self.trackGenre = nil;
        self.coverArtwork = nil;
	}
	else {
		iTunesTrack *track = nil;
		
		@try {
			track = [self.iTunes currentTrack];
            if ([track exists]) {
                track = [track get];
            } else {
                NSLog(@"Track doesn't exist");
                track = nil;
            }
		}
		@catch (NSException * e) {
			track = nil;
		}
		@finally {
			if (track) {
				self.trackName = [track name];
				self.trackArtist = [track artist];
				self.trackAlbum = [track album];
				self.trackGenre = [track genre];
                
                SBElementArray *artworks = [track artworks];
                iTunesArtwork *artwork = [artworks objectAtIndex:0];
                
                self.coverArtwork = [[NSImage alloc] initWithData:[artwork rawData]];
			} else {
				self.trackName = @"Unknown Track Name";
				self.trackArtist = @"Unknown Artist";
				self.trackAlbum = @"Unknown Album";
				self.trackGenre = @"Unknown Genre";
                self.coverArtwork = nil;
			}
        }
	}
}

- (BOOL) isRunning {
    return [self.iTunes isRunning];
}

- (BOOL) isPlaying {
	if (self.shouldUseCache)
		return self.cachedIsPlaying;
	else {
		if ([self isRunning] == NO)
			return NO;
		
		iTunesEPlS state = [self.iTunes playerState];
		return (state != iTunesEPlSStopped && state != iTunesEPlSPaused);
	}
}

- (id)eventDidFail:(const AppleEvent *)event withError:(NSError *)error
{
    NSLog(@"Event failed with error");
    NSLog(@"%@", error);
    NSLog(@"%@", [error userInfo]);
    return nil;
}
@end
