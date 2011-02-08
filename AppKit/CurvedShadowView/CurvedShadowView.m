//
//  CurvedShadowView.m
//
//  Created by John Chang on 2010-11-11.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "CurvedShadowView.h"


// shadow appearance
const CGFloat kCurvedShadowViewShadowBlurRadius = 10.0;
const CGFloat kCurvedShadowViewShadowOffsetY = -4.0;

// curvature shape
const CGFloat kCurvedShadowViewCurveHeight = 8.0;
const CGFloat kCurvedShadowViewCurveInsetX = 10.0;


@implementation CurvedShadowView

@synthesize borderThickness;
@synthesize borderColor;

- (NSRect)contentRect
{
	return NSInsetRect([self bounds], 10.0, -kCurvedShadowViewShadowOffsetY + kCurvedShadowViewShadowBlurRadius);
}


- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	if (self != nil) {
		borderThickness = 4.0;
		borderColor = [NSColor darkGrayColor];
	}
	return self;
}

- (void) dealloc
{
	[borderColor release];
	[super dealloc];
}


@synthesize contentView;

- (void)setContentView:(NSView *)view
{
	[contentView removeFromSuperview];
	
	if (view) {
		NSRect rect = NSInsetRect([self contentRect], borderThickness, borderThickness);
		[view setFrame:rect];
		
		[self addSubview:view];
	}
	
	contentView = view;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect contentRect = [self contentRect];
	
	[NSGraphicsContext saveGraphicsState];
		
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowOffset:NSMakeSize(0, kCurvedShadowViewShadowOffsetY)];
	[shadow setShadowBlurRadius:kCurvedShadowViewShadowBlurRadius];
	[shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.6]];
	[shadow set];
	
	NSRect shadowRect = NSInsetRect(contentRect, kCurvedShadowViewCurveInsetX, 0);
	shadowRect.size.height = kCurvedShadowViewCurveHeight*2;

	NSBezierPath *bezierPath = [NSBezierPath bezierPath];
	[bezierPath moveToPoint:NSMakePoint(NSMinX(shadowRect), NSMaxY(shadowRect))];
	[bezierPath lineToPoint:NSMakePoint(NSMaxX(shadowRect), NSMaxY(shadowRect))];
	[bezierPath lineToPoint:NSMakePoint(NSMaxX(shadowRect), NSMinY(shadowRect))];

	[bezierPath curveToPoint:NSMakePoint(NSMidX(shadowRect), NSMinY(shadowRect)+kCurvedShadowViewCurveHeight)
			   controlPoint1:NSMakePoint(NSMaxX(shadowRect) - NSMinX(shadowRect), NSMinY(shadowRect))
			   controlPoint2:NSMakePoint(NSMaxX(shadowRect) * 0.75, NSMinY(shadowRect)+kCurvedShadowViewCurveHeight)];

	[bezierPath curveToPoint:NSMakePoint(NSMinX(shadowRect), NSMinY(shadowRect))
				controlPoint1:NSMakePoint(NSMaxX(shadowRect) * 0.25, NSMinY(shadowRect)+kCurvedShadowViewCurveHeight)
				controlPoint2:NSMakePoint(NSMinX(shadowRect), NSMinY(shadowRect))];

	[bezierPath closePath];
	
	[[NSColor blackColor] set];
	[bezierPath fill];

	[NSGraphicsContext restoreGraphicsState];
	
	[[NSColor whiteColor] set];
	NSRectFill(contentRect);
	
	[borderColor set];
	NSFrameRect(contentRect);
}

@end
