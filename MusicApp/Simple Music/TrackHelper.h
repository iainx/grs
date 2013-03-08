//
//  TrackHelper.h
//  Simple Music
//
//  Created by Steven Degutis on 2/2/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@interface TrackHelper : NSObject

+ (NSString*) titleFor:(AVURLAsset*)asset;
+ (NSString*) albumFor:(AVURLAsset*)asset;
+ (NSString*) artistFor:(AVURLAsset*)asset;

@end
