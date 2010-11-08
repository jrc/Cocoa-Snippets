//
//  IconTextFieldCell.h
//
//  Created by John Chang on Mon Jan 12 2004.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


/*
 Simple NSTextFieldCell subclass that supports an icon (like Finder list view).
 */
@interface IconTextFieldCell : NSTextFieldCell {
    NSImage *_image;
}

- (void)setImage:(NSImage *)image;
- (NSImage *)image;

@end
