//
//  GrowableTextField.m
//
//  Created by John Chang on 2010-12-18.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "GrowableTextField.h"


@implementation GrowableTextField

@synthesize maxHeight;

- (void)commonInit
{
	maxHeight = 10000; // same as generic -[NSCell cellSize]
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self commonInit];
    }
    return self;
}

- (void)sizeToFit
{
	NSRect constrainingRect = [[self cell] titleRectForBounds:[self bounds]];
	constrainingRect.size.height = maxHeight;
	
	// Calculate the new cell height
	[[self cell] stringValue]; // necessary for -cellSizeForBounds: to use with the new string
	NSSize cellSize = [[self cell] cellSizeForBounds:constrainingRect];
	
	// Grow the control vertically
	NSRect frame = [self frame];
	CGFloat deltaY = NSHeight(frame) - cellSize.height;
	frame.size.height = cellSize.height;
	frame.origin.y += deltaY;
	[self setFrame:frame];
}

- (void)setObjectValue:(id<NSCopying>)obj // called via bindings
{
	// load, then resize
	[super setObjectValue:obj];	
	[self sizeToFit];
}

- (void)textDidChange:(NSNotification *)notification
{
	// resize first, then notify
	[self sizeToFit];	
	[super textDidChange:notification];
}

@end