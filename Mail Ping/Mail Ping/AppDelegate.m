//
//  AppDelegate.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/15/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "EmailAccountsController.h"

#import <ServiceManagement/ServiceManagement.h>

#import "Reachability.h"

#define GMAIL_CHECK_INTERVAL (60.0)

@implementation AppDelegate

- (void) loadStatusItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"statusimage"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"statusimage_pressed"]];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusMenu];
}

- (void) awakeFromNib {
    [self loadStatusItem];
}

- (void) composeEmailAs:(NSMenuItem*)sender {
    NSInteger idx = [sender tag];
    NSString* url = [NSString stringWithFormat:@"https://mail.google.com/mail/u/%ld/#inbox?compose=new", idx];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

- (void) openInboxFor:(NSMenuItem*)sender {
    NSInteger idx = [sender tag];
    NSString* url = [NSString stringWithFormat:@"https://mail.google.com/mail/u/%ld/#inbox", idx];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

- (IBAction) checkEmailsManually:(id)sender {
//    [self performSelector:@selector(flashUnreadIndicator:) withObject:@(YES) afterDelay:0.00];
//    [self performSelector:@selector(flashUnreadIndicator:) withObject:@(NO)  afterDelay:0.15];
//    [self performSelector:@selector(flashUnreadIndicator:) withObject:@(YES) afterDelay:0.30];
//    [self performSelector:@selector(flashUnreadIndicator:) withObject:@(NO)  afterDelay:0.45];
//    [self performSelector:@selector(flashUnreadIndicator:) withObject:@(YES) afterDelay:0.60];
//    [self performSelector:@selector(updateUnreadIndicator) withObject:nil    afterDelay:0.75];
    
    [self.emailChecker forceCheckEmail];
}

// compose email: https://mail.google.com/mail/u/0/#inbox?compose=new (as: ...)

- (void) updateUnreadIndicator {
    NSString* imageName = self.someUnread ? @"statusimage_unread" : @"statusimage";
    [self.statusItem setImage:[NSImage imageNamed:imageName]];
}

//- (void) flashUnreadIndicator:(NSNumber*)state {
//    NSString* imageName = [state boolValue] ? @"statusimage_unread" : @"statusimage";
//    [self.statusItem setImage:[NSImage imageNamed:imageName]];
//}

- (void) markSomeUnread:(BOOL)someUnread {
    self.someUnread = someUnread;
    [self updateUnreadIndicator];
}

- (IBAction) toggleOpenAtLogin:(id)sender {
	NSInteger changingToState = ![sender state];
    if (!SMLoginItemSetEnabled(CFSTR("org.degutis.MailPingHelper"), changingToState)) {
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
            if ([[job objectForKey:@"Label"] isEqualToString: @"org.degutis.MailPingHelper"]) {
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
        
        return bOnDemand;
    }
    return NO;
}

#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)

- (NSString*) humanReadableTimeSince:(NSDate*)lastChecked {
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate: lastChecked];
    
    if (delta < 1 * MINUTE) {
        return @"less than a minute ago";
    }
    else if (delta < 2 * MINUTE) {
        return @"about a minute ago";
    }
    else if (delta < 45 * MINUTE) {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    else if (delta < 90 * MINUTE) {
        return @"about an hour ago";
    }
    else {
        return @"a very long time ago";
    }
}

- (void) menuNeedsUpdate:(NSMenu *)menu {
    NSMenuItem* menuItem = [menu itemWithTag:1];
    
    NSString* title = @"Checking now...";
    if (self.emailChecker.lastChecked)
        title = [NSString stringWithFormat:@"Checked %@", [self humanReadableTimeSince:self.emailChecker.lastChecked]];
    
    NSFont* font = [NSFont systemFontOfSize:11.0];
    NSAttributedString* attrTitle = [[NSAttributedString alloc] initWithString:title
                                                                    attributes:@{NSFontAttributeName: font}];
    [menuItem setAttributedTitle:attrTitle];
    
    BOOL opensAtLogin = [self opensAtLogin];
    [[menu itemWithTitle:@"Open at Login"] setState:(opensAtLogin ? NSOnState : NSOffState)];
}

- (IBAction) showAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) showAccountsWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (!self.myAccountsWindowController)
        self.myAccountsWindowController = [[MyAccountsWindowController alloc] init];
    
    [self.myAccountsWindowController showWindow:self];
}

- (void) wokeUp:(NSNotification*)note {
    [self.checkTimer fire];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"again reachable!");
            [self.checkTimer fire];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"no longer reachable!");
        });
    };
    
    [reach startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wokeUp:)
                                                 name:NSWorkspaceDidWakeNotification
                                               object:nil];
    
    NSUserNotificationCenter* userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    [userNotificationCenter removeAllDeliveredNotifications];
    
    self.emailChecker = [[EmailChecker alloc] init];
    self.emailChecker.delegate = self;
    
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:GMAIL_CHECK_INTERVAL
                                                       target:self.emailChecker
                                                     selector:@selector(checkEmail)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [self.checkTimer fire];
    
    if ([[EmailAccountsController emailAccounts] count] == 0)
        [self showAccountsWindow:self];
}

@end
