//
//  ThreePartImageButtonCell.m
//
//  Created by John Chang on 2010-11-07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "ThreePartImageButtonCell.h"


@implementation ThreePartImageButtonCell

@synthesize leftCapWidth, topCapHeight;


- (void)commonInit
{
	[self setBezelStyle:NSRegularSquareBezelStyle];
}

- (id)initTextCell:(NSString *)aString
{
	self = [super initTextCell:aString];
	if (self != nil) {
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		[self commonInit];
	}
	return self;
}

- (void) dealloc
{
	[_startCap release];
	[_centerFill release];
	[_endCap release];
	[super dealloc];
}


- (void)setStretchableImage:(NSImage *)image leftCapWidth:(NSInteger)left topCapHeight:(NSInteger)top
{
	leftCapWidth = left;
	topCapHeight = top;
	
	NSRect startCapRect, centerFillRect, endCapRect;
	
	if (left > 0.0) {	// horizontal
		startCapRect = NSMakeRect(0.0, 0.0, left, [image size].height);
		centerFillRect = NSMakeRect(left, 0.0, 1.0, [image size].height);
		endCapRect = NSMakeRect([image size].width-left, 0.0, left, [image size].height);
	}
	else {				// vertical
		startCapRect = NSMakeRect(0.0, 0.0, [image size].width, top);
		centerFillRect = NSMakeRect(top, 0.0, [image size].width, 1.0);
		endCapRect = NSMakeRect([image size].height-top, 0.0, [image size].width, top);
	}
	
	// chop up the image into 3 parts
	[_startCap release];
	_startCap = [[NSImage alloc] initWithSize:startCapRect.size];
	[_startCap lockFocus];
	[image drawAtPoint:NSZeroPoint fromRect:startCapRect operation:NSCompositeSourceOver fraction:1.0];
	[_startCap unlockFocus];
	
	[_centerFill release];
	_centerFill = [[NSImage alloc] initWithSize:centerFillRect.size];
	[_centerFill lockFocus];
	[image drawAtPoint:NSZeroPoint fromRect:centerFillRect operation:NSCompositeSourceOver fraction:1.0];
	[_centerFill unlockFocus];

	[_endCap release];
	_endCap = [[NSImage alloc] initWithSize:endCapRect.size];
	[_endCap lockFocus];
	[image drawAtPoint:NSZeroPoint fromRect:endCapRect operation:NSCompositeSourceOver fraction:1.0];
	[_endCap unlockFocus];
	
	
	[[self controlView] setNeedsDisplay:YES];
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView*)controlView
{
	CGFloat alpha = 1.0;
	
	if ([self isHighlighted]) {
		[[NSColor blackColor] set];
		NSRectFill(frame);
		alpha = 0.8;
	}

	NSDrawThreePartImage(frame, _startCap, _centerFill, _endCap, (leftCapWidth == 0), NSCompositeSourceOver, alpha, [controlView isFlipped]);	
}

- (NSRect)drawTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView*)controlView
{
	frame.origin.y += 1.0;	
	
	return [super drawTitle:title withFrame:frame inView:controlView];
}

@end
