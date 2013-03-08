//
//  SDRunningApplication.m
//  Docks
//
//  Created by Steven Degutis on 7/15/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDRunningApplication.h"


@implementation SDRunningApplication

+ (id) appWithBundleID:(NSString*)newBundleID {
	return [[[self alloc] initWithBundleID:newBundleID] autorelease];
}

- (id) initWithBundleID:(NSString*)newBundleID {
	if (self = [super init]) {
		bundleID = [newBundleID copy];
		
		BOOL found = NO;
		
		ProcessSerialNumber temppsn = { 0, kNoProcess };
		while (GetNextProcess(&temppsn) != procNotFound) {
			BOOL isSameProcess = NO;
			
			// kProcessDictionaryIncludeAllInformationMask seems to be the only choice we have for the second param
			NSDictionary *dict = (NSDictionary*)ProcessInformationCopyDictionary(&temppsn, kProcessDictionaryIncludeAllInformationMask);
			NSString *lowercaseFoundBundleID = [[dict objectForKey:(NSString*)kCFBundleIdentifierKey] lowercaseString];
			NSString *lowercaseBundleID = [bundleID lowercaseString];
			isSameProcess = [lowercaseFoundBundleID isEqualToString: lowercaseBundleID];
			[dict release];
			
			if (isSameProcess) {
				found = YES;
				psn = temppsn;
				break;
			}
		}
		
		if (found == NO) {
			[self release];
			return nil;
		}
	}
	
	return self;
}

- (void) dealloc {
	[bundleID release];
	[super dealloc];
}

- (void) quit {
	OSErr errorToReturn;
	AEDesc targetProcess;
	AppleEvent theEvent;
	AppleEvent eventReply = {typeNull, NULL};
	
	errorToReturn = AECreateDesc(typeProcessSerialNumber, &psn, sizeof(psn), &targetProcess);
	
	if (errorToReturn != noErr)
		return;
	
	errorToReturn = AECreateAppleEvent(kCoreEventClass, kAEQuitApplication, &targetProcess, kAutoGenerateReturnID, kAnyTransactionID, &theEvent);
	
	AEDisposeDesc(&targetProcess);
	
	if (errorToReturn != noErr)
		return;
	
	errorToReturn = AESendMessage(&theEvent, &eventReply, kAEWaitReply + kAEAlwaysInteract, kAEDefaultTimeout);
	
	AEDisposeDesc(&theEvent);
	AEDisposeDesc(&eventReply);
}

@end
