//
//  EmailChecker.m
//  Mail Ping
//
//  Created by Steven Degutis on 2/17/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "EmailChecker.h"

#import "GmailFeed.h"
#import "GmailEntry.h"

#import "EmailAccountsController.h"

@implementation EmailChecker

- (id) init {
    if ((self = [super init])) {
        self.lastCheckedTimes = [NSMutableDictionary dictionary];
        
        NSUserNotificationCenter* userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
        [userNotificationCenter setDelegate:self];
    }
    return self;
}

- (void) showNotificationsForAccount:(NSString*)email feed:(GmailFeed*)feed {
    NSUserNotificationCenter* userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    
    for (NSUserNotification* oldNote in userNotificationCenter.deliveredNotifications) {
        NSString* deliveredForEmail = [[oldNote userInfo] objectForKey:@"email"];
        if ([deliveredForEmail isEqualToString:email])
            [userNotificationCenter removeDeliveredNotification:oldNote];
    }
    
    for (GmailEntry* entry in feed.unreadEntries) {
        NSUserNotification* note = [[NSUserNotification alloc] init];
        
        note.title = entry.title;
        note.subtitle = [NSString stringWithFormat:@"%@ <%@>", entry.authorName, entry.authorEmail];
        note.informativeText = entry.summary;
        
        note.soundName = NSUserNotificationDefaultSoundName;
        
        note.hasActionButton = YES;
        note.actionButtonTitle = @"Read";
        
        NSString* link = entry.link;
        
        link = [link stringByReplacingOccurrencesOfString:@"mail.google.com/mail" withString:[NSString stringWithFormat:@"mail.google.com/mail/u/%lu", [[EmailAccountsController emailAccounts] indexOfObject:email]]];
        
        note.userInfo = @{@"link": link, @"email": email};
        
        [userNotificationCenter deliverNotification:note];
    }
}

- (void) checkEmailForced:(BOOL)forced {
    self.lastChecked = nil;
    
    __block NSInteger numCheckedAccounts = [[EmailAccountsController emailAccounts] count];
    __block NSUInteger unreadCount = 0;
    
    for (NSString* email in [EmailAccountsController emailAccounts]) {
        [GmailFeed getFeedForUsername:email
                             password:[EmailAccountsController passwordForEmailAccount:email]
                              handler:^(GmailFeed *feed) {
                                  if (feed.lastModified == nil)
                                      return; // shouldnt need this guard anymore but meh, better not to crash
                                  
                                  self.lastChecked = [NSDate date];
                                  
                                  unreadCount += feed.unreadCount;
                                  numCheckedAccounts--;
                                  
                                  if (numCheckedAccounts <= 0)
                                      [self.delegate markSomeUnread:(unreadCount > 0)];
                                  
                                  BOOL shouldCheck = NO;
                                  
                                  if (forced) {
                                      shouldCheck = YES;
                                  }
                                  else {
                                      NSString* lastChecked = [self.lastCheckedTimes objectForKey:email];
                                      
                                      if (!lastChecked)
                                          lastChecked = @"";
                                      
                                      shouldCheck = ([feed.lastModified isEqualToString:lastChecked] == NO);
                                  }
                                  
                                  if (shouldCheck) {
                                      [self.lastCheckedTimes setObject:feed.lastModified
                                                                forKey:email];
                                      [self showNotificationsForAccount:email feed:feed];
                                  }
                              }];
    }
}

- (void) forceCheckEmail {
    [self checkEmailForced:YES];
}

- (void) checkEmail {
    [self checkEmailForced:NO];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void) userNotificationCenter:(NSUserNotificationCenter *)center
        didActivateNotification:(NSUserNotification *)notification
{
    NSURL* url = [NSURL URLWithString:[[notification userInfo] objectForKey:@"link"]];
    [[NSWorkspace sharedWorkspace] openURL:url];
    
    [center removeDeliveredNotification:notification];
}

@end
