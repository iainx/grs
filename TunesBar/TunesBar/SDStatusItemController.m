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
#import "SDTBWindow.h"
#import "SDTBHUDViewController.h"
#import "SDTBStartITunesViewController.h"

#import "NSString+FontAwesome.h"
#import "NSWindow+Fade.h"
#import "Constants.h"

@implementation SDStatusItemController {
    SDTBWindow *_popoverWindow;
    BOOL _popoverShown;
    
    SDTBHUDViewController *_infoViewController;
    
    NSButton *_statusView;
    
    NSImage *_currentImage;
    NSImage *_statusImage;
    NSInteger _currentXOffset;
    NSTimer *_animationTimer;
    NSTimer *_restartTimer;
    
    NSArray *_titleKeys;
    NSInteger _titleIndex;
}

static const CGFloat kStatusBarItemWidth = 150.0;

- (void)setupStatusItem
{
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setAction:@selector(showInfoPanel:)];
    [self.statusItem setTarget:self];
    
    _statusView = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, kHeaderWidth, _statusItem.statusBar.thickness + 2)];
    _statusItem.view = _statusView;
    [_statusView setButtonType:NSMomentaryChangeButton];
    _statusView.bordered = NO;
    
    _statusView.action = @selector(showInfoPanel:);
    _statusView.target = self;
    
    _titleIndex = 0;
    _titleKeys = @[@"trackName", @"trackArtist", @"trackAlbum"];

    [self _updateTitleForKey:_titleKeys[_titleIndex]];
    
    // FIXME: _popOverWindow probably shouldn't be kept around all the time
    _popoverWindow = [[SDTBWindow alloc] initWithContentRect:NSMakeRect(0, 0, 411, 104)
                                                   styleMask:NSBorderlessWindowMask
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    _popoverWindow.delegate = self;
    [self watchForNotificationsWhichShouldHidePanel];
}

- (void)hideInfoPanel
{
    _popoverShown = NO;
    
    _statusItem.length = _statusImage.size.width;
    
    [self updateImageForKey:_titleKeys[_titleIndex]];
    [self updateImage];
    
    [_statusView removeFromSuperview];
    _statusItem.view = _statusView;
    
    [_popoverWindow fadeOut];
}

- (void)showInfoPanel:(id)sender
{
    if (_popoverShown) {
        [self hideInfoPanel];
        return;
    }
    
    iTunesProxy *iProxy = [iTunesProxy proxy];
    NSViewController *viewController;
    
    if (![iProxy isRunning]) {
        viewController = [[SDTBStartITunesViewController alloc] init];
    } else {
        _infoViewController = [[SDTBHUDViewController alloc] init];
        viewController = _infoViewController;
    }

    _popoverWindow.contentViewController = viewController;
    
    // Thank you http://www.markosx.com/thecocoaquest/epiphany-for-fixing-nspopover/
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];

    NSRect windowFrame = _statusView.window.frame;
    NSRect popoverContentFrame = [_popoverWindow.contentView frame];
    
    CGFloat itemRightX = NSMaxX(windowFrame);
    CGFloat headerRightX = kHeaderWidth + ((popoverContentFrame.size.width - kHeaderWidth) / 2);
    CGFloat x = itemRightX - headerRightX;
    CGFloat y = (NSMaxY(windowFrame) - popoverContentFrame.size.height) - 22;
    
    windowFrame.origin.x = x;
    windowFrame.origin.y = y + 22;
    
    windowFrame.size = popoverContentFrame.size;

    [_popoverWindow setFrame:windowFrame display:YES];
    
    // We take the button out of the status item and place it into the overlay window
    // lining it up exactly.
    [_statusView removeFromSuperview];
    
    NSRect itemBounds = _statusView.bounds;
    _statusView.frame = NSMakeRect(headerRightX - 150.0/*itemBounds.size.width - 35*/, windowFrame.size.height - 22,
                                   itemBounds.size.width, itemBounds.size.height);
    
    NSLog(@"itemRightX: %f - headerRightX: %f - itemBounds: %@ - frame: %@", itemRightX, headerRightX, NSStringFromRect(itemBounds), NSStringFromRect(_statusView.frame));
    _popoverShown = YES;
    
    // Update the image to use a lighter colour as our background colour has changed
    [self updateImageForKey:_titleKeys[_titleIndex]];
    [self updateImage];
    
    [_popoverWindow.contentView addSubview:_statusView];

    NSLog(@"new %@", NSStringFromRect(_statusView.frame));
    // Set the width of the status item to our max width
    // so that the icons aren't under the header
    _statusItem.length = kHeaderWidth;
    
    [_popoverWindow fadeIn];
}

- (void)watchForNotificationsWhichShouldHidePanel
{
    // This works better than just making the panel hide when the app
    // deactivates (setHidesOnDeactivate:YES), because if we use that
    // then the panel will return when the app reactivates.
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideInfoPanel)
                                                 name:NSApplicationWillResignActiveNotification
                                               object:nil];
    
    // If the panel is no longer main, hide it.
    // (We could also use the delegate notification for this.)
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideInfoPanel)
                                                 name:NSWindowDidResignMainNotification
                                               object:_popoverWindow];
}

- (void)iTunesUpdated
{
    _titleIndex = 0;
    
	[self _updateTitleForKey:@"trackName"];
    
    [_infoViewController updateHUD];
}

- (void)copyFromImage:(NSImage *)srcImage
            intoImage:(NSImage *)destImage
               atSize:(CGSize)size
           fromOrigin:(CGPoint)origin
     backgroundColour:(NSColor *)colour
            operation:(NSCompositingOperation)op
{
	[destImage lockFocus];
    
    [colour setFill];
    NSSize destSize = [destImage size];
    
    NSRectFill(NSMakeRect(0, 0, destSize.width, destSize.height));

    CGFloat originX = (size.width > [srcImage size].width) ? size.width - [srcImage size].width : 0;
    
    CGRect srcRect = CGRectMake(origin.x, origin.y, size.width, [destImage size].height);
    [srcImage drawAtPoint:CGPointMake(originX, 0) fromRect:srcRect operation:op fraction:1.0];
    
	[destImage unlockFocus];
}

- (void)updateImageForKey:(NSString *)key {
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
	
	NSColor *foreColor = _popoverShown ? [NSColor whiteColor] : [NSColor blackColor];
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
}

- (void) _updateTitleForKey:(NSString *)key {
    [self updateImageForKey:key];
    
    CGFloat width = MIN(kStatusBarItemWidth, _currentImage.size.width);
    _statusImage = [[NSImage alloc] initWithSize:CGSizeMake(width, [_currentImage size].height)];

    [self resetAnimation:nil];
}

- (void)updateImage
{
    NSDisableScreenUpdates();
    
    NSColor *backgroundColour = [NSColor clearColor];
    NSCompositingOperation op = NSCompositeCopy;
    
    [self copyFromImage:_currentImage
              intoImage:_statusImage
                 atSize:CGSizeMake(_statusImage.size.width, [_currentImage size].height)
             fromOrigin:CGPointMake(_currentXOffset, 0)
       backgroundColour:backgroundColour
              operation:op];
    
    _statusView.image = _statusImage;
    [_statusView setNeedsDisplay];
    
    // If the popover is open, then we don't want the statusitem shrinking
    if (_popoverShown == NO) {
        [_statusItem setLength:_statusImage.size.width];
    }
	
	NSEnableScreenUpdates();
}

- (void)stopAllTimers
{
    [_animationTimer invalidate];
    _animationTimer = nil;
    
    [_restartTimer invalidate];
    _restartTimer = nil;
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

#pragma mark - SDTBWindowDelegate methods

- (BOOL)handlesKeyDown:(NSEvent *)keyDown
              inWindow:(NSWindow *)window
{
    // Close the panel on any keystroke.
    
    // Check for the escape key
    if ([[keyDown characters] isEqualToString:@"\033"]) {
        [self hideInfoPanel];
        return YES;
    }
    
    return NO;
}

- (BOOL)handlesMouseDown:(NSEvent *)mouseDown
                inWindow:(NSWindow *)window
{
    // Close the panel on any click
    return NO;
}

@end
