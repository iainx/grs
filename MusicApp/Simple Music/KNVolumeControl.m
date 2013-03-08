#import "KNVolumeControl.h"

@implementation KNVolumeControl

+(float)volume
{
	Float32			outputVolume;
    
	UInt32 propertySize = 0;
	OSStatus status = noErr;
	AudioObjectPropertyAddress propertyAOPA;
	propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
	propertyAOPA.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMasterVolume;
	propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    
	AudioDeviceID outputDeviceID = [KNVolumeControl defaultOutputDeviceID];
    
	if (outputDeviceID == kAudioObjectUnknown)
	{
        NSLog(@"Unknown device");
		return 0.0;
	}
    
	if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA))
	{
        NSLog(@"No volume returned for device 0x%0x", outputDeviceID);
		return 0.0;
	}
    
	propertySize = sizeof(Float32);
    
	status = AudioHardwareServiceGetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, &propertySize, &outputVolume);
    
	if (status)
	{
        NSLog(@"No volume returned for device 0x%0x", outputDeviceID);
		return 0.0;
	}
    
	if (outputVolume < 0.0 || outputVolume > 1.0) return 0.0;
    
	return outputVolume;
}



// setting system volume - mutes if under threshhold
+(void)setVolume:(Float32)newVolume
{
    if (newVolume < 0.0 || newVolume > 1.0)
	{
        NSLog(@"Requested volume out of range (%.2f)", newVolume);
		return;
        
	}
    
	// get output device device
	UInt32 propertySize = 0;
	OSStatus status = noErr;
	AudioObjectPropertyAddress propertyAOPA;
	propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
	propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    
	if (newVolume < 0.001)
	{
        NSLog(@"Requested mute");
		propertyAOPA.mSelector = kAudioDevicePropertyMute;
        
	}
	else
	{
        NSLog(@"Requested volume %.2f", newVolume);
		propertyAOPA.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMasterVolume;
	}
    
	AudioDeviceID outputDeviceID = [KNVolumeControl defaultOutputDeviceID];
    
	if (outputDeviceID == kAudioObjectUnknown)
	{
        NSLog(@"Unknown device");
		return;
	}
    
	if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA))
	{
        NSLog(@"Device 0x%0x does not support volume control", outputDeviceID);
		return;
	}
    
	Boolean canSetVolume = NO;
    
	status = AudioHardwareServiceIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetVolume);
    
	if (status || canSetVolume == NO)
	{
        NSLog(@"Device 0x%0x does not support volume control", outputDeviceID);
		return;
	}
    
	if (propertyAOPA.mSelector == kAudioDevicePropertyMute)
	{
		propertySize = sizeof(UInt32);
		UInt32 mute = 1;
		status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &mute);
	}
	else
	{
		propertySize = sizeof(Float32);
        
		status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &newVolume);
        
		if (status)
		{
            NSLog(@"Unable to set volume for device 0x%0x", outputDeviceID);
		}
        
		// make sure we're not muted
		propertyAOPA.mSelector = kAudioDevicePropertyMute;
		propertySize = sizeof(UInt32);
		UInt32 mute = 0;
        
		if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA))
		{
            NSLog(@"Device 0x%0x does not support muting", outputDeviceID);
			return;
		}
        
		Boolean canSetMute = NO;
        
		status = AudioHardwareServiceIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetMute);
        
		if (status || !canSetMute)
		{
            NSLog(@"Device 0x%0x does not support muting", outputDeviceID);
			return;
		}
        
		status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &mute);
	}
    
	if (status)
	{
        NSLog(@"Unable to set volume for device 0x%0x", outputDeviceID);
	}
    
}


+(AudioDeviceID)defaultOutputDeviceID
{
    AudioDeviceID	outputDeviceID = kAudioObjectUnknown;
    
	// get output device device
	UInt32 propertySize = 0;
	OSStatus status = noErr;
	AudioObjectPropertyAddress propertyAOPA;
	propertyAOPA.mScope = kAudioObjectPropertyScopeGlobal;
	propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
	propertyAOPA.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
    
	if (!AudioHardwareServiceHasProperty(kAudioObjectSystemObject, &propertyAOPA))
	{
        NSLog(@"Cannot find default output device!");
		return outputDeviceID;
	}
    
	propertySize = sizeof(AudioDeviceID);
    
	status = AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &propertyAOPA, 0, NULL, &propertySize, &outputDeviceID);
    
	if(status)
	{
        NSLog(@"Cannot find default output device!");
	}
	return outputDeviceID;
}


@end
