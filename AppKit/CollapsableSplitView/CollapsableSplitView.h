//
//  CollapsableSplitView.h
//
//  Created by John Chang on 2005-10-13.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


/*
 Subclass of NSSplitView that adds a method to programmatically collapse a subview.
 
 Normally, a subview is effectively "collapsable" by setting it to zero height/width,
 but if it has autoresizable content, the normal Cocoa behavior screws up the content sizes at zero.
 */
@interface CollapsableSplitView : NSSplitView {
	NSMutableDictionary *_collapsedSubviewsDict;
}

- (void)collapseSubviewAt:(int)offset;

@end
