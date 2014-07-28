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

#import "SLColorArt.h"
#import <ServiceManagement/ServiceManagement.h>

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

- (void)awakeFromNib
{
    /*
    [_playButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaPlay]]];
    [_playButton setAttributedAlternateTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaPause]]];
    
    [_previousButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaBackward]]];
    
    [_nextButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaForward]]];
    */
    [_advancedButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaCog]]];
    
    [self updateHUDWithColors:self.colors];
}

- (void)updateHUDWithColors:(SLColorArt *)colorArt
{
    iTunesProxy *iProxy = [iTunesProxy proxy];
    
    if ([iProxy isPlaying]) {
        [_playButton setState:1];
    } else {
        [_playButton setState:0];
    }
    
    NSImage *coverArtwork = [iProxy coverArtwork];
    [_imageView setImage:coverArtwork];
    
    [self updateTextField:_titleField withString:[iProxy trackName]];
    [self updateTextField:_artistField withString:[iProxy trackArtist]];
    [self updateTextField:_albumField withString:[iProxy trackAlbum]];
    
    if (colorArt) {
        _titleField.textColor = colorArt.primaryColor;
        _artistField.textColor = colorArt.secondaryColor;
        _albumField.textColor = colorArt.secondaryColor;
        
        _playButton.image = [NSImage templateImage:@"play20x20" withColor:colorArt.detailColor andSize:CGSizeZero];
        _playButton.alternateImage = [NSImage templateImage:@"pause20x20" withColor:colorArt.detailColor andSize:CGSizeZero];
        _previousButton.image = [NSImage templateImage:@"rewind20x20" withColor:colorArt.detailColor andSize:CGSizeZero];
        _nextButton.image = [NSImage templateImage:@"forward20x20" withColor:colorArt.detailColor andSize:CGSizeZero];
    }
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

/*
- (void)toggleOpenAtLogin:(id)sender
{
	NSInteger changingToState = ![sender state];
    if (!SMLoginItemSetEnabled(CFSTR("com.sleepfive.TunesBarPlusHelper"), changingToState)) {
        NSRunAlertPanel(@"Could not change Open at Login status",
                        @"For some reason, this failed. Most likely it's because the app isn't in the Applications folder.",
                        @"OK",
                        nil,
                        nil);
    }
}

- (BOOL)opensAtLogin
{
    CFArrayRef jobDictsCF = SMCopyAllJobDictionaries( kSMDomainUserLaunchd );
    NSArray* jobDicts = (__bridge_transfer NSArray*)jobDictsCF;
    // Note: Sandbox issue when using SMJobCopyDictionary()
    
    if ((jobDicts != nil) && [jobDicts count] > 0) {
        BOOL bOnDemand = NO;
        
        for (NSDictionary* job in jobDicts) {
            if ([[job objectForKey:@"Label"] isEqualToString: @"com.sleepfive.TunesBarPlusHelper"]) {
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
        
        return bOnDemand;
    }
    
    return NO;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem action] == @selector(toggleOpenAtLogin:)) {
        
        [menuItem setState:[self opensAtLogin] ? NSOnState : NSOffState];
        return YES;
    }
    
    return YES;
}
*/

@end
