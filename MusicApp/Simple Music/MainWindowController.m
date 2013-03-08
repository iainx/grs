//
//  MainWindowController.m
//  Simple Music
//
//  Created by Steven Degutis on 2/2/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MainWindowController.h"

#import "MusicImporter.h"

#import "TrackHelper.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (NSString*) windowNibName {
    return @"MainWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
//    [self setShouldCascadeWindows:NO];
    
//    self.tableView.floatsGroupRows = YES;
    
    [self.window registerForDraggedTypes:@[NSFilenamesPboardType]];
    
    self.musicManager = [[MusicManager alloc] init];
    [self.musicManager loadFromDisk];
    
//    self.plistTableView.floatsGroupRows = YES;
    
    [self.tableView setDoubleAction:@selector(doubleClicked:)];
    [self.tableView reloadData];
}

- (void) doubleClicked:(id)sender {
    NSInteger idx = [self.tableView clickedRow];
    
    AVURLAsset* thing = [[self.musicManager mainPlaylist] objectAtIndex:idx];
    
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:thing];
    
//    [AVQueuePlayer queuePlayerWithItems:<#(NSArray *)#>]
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [self.player play];
    
//    CALayer *superlayer = [[self.window contentView] layer];
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    [superlayer addSublayer:playerLayer];
}

- (IBAction) previousTrack:(id)sender {
}

- (IBAction) nextTrack:(id)sender {
    
}

- (IBAction) playPause:(id)sender {
    if ([self.player rate] > 0.5) {
        [self.player pause];
    }
    else {
        [self.player play];
    }
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
    return NSDragOperationLink;
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender {
    return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
//    NSLog(@"starting import");
    
    NSArray* paths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    [self.progressBar startAnimation:self];
    
    [[[MusicImporter alloc] init] tryImportingPath:paths
                                 completionHandler:^(NSArray*urls) {
                                     [self.progressBar stopAnimation:self];
                                     
//                                     NSLog(@"%@", urls);
                                     [self.musicManager importURLs:urls];
                                     
                                     [self.tableView reloadData];
                                 }];
    
    return YES;
}

//- (BOOL) tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
//    return row == 4;
//}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self.musicManager mainPlaylist] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    AVURLAsset* asset = [[self.musicManager mainPlaylist] objectAtIndex:row];
    
    if ([[tableColumn identifier] isEqualToString: @"Title"])
        return [TrackHelper titleFor:asset];
    else if ([[tableColumn identifier] isEqualToString: @"Artist"])
        return [TrackHelper artistFor:asset];
    else if ([[tableColumn identifier] isEqualToString: @"Album"])
        return [TrackHelper albumFor:asset];
    else
        return @"Unknown Property";
}

@end
