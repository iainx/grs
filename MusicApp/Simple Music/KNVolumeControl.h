#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioServices.h>

@interface KNVolumeControl : NSObject

+(float)volume;
+(void)setVolume:(Float32)newVolume;
+(AudioDeviceID)defaultOutputDeviceID;

@end
