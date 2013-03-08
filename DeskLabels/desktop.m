//
//  AppDelegate.m
//  TestDesktop
//
//  Created by Steven Degutis on 2/24/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "Finder.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    FinderApplication *finder = [[SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"] retain];
    FinderDesktopObject* desktop = [finder desktop];
    
    FinderItem* item = [[[desktop items] get] lastObject];
    
    item.desktopPosition = NSMakePoint(2502, 172);
//    
//    NSLog(@"%@", item);
    
//    iTunesTrack *track = track = [[iTunes currentTrack] get];
//    NSLog(@"%@", [[track name] copy]);
}

@end
