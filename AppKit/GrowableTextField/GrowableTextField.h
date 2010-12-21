//
//  GrowableTextField.h
//  TextFieldTest
//
//  Created by John Chang on 2010-12-18.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


@interface GrowableTextField : NSTextField {
	CGFloat maxHeight;
}

@property CGFloat maxHeight;

@end
