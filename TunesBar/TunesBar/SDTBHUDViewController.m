//
//  SDTBHUDViewController.m
//  TunesBar+
//
//  Created by iain on 25/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "SDTBHUDViewController.h"
#import "SDTBMenuViewController.h"
#import "iTunesProxy.h"

#import <NSString+FontAwesome.h>
#import "NSAttributedString+FontAwesome.h"
#import "NSImage+Template.h"
#import "NSColor+FVAdditions.h"

#import "SDTBPlaylistItemView.h"

#import "CNGridView.h"
#import "CNGridViewItemLayout.h"
#import "FVColorArt.h"

#import <ServiceManagement/ServiceManagement.h>

static void *hudContext = &hudContext;

@interface SDTBHUDViewController () <CNGridViewDataSource, CNGridViewDelegate>

@end

@implementation SDTBHUDViewController {
    CNGridViewItemLayout *_defaultLayout;
    CNGridViewItemLayout *_selectedLayout;
}

- (id)init
{
    self = [super initWithNibName:@"SDTBHUDViewController" bundle:nil];
    if (!self) {
        return nil;
    }
    
    _defaultLayout = [CNGridViewItemLayout defaultLayout];
    _defaultLayout.itemBorderRadius = 0;
    _defaultLayout.contentInset = 0;
    _defaultLayout.backgroundColor = [NSColor clearColor];
    _defaultLayout.visibleContentMask = CNGridViewItemVisibleContentNothing;
    _defaultLayout.selectionRingLineWidth = 0.0;
    _defaultLayout.selectionRingColor = [NSColor clearColor];
    
    _selectedLayout = [CNGridViewItemLayout defaultLayout];
    _selectedLayout.itemBorderRadius = 0;
    _selectedLayout.contentInset = 0;
    _selectedLayout.backgroundColor = [NSColor clearColor];
    _selectedLayout.visibleContentMask = CNGridViewItemVisibleContentNothing;
    _selectedLayout.selectionRingLineWidth = 0.0;
    _selectedLayout.selectionRingColor = [NSColor clearColor];

    return self;
}

- (void)awakeFromNib
{
    [_imageView bind:@"image" toObject:[iTunesProxy proxy] withKeyPath:@"coverArtwork" options:nil];
    [_playButton bind:@"value"
             toObject:[iTunesProxy proxy]
          withKeyPath:@"isPlaying"
              options:@{NSValueTransformerNameBindingOption : NSNegateBooleanTransformerName}];

    [_advancedButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaCog]]];
    
    self.detailsView.wantsLayer = YES;

    [self updateBackgroundColor];
    [self updatePrimaryColor];
    [self updateSecondaryColor];
    [self updateDetailColor];
    [self updateDetails];
    
    self.albumView.itemSize = NSMakeSize(174.0, 13.0);
	self.albumView.backgroundColor = [NSColor clearColor];
	self.albumView.scrollElasticity = YES;

	[self.albumView reloadData];
}

- (void)updateBackgroundColor
{
    NSColor *backgroundColor = [self.colors.backgroundColor colorWithAlphaComponent:0.4];
    
    CGColorRef cgColor = [backgroundColor fv_CGColor];
    self.detailsView.layer.backgroundColor = cgColor;
    CGColorRelease(cgColor);
}

- (void)updatePrimaryColor
{
    NSColor *primaryColor = self.colors.primaryColor ?: [NSColor colorWithCalibratedWhite:1.0 alpha:0.8];
    self.detailsField.textColor = primaryColor;
}

- (void)updateSecondaryColor
{
    NSColor *secondaryColor = self.colors.secondaryColor ?: [NSColor colorWithCalibratedWhite:1.0 alpha:0.8];
    
    _selectedLayout.backgroundColor = [secondaryColor colorWithAlphaComponent:0.25];
}

- (void)updateDetailColor
{
    NSColor *detailColor = self.colors.detailColor ?: [NSColor colorWithCalibratedWhite:1.0 alpha:0.8];
    
    _playButton.alternateImage = [NSImage templateImage:@"play20x20" withColor:detailColor andSize:CGSizeZero];
    _playButton.image = [NSImage templateImage:@"pause20x20" withColor:detailColor andSize:CGSizeZero];
    _previousButton.image = [NSImage templateImage:@"rewind20x20" withColor:detailColor andSize:CGSizeZero];
    _nextButton.image = [NSImage templateImage:@"forward20x20" withColor:detailColor andSize:CGSizeZero];
    
    [_advancedButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaCog] withColor:detailColor]];
}

- (void)updateDetails
{
    self.detailsField.stringValue = [NSString stringWithFormat:@"%@ - %@", [iTunesProxy proxy].trackArtist, [iTunesProxy proxy].trackAlbum];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context != hudContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
 
    if ([keyPath isEqualToString:@"primaryColor"]) {
        [self updatePrimaryColor];
        return;
    }
    
    if ([keyPath isEqualToString:@"secondaryColor"]) {
        [self updateSecondaryColor];
        return;
    }
    
    if ([keyPath isEqualToString:@"detailColor"]) {
        [self updateDetailColor];
        return;
    }
    
    if ([keyPath isEqualToString:@"backgroundColor"]) {
        [self updateBackgroundColor];
        return;
    }
    
    if ([keyPath isEqualToString:@"trackAlbum"] || [keyPath isEqualToString:@"trackArtist"]) {
        [self updateDetails];
        return;
    }
    
    if ([keyPath isEqualToString:@"albumTracks"]) {
        [self.albumView reloadData];
        return;
    }
}

- (void)setColors:(FVColorArt *)colors
{
    if (colors == _colors) {
        return;
    }
    
    _colors = colors;
    
    [_colors addObserver:self forKeyPath:@"backgroundColor"
                 options:NSKeyValueObservingOptionNew context:hudContext];
    [_colors addObserver:self forKeyPath:@"primaryColor"
                 options:NSKeyValueObservingOptionNew context:hudContext];
    [_colors addObserver:self forKeyPath:@"secondaryColor"
                 options:NSKeyValueObservingOptionNew context:hudContext];
    [_colors addObserver:self forKeyPath:@"detailColor"
                 options:NSKeyValueObservingOptionNew context:hudContext];
    
    [[iTunesProxy proxy] addObserver:self
                          forKeyPath:@"trackArtist"
                             options:NSKeyValueObservingOptionNew
                             context:hudContext];
    [[iTunesProxy proxy] addObserver:self
                          forKeyPath:@"trackAlbum"
                             options:NSKeyValueObservingOptionNew
                             context:hudContext];
    [[iTunesProxy proxy] addObserver:self
                          forKeyPath:@"albumTracks"
                             options:NSKeyValueObservingOptionNew
                             context:hudContext];
    
    [self updateBackgroundColor];
    [self updatePrimaryColor];
    [self updateSecondaryColor];
    [self updateDetailColor];
}

- (void)updateTextField:(NSTextField *)textField
             withString:(NSString *)string
{
    [textField setStringValue:string];
    [textField setToolTip:string];
}

- (IBAction)showAdvancedMenu:(id)sender
{
    SDTBMenuViewController *menuController = [[SDTBMenuViewController alloc] init];
    [menuController loadView];
    
    NSEvent *event = [NSApp currentEvent];
    [NSMenu popUpContextMenu:menuController.advancedMenu
                   withEvent:event
                     forView:sender];
}

- (IBAction) playPause:(id)sender {
	[[[iTunesProxy proxy] iTunes] playpause];
}

- (IBAction) nextTrack:(id)sender {
	[[[iTunesProxy proxy] iTunes] nextTrack];
}

- (IBAction) previousTrack:(id)sender {
	[[[iTunesProxy proxy] iTunes] previousTrack];
}

#pragma mark - CNGridViewDataSource methods

- (NSUInteger)numberOfSectionsInGridView:(CNGridView *)gridView
{
    return 1;
}

- (NSUInteger)gridView:(CNGridView *)gridView
numberOfItemsInSection:(NSInteger)section
{
    return [iTunesProxy proxy].albumTracks.count;
}

- (CNGridViewItem *)gridView:(CNGridView *)gridView
                 itemAtIndex:(NSInteger)index
                   inSection:(NSInteger)section {
	static NSString *reuseIdentifier = @"CNGridViewItem";
    
	SDTBPlaylistItemView *item = [gridView dequeueReusableItemWithIdentifier:reuseIdentifier];
	if (item == nil) {
		//item = [[CNGridViewItem alloc] initWithLayout:_defaultLayout reuseIdentifier:reuseIdentifier];
        item = [[SDTBPlaylistItemView alloc] init];
        item.defaultLayout = _defaultLayout;
        item.selectionLayout = _defaultLayout;
        item.hoverLayout = _selectedLayout;
        item.reuseIdentifier = reuseIdentifier;
	}
    
    iTunesTrack *track = [iTunesProxy proxy].albumTracks[index];
    
    item.titleLabel.stringValue = track.name;
    if (track.trackNumber != 0) {
        item.trackNumberLabel.integerValue = track.trackNumber;
    } else {
        item.trackNumberLabel.stringValue = @"";
    }
    item.titleLabel.textColor = self.colors.secondaryColor;
    item.trackNumberLabel.textColor = self.colors.detailColor;
    
	return item;
}

#pragma mark CNGridViewDelegate methods

- (void)gridView:(CNGridView *)gridView
didDoubleClickItemAtIndex:(NSUInteger)index
       inSection:(NSUInteger)section
{
    iTunesTrack *track = [iTunesProxy proxy].albumTracks[index];
    [track playOnce:NO];
}
@end
