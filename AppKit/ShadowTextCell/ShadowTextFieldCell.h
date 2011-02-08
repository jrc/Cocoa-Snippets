//
//  ShadowTextFieldCell.h
//
//  Created by John Chang on 2011-02-01.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


/*
 In same cases, NSBackgroundStyleRaised / NSBackgroundStyleLowered can be used instead.
 */
@interface ShadowTextFieldCell : NSTextFieldCell {
	NSShadow *shadow;
}

@property(nonatomic,retain) NSShadow *shadow;

@end
