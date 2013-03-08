//
//	SDTexturedSliderCell.m
//	Docks
//
//	Created by Steven Degutis on 7/16/09.
//	Copyright 2009 8th Light, Inc.. All rights reserved.
//

#import "SDTexturedSliderCell.h"


@implementation SDTexturedSliderCell

@synthesize trackHeight;

static NSImage *trackLeftImage, *trackFillImage, *trackRightImage, *thumbPImage, *thumbNImage;

+ (void)initialize	{
	if ([self class] == [SDTexturedSliderCell class]) {
		NSBundle *bundle = [NSBundle mainBundle];
		
		trackLeftImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderTrackLeft.tiff"]];
		trackFillImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderTrackFill.tiff"]];
		trackRightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderTrackRight.tiff"]];
		thumbPImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderThumbP.tiff"]];
		thumbNImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"TexturedSliderThumbN.tiff"]];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
		[self setTrackHeight:[decoder decodeBoolForKey:@"BWTSTrackHeight"]];
		[self setControlSize:NSSmallControlSize];
		isPressed = NO;
		
		[self setNumberOfTickMarks:([self maxValue] - [self minValue]) + 1];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeBool:[self trackHeight] forKey:@"BWTSTrackHeight"];
}

- (NSControlSize)controlSize {
	return NSRegularControlSize;
}

- (void)setControlSize:(NSControlSize)size {
}

- (NSInteger)numberOfTickMarks {
	return 0;
}

//- (void)setNumberOfTickMarks:(NSInteger)numberOfTickMarks {
//}

- (void)drawBarInside:(NSRect)cellFrame flipped:(BOOL)flipped {
//	[[NSColor redColor] setFill];
//	[NSBezierPath fillRect:cellFrame];
	
	NSRect slideRect = cellFrame;
	
	if (trackHeight == 0)
		slideRect.size.height = trackFillImage.size.height;
	else
		slideRect.size.height = trackFillImage.size.height + 1;
	
	slideRect.origin.y += roundf((cellFrame.size.height - slideRect.size.height) / 2);
	
	// Inset the bar so the knob goes all the way to both ends
	slideRect.size.width -= 9;
	slideRect.origin.x += 5;
	
	if ([self isEnabled])
		NSDrawThreePartImage(slideRect, trackLeftImage, trackFillImage, trackRightImage, NO, NSCompositeSourceOver, 1, flipped);
	else
		NSDrawThreePartImage(slideRect, trackLeftImage, trackFillImage, trackRightImage, NO, NSCompositeSourceOver, 0.5, flipped);
}

- (void)drawKnob:(NSRect)rect {
	NSImage *drawImage;
	
	if (isPressed)
		drawImage = thumbPImage;
	else
		drawImage = thumbNImage;
	
	NSPoint drawPoint;
	drawPoint.x = rect.origin.x + roundf((rect.size.width - drawImage.size.width) / 2);
	drawPoint.y = NSMaxY(rect) - roundf((rect.size.height - drawImage.size.height) / 2);
	
	if (trackHeight == 0)
		drawPoint.y++;
	
	drawPoint.y -= 3.0;
	
	[drawImage compositeToPoint:drawPoint operation:NSCompositeSourceOver];
}

- (BOOL)_usesCustomTrackImage {
	return YES;
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {
	isPressed = YES;
	return [super startTrackingAt:startPoint inView:controlView];	
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
	isPressed = NO;
	[super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
}

@end
