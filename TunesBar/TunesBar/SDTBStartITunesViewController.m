//
//  SDTBStartITunesViewController.m
//  TunesBar+
//
//  Created by iain on 26/07/2014.
//  Copyright (c) 2014 Sleep(5). All rights reserved.
//

#import "SDTBStartITunesViewController.h"
#import "SDTBMenuViewController.h"

#import "NSAttributedString+FontAwesome.h"
#import <NSString+FontAwesome.h>

@interface SDTBStartITunesViewController ()

@end

@implementation SDTBStartITunesViewController

- (id)init
{
    self = [super initWithNibName:@"SDTBStartITunesViewController"
                           bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [_advancedButton setAttributedTitle:[NSAttributedString attributedFontAwesome:[NSString awesomeIcon:FaCog]]];
    
    if ([self.view respondsToSelector:@selector(appearance)]) {
        NSString *appearanceName = NSAppearanceNameLightContent;
        BOOL yosemite = NO;
        // We can only switch onto the vibrant appearance when we're running 10.10+
        if (NSClassFromString(@"NSVisualEffectView") != nil) {
            appearanceName = NSAppearanceNameVibrantDark;
            yosemite = YES;
        }
        
        self.view.appearance = [NSAppearance appearanceNamed:appearanceName];
        
        if (yosemite) {
            NSVisualEffectView *effectView = [[NSVisualEffectView alloc] initWithFrame:self.view.frame];
            effectView.material = NSVisualEffectMaterialDark;
            [effectView addSubview:self.view];
            self.view = effectView;
        }
    }
}

- (IBAction)startiTunes:(id)sender
{
    [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.iTunes"
                                                         options:0
                                  additionalEventParamDescriptor:nil
                                                launchIdentifier:NULL];
}

- (void)showAdvancedMenu:(id)sender
{
    SDTBMenuViewController *menuController = [[SDTBMenuViewController alloc] init];
    [menuController loadView];
    
    NSEvent *event = [NSApp currentEvent];
    [NSMenu popUpContextMenu:menuController.advancedMenu
                   withEvent:event
                     forView:sender];
}
@end
