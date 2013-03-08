//
//  MainWindowController.h
//  Simple Music
//
//  Created by Steven Degutis on 2/2/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MusicManager.h"
#import <AVFoundation/AVFoundation.h>

//#import "PlaylistTableViewController.h"

@interface MainWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView* tableView;
@property (weak) IBOutlet NSProgressIndicator* progressBar;

//@property PlaylistTableViewController *playlistTableViewController;

@property MusicManager* musicManager;
@property AVPlayer* player;

@property (weak) IBOutlet NSTableView* plistTableView;

@end
