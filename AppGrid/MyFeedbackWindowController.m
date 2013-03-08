//
//  MyFeedbackWindowController.m
//  AppGrid
//
//  Created by Steven Degutis on 3/5/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyFeedbackWindowController.h"

@implementation MyFeedbackWindowController

- (NSString*) windowNibName {
    return @"MyFeedbackWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.level = NSModalPanelWindowLevel;
    
    self.type = @"Feature Request";
}

- (void) gotItAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [[alert window] orderOut:self];
    [self close];
    
    self.type = @"Feature Request";
    self.body = nil;
}

- (IBAction) sendFeedback:(id)sender {
    self.isSending = YES;
    
    [self sendFeedbackFromName:self.name
                         email:self.email
                          body:self.body
                          type:self.type
                       handler:^(BOOL fine) {
                           self.isSending = NO;
                           
                           if (fine) {
                               [[NSAlert alertWithMessageText:@"We got your feedback."
                                                defaultButton:@"OK"
                                              alternateButton:nil
                                                  otherButton:nil
                                    informativeTextWithFormat:@"Thanks :)"]
                                beginSheetModalForWindow:[self window]
                                modalDelegate:self
                                didEndSelector:@selector(gotItAlertDidEnd:returnCode:contextInfo:)
                                contextInfo:NULL];
                           }
                           else {
                               [[NSAlert alertWithMessageText:@"Something went wrong."
                                                defaultButton:@"OK"
                                              alternateButton:nil
                                                  otherButton:nil
                                    informativeTextWithFormat:@"We couldn't send your feedback. Maybe try again?"]
                                beginSheetModalForWindow:[self window]
                                modalDelegate:nil
                                didEndSelector:NULL
                                contextInfo:NULL];
                           }
                       }];
}

- (void) sendFeedbackFromName:(NSString*)name
                        email:(NSString*)email
                         body:(NSString*)body
                         type:(NSString*)type
                      handler:(void(^)(BOOL fine))blk
{
    if (!name) name = @"";
    if (!email) email = @"";
    if (!body) body = @"";
    if (!type) type = @"";
    
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString* appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://grsw.herokuapp.com/feedback"]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{
                          @"app": appName,
                          @"version": appVersion,
                          @"name": name,
                          @"email": email,
                          @"body": body,
                          @"type": type,
                          }
                                                         options:0
                                                           error:NULL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* e) {
                               NSError *__autoreleasing error;
                               id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
                                                                              error:&error];
                               
                               BOOL fine = [jsonObj isEqual:@{@"status": @"ok"}];
                               blk(fine);
                           }];
}

@end
