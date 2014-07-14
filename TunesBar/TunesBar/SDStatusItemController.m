//
//  SDMainWindowController.m
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//  Modified by Iain Holmes
//  Copyright 2013 - 2014
//

#import "SDStatusItemController.h"

#import "DefaultsKeys.h"
#import "SDTBStatusItemHelper.h"

#import "NSString+FontAwesome.h"

#import <ServiceManagement/ServiceManagement.h>

@implementation SDStatusItemController {
    NSPopover *_attachedPopover;
    NSImage *_currentImage;
    NSImage *_statusImage;
    NSInteger _currentXOffset;
    NSTimer *_animationTimer;
    NSTimer *_restartTimer;
    
    NSArray *_titleKeys;
    NSInteger _titleIndex;
}

static const CGFloat kStatusBarItemWidth = 200.0;

- (NSAttributedString *)attributedStringForButton:(NSString *)text
{
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:titleRange];
    [colorTitle addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"FontAwesome" size:12.0] range:titleRange];
    return  colorTitle;
}

- (void) setupStatusItem {
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setAction:@selector(showInfoPanel:)];
    [self.statusItem setTarget:self];
    
    _titleIndex = 0;
    _titleKeys = @[@"trackName", @"trackArtist", @"trackAlbum"];

    [self _updateTitleForKey:_titleKeys[_titleIndex]];
    
    _attachedPopover = [[NSPopover alloc] init];
    [_attachedPopover setAppearance:NSPopoverAppearanceHUD];
    [_attachedPopover setAnimates:NO];
    [_attachedPopover setBehavior:NSPopoverBehaviorTransient];
    [_attachedPopover setDelegate:self];
    
    [_playButton setAttributedTitle:[self attributedStringForButton:[NSString awesomeIcon:FaPlay]]];
    [_playButton setAttributedAlternateTitle:[self attributedStringForButton:[NSString awesomeIcon:FaPause]]];
    
    [_previousButton setAttributedTitle:[self attributedStringForButton:[NSString awesomeIcon:FaBackward]]];
    
    [_nextButton setAttributedTitle:[self attributedStringForButton:[NSString awesomeIcon:FaForward]]];
    
    [_advancedButton setAttributedTitle:[self attributedStringForButton:[NSString awesomeIcon:FaCog]]];
}

- (void)hideInfoPanel
{
    [_attachedPopover close];
}

- (void)showInfoPanel:(id)sender
{
    if (_attachedPopover) {
        [self hideInfoPanel];
    }

    iTunesProxy *iProxy = [iTunesProxy proxy];
    NSViewController *viewController;
    
    if ([iProxy isRunning]) {
        viewController = _infoViewController;
    } else {
        viewController = _startViewController;
    }

    [_attachedPopover setContentViewController:viewController];
    
    [self updateHudInfo];
    
    // Thank you http://www.markosx.com/thecocoaquest/epiphany-for-fixing-nspopover/
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [_attachedPopover showRelativeToRect:NSZeroRect
                                  ofView:sender preferredEdge:NSMinYEdge];
}

- (void)popoverDidClose:(NSNotification *)notification
{
    NSLog(@"Did close");
}

- (void)popoverDidShow:(NSNotification *)notification
{
    NSLog(@"did show");
}

- (void)updateTextField:(NSTextField *)textField withString:(NSString *)string
{
    [textField setStringValue:string];
    [textField setToolTip:string];
}

- (void)updateHudInfo
{
    iTunesProxy *iProxy = [iTunesProxy proxy];
    
    if (![iProxy isRunning]) {
        [_attachedPopover setContentViewController:_startViewController];
        return;
    }
    
    if ([iProxy isPlaying]) {
        [_playButton setState:1];
    } else {
        [_playButton setState:0];
    }
    [_imageView setImage:[iProxy coverArtwork]];
    
    [self updateTextField:_titleField withString:[iProxy trackName]];
    [self updateTextField:_artistField withString:[iProxy trackArtist]];
    [self updateTextField:_albumField withString:[iProxy trackAlbum]];
}

- (void) iTunesUpdated {
    _titleIndex = 0;
    
	[self _updateTitleForKey:@"trackName"];
    if ([_attachedPopover isShown]) {
        [self updateHudInfo];
    }
}

- (void)copyFromImage:(NSImage *)srcImage
            intoImage:(NSImage *)destImage
               atSize:(CGSize)size
           fromOrigin:(CGPoint)origin
{
	[destImage lockFocus];
    
    [[NSColor clearColor] setFill];
    NSSize destSize = [destImage size];
    
    NSRectFill(NSMakeRect(0, 0, destSize.width, destSize.height));

    CGFloat originX = (size.width > [srcImage size].width) ? size.width - [srcImage size].width : 0;
    
    CGRect srcRect = CGRectMake(origin.x, origin.y, size.width, [destImage size].height);
    [srcImage drawAtPoint:CGPointMake(originX, 0) fromRect:srcRect operation:NSCompositeCopy fraction:1.0];
    
	[destImage unlockFocus];
}

- (void) _updateTitleForKey:(NSString *)key {
    NSString *title;
    
	if ([[iTunesProxy proxy] isRunning]) {
        title = [[iTunesProxy proxy] valueForKey:key];
        if (!title) {
            title = @"Unknown Track";
        }
	} else {
        title = @"Nothing Playing";
	}
	 
    [_statusItem setToolTip:title];
    
    NSFont *font = [NSFont menuBarFontOfSize:14.0];
	
	NSColor *foreColor = [NSColor blackColor];
	if ([[iTunesProxy proxy] isPlaying] == NO) {
		foreColor = [foreColor colorWithAlphaComponent:0.65];
    }

    NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowBlurRadius:1.0];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.3]];
	[shadow setShadowOffset:NSMakeSize(0, -1)];
	
	NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: foreColor,
                                 NSShadowAttributeName: shadow,
                                 };
    
    _currentImage = [SDTBStatusItemHelper imageFromString:title attributes:attributes];
    
    if (_statusImage == nil) {
        _statusImage = [[NSImage alloc] initWithSize:CGSizeMake(kStatusBarItemWidth, [_currentImage size].height)];
    }
    [self resetAnimation:nil];
}

- (void)updateImage
{
    NSDisableScreenUpdates();
    
    [self copyFromImage:_currentImage
              intoImage:_statusImage
                 atSize:CGSizeMake(kStatusBarItemWidth, [_currentImage size].height)
             fromOrigin:CGPointMake(_currentXOffset, 0)];
    
    [_statusItem setImage:_statusImage];
    [_statusItem setAlternateImage:_statusImage];
	
	NSEnableScreenUpdates();
}

- (void)resetAnimation:(NSTimer *)timer
{
    [_animationTimer invalidate];
    _animationTimer = nil;
    
    [_restartTimer invalidate];
    _restartTimer = nil;
    _currentXOffset = 0;
    
    [self updateImage];
    
    if ([_currentImage size].width > kStatusBarItemWidth) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(moveTheImage:) userInfo:nil repeats:YES];
    } else {
        _animationTimer = nil;
        _restartTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextTitle:) userInfo:nil repeats:NO];
    }
}

- (void)nextTitle:(NSTimer *)timer
{
    _titleIndex++;
    if (_titleIndex == 3) {
        _titleIndex = 0;
    }

    [self _updateTitleForKey:_titleKeys[_titleIndex]];
}

- (void)moveTheImage:(NSTimer *)timer
{
    _currentXOffset++;
    if (_currentXOffset + kStatusBarItemWidth > [_currentImage size].width) {
        [_animationTimer invalidate];
        _animationTimer = nil;
        _restartTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextTitle:) userInfo:nil repeats:NO];
    }
    
    [self updateImage];
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

- (IBAction)startiTunes:(id)sender {
    [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.iTunes"
                                                         options:0
                                  additionalEventParamDescriptor:nil
                                                launchIdentifier:NULL];
    if (_attachedPopover) {
        [_attachedPopover close];
        return;
    }
}

- (IBAction)showAdvancedMenu:(id)sender
{
    NSEvent *event = [NSApp currentEvent];
    [NSMenu popUpContextMenu:_advancedMenu
                   withEvent:event
                     forView:sender];
}

- (IBAction) toggleOpenAtLogin:(id)sender {
	NSInteger changingToState = ![sender state];
    if (!SMLoginItemSetEnabled(CFSTR("com.sleepfive.TunesBarPlusHelper"), changingToState)) {
        NSRunAlertPanel(@"Could not change Open at Login status",
                        @"For some reason, this failed. Most likely it's because the app isn't in the Applications folder.",
                        @"OK",
                        nil,
                        nil);
    }
}

- (BOOL) opensAtLogin {
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
@end
