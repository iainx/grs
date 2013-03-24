//
//  TrackHelper.m
//  Simple Music
//
//  Created by Steven Degutis on 2/2/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "TrackHelper.h"

@implementation TrackHelper

+ (NSString*) metadataFor:(AVURLAsset*)asset ofType:(NSString*)type handler:(dispatch_block_t)handler {
    NSArray* ok = [asset commonMetadata];
    
    AVMetadataItem* one = [ok lastObject];
    
    NSLog(@"%d", [one statusOfValueForKey:type error:NULL] == AVKeyValueStatusLoaded);
    
    NSArray* metadataItems = [AVMetadataItem metadataItemsFromArray:[asset commonMetadata]
                                                            withKey:type
                                                           keySpace:AVMetadataKeySpaceCommon];
    
    if ([metadataItems count] == 0) {
        if (type == AVMetadataCommonKeyTitle)
            return [[asset URL] lastPathComponent];
        else
            return @"";
    }
    
    AVMetadataItem* item = [metadataItems objectAtIndex:0];
    
    AVKeyValueStatus status = [item statusOfValueForKey:type error:NULL];
    
//    NSLog(@"%d", status == AVKeyValueStatusLoaded);
    
//    if (status == AVKeyValueStatusLoaded)
//        return (id)[item value];
//    
//    [item loadValuesAsynchronouslyForKeys:@[type] completionHandler:handler];
    
    return @"<loading...>";
}

+ (NSString*) titleFor:(AVURLAsset*)asset handler:(dispatch_block_t)handler {
    return [self metadataFor:asset ofType:AVMetadataCommonKeyTitle handler:handler];
}

+ (NSString*) albumFor:(AVURLAsset*)asset handler:(dispatch_block_t)handler {
    return [self metadataFor:asset ofType:AVMetadataCommonKeyAlbumName handler:handler];
}

+ (NSString*) artistFor:(AVURLAsset*)asset handler:(dispatch_block_t)handler {
    return [self metadataFor:asset ofType:AVMetadataCommonKeyArtist handler:handler];
}

@end
