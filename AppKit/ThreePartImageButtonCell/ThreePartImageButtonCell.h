//
//  ThreePartImageButtonCell.h
//
//  Created by John Chang on 2010-11-07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


/*
 Subclass of NSButtonCell that draws three-part images.
 
 See Apple documentation on "Drawing Resizable Textures Using Images" in the Cocoa Drawing Guide
 as well as the NSDrawThreePartImage() function in the Application Kit Functions Reference for more info.
 http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaDrawingGuide/Images/Images.html
 
 This class supports leftCapWidth or topCapHeight but not both.
 Like UIImage, the middle (stretchable) portion is assumed to be 1 pixel wide.
 */
@interface ThreePartImageButtonCell : NSButtonCell {
	NSInteger leftCapWidth, topCapHeight;
	
	NSImage *_startCap, *_centerFill, *_endCap;
}

- (void)setStretchableImage:(NSImage *)image leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;

@property(nonatomic, readonly) NSInteger leftCapWidth, topCapHeight;

@end
