//
//  NinePartFramedImageCell.h
//
//  Created by John Chang on 2011-02-07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


@interface NinePartFramedImageCell : NSImageCell {

}

@property(nonatomic, retain, readwrite) NSImage *topLeftCornerImage, *topEdgeFillImage, *topRightCornerImage;
@property(nonatomic, retain, readwrite) NSImage *leftEdgeFillImage, *rightEdgeFillImage;
@property(nonatomic, retain, readwrite) NSImage *bottomLeftCornerImage, *bottomEdgeFillImage, *bottomRightCornerImage;

@end
