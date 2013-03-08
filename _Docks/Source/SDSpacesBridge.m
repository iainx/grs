//
//  SDSpacesListener.m
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDSpacesBridge.h"

#import <QuartzCore/QuartzCore.h>

// based on code found at http://tonyarnold.com/entries/detecting-when-the-active-space-changes-under-leopard/

typedef int CGSConnection;
typedef void (*CGConnectionNotifyProc)(int data1, int data2, int data3, void* userParameter);
extern CGSConnection _CGSDefaultConnection(void);
extern OSStatus CGSGetWorkspace(const CGSConnection cid, int *workspace);
extern CGError CGSRegisterConnectionNotifyProc(const CGSConnection cid, CGConnectionNotifyProc function, int data1, void* userParameter);

@implementation SDSpacesBridge

static int SDLastSpaceNumber = 0;

void SDSpacesCallback(int data1, int data2, int data3, void* userParameter) {
    int spaceID = 0;
    CGSGetWorkspace(_CGSDefaultConnection(), &spaceID);
    
    if ((spaceID != 65538) && (spaceID != SDLastSpaceNumber)) {
		[(id<SDSpacesDelegate>)userParameter spacesDidSwitchToSpaceWithNumber:spaceID];
		SDLastSpaceNumber = spaceID;
	}
}

+ (void) addObserverToChangingSpacesEvent:(id<SDSpacesDelegate>)newDelegate {
	CGSRegisterConnectionNotifyProc(_CGSDefaultConnection(), SDSpacesCallback, 1401, (void*)newDelegate);
}

@end
