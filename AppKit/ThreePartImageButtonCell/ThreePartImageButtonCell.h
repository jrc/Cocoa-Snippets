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
 */
@interface ThreePartImageButtonCell : NSButtonCell {
	NSImage *startCap, *centerFill, *endCap;
	NSImage *highlightedStartCap, *highlightedCenterFill, *highlightedEndCap;
}

@property(nonatomic, retain) NSImage *startCap, *centerFill, *endCap;
@property(nonatomic, retain) NSImage *highlightedStartCap, *highlightedCenterFill, *highlightedEndCap;

@end


@interface ThreePartImageButtonCell (ImageCutting)
/*
 This implementation supports leftCapWidth or topCapHeight but not both.
 Like UIImage, the middle (stretchable) portion is assumed to be 1 pixel wide.
 */
- (void)setStretchableImage:(NSImage *)image leftCapWidth:(NSInteger)left topCapHeight:(NSInteger)top;
@end
