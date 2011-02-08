//
//  CurvedShadowView.h
//
//  Created by John Chang on 2010-11-11.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


@interface CurvedShadowView : NSView {
	NSView *contentView; // weak
	
	CGFloat borderThickness;
	NSColor *borderColor;
}

@property(nonatomic, retain) NSView *contentView;

@property(nonatomic)			CGFloat borderThickness; // default is 4 px
@property(nonatomic, retain)	NSColor *borderColor; // default is +darkGrayColor

@end
