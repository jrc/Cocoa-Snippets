//
//  GrowableTextField.m
//
//  Created by John Chang on 2011-02-09.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "GrowableTextField.h"


@implementation GrowableTextField

@synthesize minSize, maxSize;

- (void)commonInit
{
    minSize = [self bounds].size;
    maxSize = [self bounds].size;
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
        
        // Allow subclasses to set minSize/maxSize before calling -sizeToFit
        if ([[self stringValue] length] > 0) {
            [self performSelector:@selector(sizeToFit) withObject:nil afterDelay:0.0];
        }
    }
    return self;
}

- (void)sizeToFit
{
	NSRect constrainingRect = [[self cell] titleRectForBounds:[self bounds]];
	constrainingRect.size.height = maxSize.height;
    constrainingRect.size.width = maxSize.width;
	
	// Calculate the new cell size
	[[self cell] stringValue]; // necessary for -cellSizeForBounds: to use with the new string
	NSSize cellSize = [[self cell] cellSizeForBounds:constrainingRect];
	
    // Constrain the cell size to the max/min properties
    cellSize.height = MIN(MAX(cellSize.height, minSize.height), maxSize.height);
    cellSize.width = MIN(MAX(cellSize.width, minSize.width), maxSize.width);
    
	// Grow the control vertically+horizontally
	NSRect frame = [self frame];
	CGFloat deltaX = NSWidth(frame) - cellSize.width;
	CGFloat deltaY = NSHeight(frame) - cellSize.height;
	frame.size.width = cellSize.width;
	frame.size.height = cellSize.height;
    if ([self alignment] == NSRightTextAlignment) {
        frame.origin.x += deltaX;
    }
    else if ([self alignment] == NSCenterTextAlignment) {
        frame.origin.x += round(deltaX * 0.5);
    }
	frame.origin.y += deltaY; // grow downwards
	[self setFrame:frame];
}

- (void)setObjectValue:(id<NSCopying>)obj // called via bindings
{
	// load, then resize using new value
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
