//
//  SubviewTableViewCell.h
//
//  Created by John Chang on 2011-02-08.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


/*
 Example usage:
 
 - (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
 {
	 if ([cell isKindOfClass:[SubviewTableViewCell class]]) {	 
		 NSView *subview = [tableView SubviewTableViewCell_dequeueReusableSubviewForTableColumn:tableColumn row:row];
		 if (subview == nil) {
			 subview = [[[MySubview alloc] initWithFrame:NSZeroRect] autorelease];
		 }
 
		 ((SubviewTableViewCell *)cell).subview = subview;
		 [tableView SubviewTableViewCell_setReusableSubview:subview forTableColumn:tableColumn row:row];
	 }	
 }
 
 LIMITATIONS: Doesn't work with row ordering.
 
 */
@interface SubviewTableViewCell : NSTextFieldCell

@property(nonatomic, assign, readwrite) NSView *subview; // weak

@end


@interface NSTableView (SubviewTableViewCell)

- (void)SubviewTableViewCell_setReusableSubview:(NSView *)subview forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (NSView *)SubviewTableViewCell_dequeueReusableSubviewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
