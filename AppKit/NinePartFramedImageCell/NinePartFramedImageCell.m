//
//  NinePartFramedImageCell.m
//
//  Created by John Chang on 2011-02-07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "NinePartFramedImageCell.h"


@implementation NinePartFramedImageCell

@synthesize topLeftCornerImage, topEdgeFillImage, topRightCornerImage;
@synthesize leftEdgeFillImage, rightEdgeFillImage;
@synthesize bottomLeftCornerImage, bottomEdgeFillImage, bottomRightCornerImage;


static NSRect CenterRectInRect(NSRect rect, NSRect containerRect)
{
	rect.origin.x = NSMinX(containerRect) + round((NSWidth(containerRect) - NSWidth(rect)) * 0.5);
	rect.origin.y = NSMinY(containerRect) + round((NSHeight(containerRect) - NSHeight(rect)) * 0.5);
	return rect;
}

static NSSize ScaleAspectFitSizeInSize(NSSize size, NSSize containerSize, BOOL upscale)
{
	// Based on http://www.cocoadev.com/index.pl?ThumbnailImages
	float heightQuotient = size.height / containerSize.height;
	float widthQuotient = size.width / containerSize.width;
	if ((heightQuotient > 1.0 || widthQuotient > 1.0) || upscale) {
		if (heightQuotient > widthQuotient)
			size = NSMakeSize(round(size.width / heightQuotient), round(size.height / heightQuotient));
		else
			size = NSMakeSize(round(size.width / widthQuotient), round(size.height / widthQuotient));
	}
	return size;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	if (getenv("PictureFrameImageCellDebug")) {
		[[NSColor redColor] set];
		NSFrameRect(cellFrame);
	}
	
	NSRect cellImageRect = [super imageRectForBounds:cellFrame];
	if (getenv("PictureFrameImageCellDebug")) {
		[[NSColor redColor] set];
		NSFrameRect(cellImageRect);
	}
	
	// Compute cell interior frame
	NSRect cellInteriorFrame = NSInsetRect(cellImageRect, [topLeftCornerImage size].height, [topLeftCornerImage size].width);
	if (getenv("PictureFrameImageCellDebug")) {
		[[NSColor blueColor] set];
		NSFrameRect(cellInteriorFrame);
	}
	
	// Compute centered aspect-scaled image frame
	NSSize imageSize = ScaleAspectFitSizeInSize([[self image] size], cellInteriorFrame.size, NO);
	NSRect imageRect = NSMakeRect(0.0, 0.0, imageSize.width, imageSize.height);
	imageRect = CenterRectInRect(imageRect, cellInteriorFrame);
	
	// Draw cell background and image
	[[NSColor whiteColor] set];
	NSRectFill(imageRect); // white background
	[[self image] drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
	
	// Draw picture frame
	NSRect pictureFrameRect = NSInsetRect(imageRect, -[topLeftCornerImage size].height, -[topLeftCornerImage size].width);
	NSDrawNinePartImage(pictureFrameRect, topLeftCornerImage, topEdgeFillImage, topRightCornerImage, leftEdgeFillImage, nil,
						rightEdgeFillImage, bottomLeftCornerImage, bottomEdgeFillImage, bottomRightCornerImage,
						NSCompositeSourceOver, 1.0, [controlView isFlipped]);	
	if (getenv("PictureFrameImageCellDebug")) {
		[[NSColor greenColor] set];
		NSFrameRect(pictureFrameRect);
	}
}

@end
