//
//  ShadowTextFieldCell.m
//
//  Created by John Chang on 2011-02-01.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "ShadowTextFieldCell.h"


@implementation ShadowTextFieldCell

- (id)copyWithZone:(NSZone *)zone
{
    ShadowTextFieldCell *cellCopy = [super copyWithZone:zone];
    cellCopy->shadow = nil; // "Unlike the instance variables that are created with alloc and init..., these uninitialized variables are not nil-valued"
	cellCopy->shadow = [shadow copyWithZone:zone];
    return cellCopy;
}

- (void) dealloc
{
	[shadow release];
	[super dealloc];
}

@synthesize shadow;

- (void)setShadow:(NSShadow *)theShadow
{
	[theShadow retain];
	[shadow release];
	shadow = theShadow;
	
	[self setTitle:[self title]]; // apply shadow now
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[shadow set];
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
