//
//  LCLiveListArray.h
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define LCLiveListArrayDidChangeNotification @"LCLiveListArrayDidChangeNotification"

@interface LCLiveListArray : NSMutableArray {
	LSSharedFileListRef sharedFileList;
	NSArray *internalArray;
}

+ (LCLiveListArray*) sharedArray;

@end
