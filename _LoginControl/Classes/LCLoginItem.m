//
//  SDLoginItemList.m
//  LoginControl
//
//  Created by Steven Degutis on 7/29/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "LCLoginItem.h"


@interface LCLoginItem ()


@end


@implementation LCLoginItem

@synthesize sharedFileItem;
@synthesize alias;

@synthesize displayName;
@synthesize icon;

- (id) initWithSharedFileItem:(LSSharedFileListItemRef)newSharedFileItem {
	if ((self = [super init])) {
		sharedFileItem = newSharedFileItem;
		CFRetain(sharedFileItem);
		
		CFStringRef theDisplayName = LSSharedFileListItemCopyDisplayName(sharedFileItem);
		displayName = (id)theDisplayName;
		
		IconRef iconRef = LSSharedFileListItemCopyIconRef(sharedFileItem);
		icon = [[NSImage alloc] initWithIconRef:iconRef];
		ReleaseIconRef(iconRef);
		
		FSRef ref;
		if (LSSharedFileListItemResolve(sharedFileItem, 0, NULL, &ref) == noErr)
			alias = [[NDAlias aliasWithFSRef:&ref] retain];
        else
            NSLog(@"couldna find alias for %@", displayName);
	}
	return self;
}

- (id) initWithAlias:(NDAlias*)someAlias {
    if ((self = [super init])) {
        alias = [someAlias retain];
        
        if ([self isBroken] == NO) {
            displayName = [[alias displayName] copy];
            icon = [[[NSWorkspace sharedWorkspace] iconForFile:[alias lastKnownPath]] retain];
        }
        else {
            displayName = [@"<Broken Link>" copy];
        }
    }
    return self;
}

- (void) dealloc {
	[displayName release];
	[icon release];
    
	[alias release];
    
    if (sharedFileItem)
        CFRelease(sharedFileItem);
	
	[super dealloc];
}

#pragma mark -
#pragma mark NSCoding compliance

- (id) initWithCoder:(NSCoder *)aDecoder {
    NDAlias *someAlias = [aDecoder decodeObjectForKey:@"alias"];
    return [self initWithAlias:someAlias];
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:alias forKey:@"alias"];
}

#pragma mark -
#pragma mark NSCopying compliance

- (id)copyWithZone:(NSZone *)zone {
    return [[LCLoginItem alloc] initWithAlias:self.alias];
}

#pragma mark -
#pragma mark collections compliance

- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[LCLoginItem self]])
        return NO;
    
    if ([self sharedFileItem] && [object sharedFileItem]) {
        FSRef ref1, ref2;
        
        OSStatus returnCode1 = LSSharedFileListItemResolve([self sharedFileItem], 0, NULL, &ref1);
        OSStatus returnCode2 = LSSharedFileListItemResolve([object sharedFileItem], 0, NULL, &ref2);
        
        return (returnCode1 == noErr && returnCode2 == noErr && FSCompareFSRefs(&ref1, &ref2) == noErr);
    }
    else {
        return [[self alias] isEqualToAlias:[object alias]];
    }
}

- (NSUInteger) hash {
    if (sharedFileItem)
        return LSSharedFileListItemGetID(sharedFileItem);
    else
        return [alias hash];
}

#pragma mark -
#pragma mark dynamic accessors

- (NSString*) kind {
	NSString *type = [[NSWorkspace sharedWorkspace] typeOfFile:[alias lastKnownPath] error:NULL];
	NSString *potentialKind = [[[NSWorkspace sharedWorkspace] localizedDescriptionForType:type] capitalizedString];
    if (potentialKind)
        return potentialKind;
    else
        return @"<Unknown Kind>";
}

- (BOOL) isBroken {
    if (sharedFileItem && alias == nil)
        return YES;
    else if (sharedFileItem == nil && [alias path] == nil)
        return YES;
    else
        return NO;
}

@end
