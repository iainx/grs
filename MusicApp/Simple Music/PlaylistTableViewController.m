//
//  PlaylistTableViewController.m
//  Simple Music
//
//  Created by Steven Degutis on 2/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "PlaylistTableViewController.h"

@interface PlaylistTableViewController ()

@end

@implementation PlaylistTableViewController

//- (BOOL) tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
//    return row == 2;
//}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 5;
//    return [[self.musicManager mainPlaylist] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return @"Foobar";
    
//    AVURLAsset* asset = [[self.musicManager mainPlaylist] objectAtIndex:row];
//    
//    if ([[tableColumn identifier] isEqualToString: @"Title"])
//        return [TrackHelper titleFor:asset];
//    else if ([[tableColumn identifier] isEqualToString: @"Artist"])
//        return [TrackHelper artistFor:asset];
//    else if ([[tableColumn identifier] isEqualToString: @"Album"])
//        return [TrackHelper albumFor:asset];
//    else
//        return @"Unknown Property";
}

@end
