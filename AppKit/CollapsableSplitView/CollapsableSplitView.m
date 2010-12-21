//
//  CollapsableSplitView.m
//
//  Created by John Chang on 2005-10-13.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "CollapsableSplitView.h"


@implementation CollapsableSplitView

- (void)commonInit
{
	_collapsedSubviewsDict = [[NSMutableDictionary alloc] init];
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

- (void)dealloc
{
	[_collapsedSubviewsDict release];
	[super dealloc];
}


- (void)drawDividerInRect:(NSRect)aRect	// XXX: doesn't really belong here
{
	if ([_collapsedSubviewsDict count] > 0) {
		BOOL isVertical = [self isVertical];

		NSEnumerator *keyEnumerator = [_collapsedSubviewsDict keyEnumerator];
		id key;
		while ((key = [keyEnumerator nextObject])) {
			NSView *dummyView = [key pointerValue];
			
			// If the collapsed placeholder view has now been resized by the user
			// to the extent that it should be uncollapsed (i.e. expanded) ...
			NSSize size = [dummyView frame].size;
			if ((isVertical && size.width > 0.0) || (isVertical == NO && size.height > 0.0)) {
				// Swap in subview
				NSView *origSubview = [_collapsedSubviewsDict objectForKey:key];
				[origSubview setFrameSize:size];
				[self replaceSubview:dummyView with:origSubview];
				[_collapsedSubviewsDict removeObjectForKey:key];
			}
		}
	}
	
	[super drawDividerInRect:aRect];
}

- (void)collapseSubviewAt:(int)offset
{
	NSView *subview = [[self subviews] objectAtIndex:offset];
	NSView *dummyView = [[NSView alloc] initWithFrame:NSZeroRect];

	// Swap out subview
	id key = [NSValue valueWithPointer:dummyView];
	[_collapsedSubviewsDict setObject:subview forKey:key];
	[self replaceSubview:subview with:dummyView];
	[self adjustSubviews];
	
	[dummyView release];
}

@end
