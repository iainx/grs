//
//  SDMainWindowController.m
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//  Modified by Iain Holmes
//  Copyright 2013, Sleep(5), Ltd
//

#import "SDStatusItemController.h"

#import "DefaultsKeys.h"
#import "SDTBStatusItemHelper.h"

#import <ServiceManagement/ServiceManagement.h>

@implementation SDStatusItemController {
    NSPopover *_attachedPopover;
}

static const NSTimeInterval INFO_CHANGE_DELAY = 10;
- (void) setupStatusItem {
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setAction:@selector(showInfoPanel:)];
    [self.statusItem setTarget:self];
    
    [self _updateTitle];
    
    _attachedPopover = [[NSPopover alloc] init];
    [_attachedPopover setAppearance:NSPopoverAppearanceHUD];
    [_attachedPopover setAnimates:NO];
    [_attachedPopover setBehavior:NSPopoverBehaviorTransient];
    [_attachedPopover setDelegate:self];
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
}

- (void)popoverDidShow:(NSNotification *)notification
{
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
    
    [_titleField setStringValue:[iProxy trackName]];
    [_artistField setStringValue:[iProxy trackArtist]];
    [_albumField setStringValue:[iProxy trackAlbum]];
}

- (void) iTunesUpdated {
	[self _updateTitle];
    if ([_attachedPopover isShown]) {
        [self updateHudInfo];
    }
}

- (void) _updateTitle {
    NSString *title;
	if ([[iTunesProxy proxy] isRunning]) {
        title = [[iTunesProxy proxy] valueForKey:@"trackName"];
        if (!title) {
            title = @"Unknown Track";
        }
	} else {
        title = @"Nothing Playing";
	}
	   
    [self changeDisplayString:title];
}

- (void)changeDisplayString:(NSString *)title
{
	NSFont *font = [NSFont menuBarFontOfSize:15.0];
	
	NSColor *foreColor = [NSColor blackColor];
	if ([[iTunesProxy proxy] isPlaying] == NO) {
		foreColor = [foreColor colorWithAlphaComponent:0.65];
    }
	
	[SDTBStatusItemHelper setImagesWithTitle:title
                                        font:font
                                   foreColor:foreColor
                                onStatusItem:self.statusItem];
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
