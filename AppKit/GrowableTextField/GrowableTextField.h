//
//  GrowableTextField.h
//
//  Created by John Chang on 2011-02-09.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


@interface GrowableTextField : NSTextField

/*
 You need to set minSize and/or maxSize to enable dynamic growing.
 */
@property(nonatomic,readwrite) NSSize minSize, maxSize;

@end
