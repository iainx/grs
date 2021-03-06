//
//  MUPlayerWindowController.m
//  Songs
//
//  Created by Steven Degutis on 3/25/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDPlayerWindowController.h"

#import "SDUserDataManager.h"
#import "SDUserPlaylist.h"
#import "SDPlaylistCollection.h"

#import "SDMusicPlayer.h"

#import "SDPlaylistNode.h"

#import "MAKVONotificationCenter.h"

#import "SDTrackPositionView.h"

@interface SDPlayerWindowController ()

@property (weak) IBOutlet NSTreeController* treeGuy;
@property (weak) IBOutlet NSOutlineView* sourceList;
@property (weak) IBOutlet NSArrayController* songsArrayController;

@property (weak) IBOutlet SDTrackPositionView* songPositionSlider;

@end

@implementation SDPlayerWindowController

- (NSString*) windowNibName {
    return @"PlayerWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.songPositionSlider bind:@"currentValue"
                         toObject:[SDMusicPlayer sharedMusicPlayer]
                      withKeyPath:@"currentSong.time"
                          options:@{ NSValueTransformerNameBindingOption: @"SDTimeAsSeconds" }];
    
    [self.songPositionSlider bind:@"maxValue"
                         toObject:[SDMusicPlayer sharedMusicPlayer]
                      withKeyPath:@"currentSong.duration"
                          options:@{ NSValueTransformerNameBindingOption: @"SDTimeAsSeconds" }];
    
//    [[MAKVONotificationCenter defaultCenter] observeTarget:[SDMusicPlayer sharedMusicPlayer]
//                                                   keyPath:@"currentTime"
//                                                   options:NSKeyValueObservingOptionNew
//                                                     block:^(MAKVONotification *notification) {
//                                                         CMTime time = [notification.newValue CMTimeValue];
//                                                         self.songPositionSlider.floatValue = CMTimeGetSeconds(time);
//                                                     }];
//    
//    [[MAKVONotificationCenter defaultCenter] observeTarget:[SDMusicPlayer sharedMusicPlayer]
//                                                   keyPath:@"player.currentItem.duration"
//                                                   options:NSKeyValueObservingOptionNew
//                                                     block:^(MAKVONotification *notification) {
//                                                         CMTime time = [notification.newValue CMTimeValue];
//                                                         self.songPositionSlider.maxValue = CMTimeGetSeconds(time);
//                                                     }];
    
    [self.sourceList expandItem:nil expandChildren:YES];
    [self.sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (void) windowWillClose:(NSNotification *)notification {
    [self.songPositionSlider unbind:@"currentValue"];
    [self.songPositionSlider unbind:@"maxValue"];
    
    [self.killedDelegate playerWindowKilled:self];
}

- (SDUserDataManager*) musicManager {
    return [SDUserDataManager sharedMusicManager];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id<SDPlaylistNode>)item {
    return ![item isLeaf];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id<SDPlaylistNode>)item {
    return [item isLeaf];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id<SDPlaylistNode>)item {
    NSString* ident = ([item isLeaf] ? @"DataCell" : @"HeaderCell");
    NSTableCellView* view = [outlineView makeViewWithIdentifier:ident owner:self];
    return view;
}

- (IBAction) makeNewPlaylist:(id)sender {
    SDUserPlaylist* newlist = [[SDUserPlaylist alloc] init];
    
    NSUInteger idxs[2];
    idxs[0] = 1;
    idxs[1] = [[[SDUserDataManager sharedMusicManager] userPlaylists] count];
    [self.treeGuy insertObject:newlist atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndexes:idxs length:2]];
    [self.sourceList editColumn:0 row:[self.sourceList selectedRow] withEvent:nil select:YES];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(cancelOperation:)) {
        [control setStringValue:[[self selectedPlaylist] title]];
    }
    
    return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
    return MAX(proposedMin, 150.0);
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex {
    return MIN(proposedMax, [splitView frame].size.width - 150.0);
}

- (void)splitView:(NSSplitView*)sender resizeSubviewsWithOldSize:(NSSize)oldSize {
    CGFloat w = [[[sender subviews] objectAtIndex:0] frame].size.width;
    [sender adjustSubviews];
    [sender setPosition:w ofDividerAtIndex:0];
}

- (id<SDPlaylist>) selectedPlaylist {
    return [[self.treeGuy selectedObjects] lastObject];
}

- (SDSong*) selectedSong {
    return [[self.songsArrayController selectedObjects] lastObject];
}

- (IBAction) nextSong:(id)sender {
    [[SDMusicPlayer sharedMusicPlayer] nextSong];
}

- (IBAction) prevSong:(id)sender {
    [[SDMusicPlayer sharedMusicPlayer] prevSong];
}

- (IBAction) playPause:(id)sender {
    if ([SDMusicPlayer sharedMusicPlayer].status == SDMusicPlayerStatusPlaying) {
        [[SDMusicPlayer sharedMusicPlayer] pause];
    }
    else {
        [[SDMusicPlayer sharedMusicPlayer] playSong:[self selectedSong]
                                         inPlaylist:[self selectedPlaylist]];
    }
}

- (void) trackPositionMovedTo:(CGFloat)newValue {
    [[SDMusicPlayer sharedMusicPlayer] seekToTime:newValue];
}

- (SDMusicPlayer*) musicPlayer {
    return [SDMusicPlayer sharedMusicPlayer];
}

@end
