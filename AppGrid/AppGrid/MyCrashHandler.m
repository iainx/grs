//
//  MyCrashHandler.m
//  AppGrid
//
//  Created by Steven Degutis on 3/7/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyCrashHandler.h"

#import <CrashReporter/CrashReporter.h>

@implementation MyCrashHandler

+ (void) handleCrashes {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    if ([crashReporter hasPendingCrashReport])
        [self handleCrashReport];
    
    NSError* __autoreleasing error;
    if (![crashReporter enableCrashReporterAndReturnError: &error])
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    
}

+ (void) handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    NSError* __autoreleasing error;
    NSData* crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
    if (report == nil) {
        NSLog(@"Could not parse crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    NSString* textReport = [PLCrashReportTextFormatter stringValueForCrashReport:report
                                                                  withTextFormat:PLCrashReportTextFormatiOS];
    
    [self sendCrashReport:textReport];
    
    [crashReporter purgePendingCrashReport];
}

+ (void) sendCrashReport:(NSString*)report {
    NSLog(@"sending crash report...");
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString* appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://grsw.herokuapp.com/crashes"]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{
                          @"app": appName,
                          @"version": appVersion,
                          @"report": report,
                          }
                                                         options:0
                                                           error:NULL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* e) {
                               NSLog(@"sent crash report");
                           }];
}

@end
