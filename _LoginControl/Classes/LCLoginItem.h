//
//  SDLoginItemList.h
//  LoginControl
//
//  Created by Steven Degutis on 7/29/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <NDAlias/NDAlias.h>

@interface LCLoginItem : NSObject <NSCopying, NSCoding> {
	LSSharedFileListItemRef sharedFileItem;
	NDAlias *alias;
    
	NSString *displayName;
	NSImage *icon;
}

@property (readonly) LSSharedFileListItemRef sharedFileItem; // guaranteed if in live list
@property (readonly) NDAlias *alias; // guaranteed if in dead list

@property (readonly) NSString *displayName; // guaranteed
@property (readonly) NSString *kind; // guaranteed
@property (readonly) NSImage *icon; // guaranteed

- (id) initWithSharedFileItem:(LSSharedFileListItemRef)someSharedFileItem;
- (id) initWithAlias:(NDAlias*)someAlias;

- (BOOL) isBroken;

@end
