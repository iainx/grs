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

#import "FVColorArt.h"
#import <ServiceManagement/ServiceManagement.h>

static void *hudContext = &hudContext;

@interface SDTBHUDViewController ()

@end

@implementation SDTBHUDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)init
{
    return [super initWithNibName:@"SDTBHUDViewController" bundle:nil];
}

- (void)awakeFromNib
{
    [_titleField bind:@"stringValue" toObject:[iTunesProxy proxy] withKeyPath:@"trackName" options:nil];
    [_albumField bind:@"stringValue" toObject:[iTunesProxy proxy] withKeyPath:@"trackAlbum" options:nil];
    [_artistField bind:@"stringValue" toObject:[iTunesProxy proxy] withKeyPath:@"trackArtist" options:nil];
    [_imageView bind:@"image" toObject:[iTunesProxy proxy] withKeyPath:@"coverArtwork" options:nil];
    [_playButton bind:@"value"
             toObject:[iTunesProxy proxy]
          withKeyPath:@"isPlaying"
              options:@{NSValueTransformerNameBindingOption : NSNegateBooleanTransformerName}];

    [_advancedButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaCog]]];
    
    [self updatePrimaryColor];
    [self updateSecondaryColor];
    [self updateDetailColor];
}

- (void)updatePrimaryColor
{
    NSColor *primaryColor = self.colors.primaryColor ?: [NSColor colorWithCalibratedWhite:1.0 alpha:0.8];
    self.titleField.textColor = primaryColor;
}

- (void)updateSecondaryColor
{
    NSColor *secondaryColor = self.colors.secondaryColor ?: [NSColor colorWithCalibratedWhite:1.0 alpha:0.8];
    self.artistField.textColor = secondaryColor;
    self.albumField.textColor = secondaryColor;
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
}

- (void)setColors:(FVColorArt *)colors
{
    if (colors == _colors) {
        return;
    }
    
    _colors = colors;
    
    [_colors addObserver:self forKeyPath:@"primaryColor"
                 options:NSKeyValueObservingOptionNew context:hudContext];
    [_colors addObserver:self forKeyPath:@"secondaryColor"
                 options:NSKeyValueObservingOptionNew context:hudContext];
    [_colors addObserver:self forKeyPath:@"detailColor"
                 options:NSKeyValueObservingOptionNew context:hudContext];
    
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

@end
