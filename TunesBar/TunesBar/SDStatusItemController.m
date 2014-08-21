//
//  SDMainWindowController.m
//  CocoaApp
//
//  Created by Steven Degutis on 7/24/09.
//  Copyright 2009 8th Light. All rights reserved.
//  Modified by Iain Holmes
//  Copyright 2013 - 2014
//

#import <QuartzCore/QuartzCore.h>

#import "SDStatusItemController.h"

#import "DefaultsKeys.h"
#import "SDTBStatusItemHelper.h"
#import "SDTBWindow.h"
#import "SDTBHUDViewController.h"
#import "SDTBStartITunesViewController.h"
#import "FVColorArt.h"

#import "NSString+FontAwesome.h"
#import "NSWindow+Fade.h"
#import "Constants.h"
#import "CIImage+SoftwareBitmapRep.h"

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
    
    NSString *_artworkMD5;
    NSOperationQueue *_colourQueue;
    FVColorArt *_currentColors;
}

static const CGFloat kStatusBarItemWidth = 150.0;
static const CGFloat kStatusItemPadding = 10.0;

- (void)setupStatusItem
{
    _titleIndex = 0;
    _titleKeys = @[@"trackName", @"trackArtist", @"trackAlbum"];
    
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setAction:@selector(showInfoPanel:)];
    [self.statusItem setTarget:self];
    
    _statusView = [[NSButton alloc] initWithFrame:NSMakeRect(2, 0, kHeaderWidth, _statusItem.statusBar.thickness + 2)];
    [_statusView setButtonType:NSMomentaryChangeButton];
    _statusView.title = @"";
    _statusView.bordered = NO;
    
    _statusItem.view = _statusView;
    
    _statusView.action = @selector(showInfoPanel:);
    _statusView.target = self;

    _currentColors = [[FVColorArt alloc] init];
    
    // FIXME: _popOverWindow probably shouldn't be kept around all the time
    _popoverWindow = [[SDTBWindow alloc] initWithContentRect:NSMakeRect(0, 0, 550, 200)
                                                   styleMask:NSBorderlessWindowMask
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    _popoverWindow.delegate = self;
    [_popoverWindow setColorArt:_currentColors];
    
    _infoViewController = [[SDTBHUDViewController alloc] init];
    _infoViewController.colors = _currentColors;

    [self iTunesUpdated];
    [self watchForNotificationsWhichShouldHidePanel];
}

- (void)hideInfoPanel
{
    _popoverShown = NO;
    
    CGFloat width = (_statusImage.size.width < kStatusBarItemWidth - kStatusItemPadding) ? _statusImage.size.width + kStatusItemPadding : kStatusBarItemWidth;
    _statusItem.length = width;
    
    BOOL needsAnimation;
    [self updateImageForKey:_titleKeys[_titleIndex] needsAnimation:&needsAnimation];
    
    if (needsAnimation) {
        [self resetAnimation:nil];
    } else {
        [self updateImage];
    }
    
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
    
    //[self stopAllTimers];
    
    _popoverShown = YES;

    iTunesProxy *iProxy = [iTunesProxy proxy];
    NSViewController *viewController;
    
    if (![iProxy isRunning]) {
        viewController = [[SDTBStartITunesViewController alloc] init];
    } else {
        viewController = _infoViewController;
    }

    NSRect windowFrame = _statusView.window.frame;
    NSRect popoverContentFrame = [_popoverWindow.contentView frame];
    
    CGFloat itemRightX = NSMaxX(windowFrame);
    CGFloat headerRightX = kHeaderWidth + ((popoverContentFrame.size.width - kHeaderWidth) / 2);
    CGFloat x = itemRightX - headerRightX;
    
    NSRect contentBounds = viewController.view.bounds;
    CGFloat y = (NSMinY(windowFrame) - contentBounds.size.height);
    
    windowFrame.origin.x = x;
    windowFrame.origin.y = y + 1;
    
    windowFrame.size = popoverContentFrame.size;
    //windowFrame.size = contentBounds.size;

    [_popoverWindow setFrame:windowFrame display:YES];
    
    // We take the button out of the status item and place it into the overlay window
    // lining it up exactly.
    [_statusView removeFromSuperview];
    
    NSRect itemBounds = _statusView.bounds;
    _statusView.frame = NSMakeRect(headerRightX - kHeaderWidth, windowFrame.size.height - 22,
                                   itemBounds.size.width, itemBounds.size.height);
    _popoverShown = YES;
    
    [_popoverWindow.contentView addSubview:_statusView];

    // Set the width of the status item to our max width
    // so that the icons aren't under the header
    _statusItem.length = kHeaderWidth;
    
    BOOL needsAnimation;
    [self updateImageForKey:_titleKeys[_titleIndex] needsAnimation:&needsAnimation];
    [self updateImage];
    
    _popoverWindow.contentViewController = viewController;
    
    // Thank you http://www.markosx.com/thecocoaquest/epiphany-for-fixing-nspopover/
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
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

- (CIImage *)CIImageFromArtwork:(NSImage *)artwork
{
    CGImageRef cgImage = [artwork CGImageForProposedRect:NULL context:NULL hints:NULL];
    CIImage *inputImage = [[CIImage alloc] initWithCGImage:cgImage];

    NSSize size = inputImage.extent.size;

    if (size.width > 600 || size.height > 600) {
        CGFloat ratio;
        
        if (size.width > size.height) {
            ratio = 600.0 / size.width;
        } else {
            ratio = 600.0 / size.height;
        }
        inputImage = [inputImage imageByApplyingTransform:CGAffineTransformMakeScale(ratio, ratio)];
    }

    // Square the image
    CGRect squaredRect;

    CGRect extent = inputImage.extent;
    if (extent.size.width > extent.size.height) {
        CGFloat midX = NSMidX(extent);
        squaredRect = CGRectMake(midX - (extent.size.width / 2), 0, extent.size.width, extent.size.height);
    } else {
        CGFloat midY = NSMidY(extent);
        squaredRect = CGRectMake(0, midY - (extent.size.height / 2), extent.size.width, extent.size.height);
    }

    return [inputImage imageByCroppingToRect:squaredRect];
}

- (NSImage *)createBackgroundImage:(NSImage *)coverArtwork
{
    CIImage *ciArtwork = [self CIImageFromArtwork:coverArtwork];
    [_currentColors analyseCIImage:ciArtwork];
    
    NSRect extent = ciArtwork.extent;
    
    // Scale up to 650x650
    CGFloat ratio;
    
    if (NSWidth(extent) > NSHeight(extent)) {
        ratio = 650.0 / NSHeight(extent);
    } else {
        ratio = 650.0 / NSWidth(extent);
    }
    
    ciArtwork = [ciArtwork imageByApplyingTransform:CGAffineTransformMakeScale(ratio, ratio)];
    
    // Blur the CIImage
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:ciArtwork forKey:kCIInputImageKey];
    
    [blurFilter setValue:@(5) forKey:@"inputRadius"];
    CIImage *outputImage = [blurFilter valueForKey:kCIOutputImageKey];
    
    CIFilter *darkFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [darkFilter setDefaults];
    [darkFilter setValue:outputImage forKeyPath:kCIInputImageKey];
    [darkFilter setValue:@(0.8) forKeyPath:@"inputPower"];
    
    outputImage = [darkFilter valueForKey:kCIOutputImageKey];
    
    outputImage = [outputImage imageByCroppingToRect:NSInsetRect(ciArtwork.extent, 35, 35)];
    
    NSBitmapImageRep *rep = [outputImage RGBABitmapImageRep];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];
    return nsImage;
}

- (void)iTunesUpdated
{
    _titleIndex = 0;
    
    NSString *newMD5 = [[iTunesProxy proxy] artworkMD5];
    if ([newMD5 isEqualToString:_artworkMD5]) {
        return;
    }
    
    NSImage *coverArtwork = [[iTunesProxy proxy] coverArtwork];

    if (coverArtwork == nil) {
        [_currentColors resetColors];
        _artworkMD5 = nil;
        
        [self _updateTitleForKey:_titleKeys[_titleIndex]];
        //[self updateImage];
        
        _popoverWindow.backgroundImage = nil;
        return;
    }
    
    _artworkMD5 = newMD5;
    
    [self _updateTitleForKey:_titleKeys[_titleIndex]];
    //[self updateImage];
    
    NSImage *nsImage;
    nsImage = [self createBackgroundImage:coverArtwork];
    
    _popoverWindow.backgroundImage = nsImage;
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

- (void)updateImageForKey:(NSString *)key
           needsAnimation:(BOOL *)needsAnimation
{
    NSString *title;
    
    *needsAnimation = NO;
	if ([[iTunesProxy proxy] isRunning]) {
        title = [[iTunesProxy proxy] valueForKey:key];
        if (!title) {
            title = NSLocalizedString(@"Nothing Playing", nil);
        } else {
            *needsAnimation = YES;
        }
	} else {
        title = NSLocalizedString(@"Nothing Playing", nil);
	}
    
    [_statusItem setToolTip:title];
    
    NSFont *font = [NSFont menuBarFontOfSize:14.0];
	
    NSColor *primaryColour = _currentColors.primaryColor?:[NSColor whiteColor];
	NSColor *foreColor = _popoverShown ? primaryColour : [NSColor blackColor];
	if ([[iTunesProxy proxy] isPlaying] == NO) {
		foreColor = [foreColor colorWithAlphaComponent:0.65];
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowBlurRadius:_popoverShown ? 0.0 : 1.0];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.3]];
	[shadow setShadowOffset:NSMakeSize(0, -1)];
	
	NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: foreColor,
                                 NSShadowAttributeName: shadow,
                                 };
    
    _currentImage = [SDTBStatusItemHelper imageFromString:title attributes:attributes];
}

- (void)_updateTitleForKey:(NSString *)key
{
    BOOL needsAnimation;
    [self updateImageForKey:key needsAnimation:&needsAnimation];
    
    CGFloat width = MIN(kStatusBarItemWidth - kStatusItemPadding, _currentImage.size.width);
    _statusImage = [[NSImage alloc] initWithSize:CGSizeMake(width, [_currentImage size].height)];

    if (needsAnimation) {
        [self resetAnimation:nil];
    } else {
        [self updateImage];
    }
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
        CGFloat width = (_statusImage.size.width < kStatusBarItemWidth - kStatusItemPadding) ? _statusImage.size.width + kStatusItemPadding : kStatusBarItemWidth;
        
        [_statusItem setLength:width];
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
    
    if ([_currentImage size].width > (kStatusBarItemWidth - kStatusItemPadding)) {
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
    if (_currentXOffset + (kStatusBarItemWidth - kStatusItemPadding) > [_currentImage size].width) {
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
