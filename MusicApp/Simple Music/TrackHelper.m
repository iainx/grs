//
//  TrackHelper.m
//  Simple Music
//
//  Created by Steven Degutis on 2/2/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "TrackHelper.h"

@implementation TrackHelper

+ (NSString*) thingFor:(AVURLAsset*)asset ofType:(NSString*)type {
    NSArray* titles = [AVMetadataItem metadataItemsFromArray:[asset commonMetadata]
                                                     withKey:type
                                                    keySpace:AVMetadataKeySpaceCommon];
    
    switch ([titles count]) {
        case 0:
            if (type == AVMetadataCommonKeyTitle)
                return [[asset URL] lastPathComponent];
            else
                return @"";
        case 1:
            return [[titles lastObject] value];
        default:
            return [[titles objectAtIndex:0] value];
    }
}

+ (NSString*) titleFor:(AVURLAsset*)asset {
    return [self thingFor:asset ofType:AVMetadataCommonKeyTitle];
}

+ (NSString*) albumFor:(AVURLAsset*)asset {
    return [self thingFor:asset ofType:AVMetadataCommonKeyAlbumName];
}

+ (NSString*) artistFor:(AVURLAsset*)asset {
    return [self thingFor:asset ofType:AVMetadataCommonKeyArtist];
}

@end
