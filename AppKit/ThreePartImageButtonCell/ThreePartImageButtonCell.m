//
//  ThreePartImageButtonCell.m
//
//  Created by John Chang on 2010-11-07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "ThreePartImageButtonCell.h"


@implementation ThreePartImageButtonCell

@synthesize startCap, centerFill, endCap;
@synthesize highlightedStartCap, highlightedCenterFill, highlightedEndCap;


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
	[startCap release];
	[centerFill release];
	[endCap release];

	[highlightedStartCap release];
	[highlightedCenterFill release];
	[highlightedEndCap release];
	
	[super dealloc];
}


- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView*)controlView
{	
	// Use alternate (highlighted) button parts if available
	if ([self isHighlighted] && highlightedStartCap && highlightedCenterFill && highlightedEndCap) {
		NSDrawThreePartImage(frame, highlightedStartCap, highlightedCenterFill, highlightedEndCap, ([highlightedCenterFill size].height == 1.0), NSCompositeSourceOver, 1.0, [controlView isFlipped]);
		return;
	}
	
	CGFloat alpha = 1.0;
	if ([self isHighlighted]) {
		[[NSColor blackColor] set];
		NSRectFill(frame);
		
		alpha = 0.8;
	}
	NSDrawThreePartImage(frame, startCap, centerFill, endCap, ([centerFill size].height == 1.0), NSCompositeSourceOver, alpha, [controlView isFlipped]);	
}

//- (NSRect)drawTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView*)controlView
//{
//	frame.origin.y += 2.0;	
//	
//	return [super drawTitle:title withFrame:frame inView:controlView];
//}

@end


@implementation ThreePartImageButtonCell (ImageCutting)

- (void)setStretchableImage:(NSImage *)image leftCapWidth:(NSInteger)left topCapHeight:(NSInteger)top
{
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
	[startCap release];
	startCap = [[NSImage alloc] initWithSize:startCapRect.size];
	[startCap lockFocus];
	[image drawAtPoint:NSZeroPoint fromRect:startCapRect operation:NSCompositeSourceOver fraction:1.0];
	[startCap unlockFocus];
	
	[centerFill release];
	centerFill = [[NSImage alloc] initWithSize:centerFillRect.size];
	[centerFill lockFocus];
	[image drawAtPoint:NSZeroPoint fromRect:centerFillRect operation:NSCompositeSourceOver fraction:1.0];
	[centerFill unlockFocus];
	
	[endCap release];
	endCap = [[NSImage alloc] initWithSize:endCapRect.size];
	[endCap lockFocus];
	[image drawAtPoint:NSZeroPoint fromRect:endCapRect operation:NSCompositeSourceOver fraction:1.0];
	[endCap unlockFocus];
	
	[[self controlView] setNeedsDisplay:YES];
}

@end
