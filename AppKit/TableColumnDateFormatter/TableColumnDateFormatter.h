//
//  TableColumnDateFormatter.h
//
//  Created by John Chang on 2007-06-07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import <Cocoa/Cocoa.h>


/*
 Have you ever noticed how Finder treats dates in list view?
 If the column is wide enough, the date is displayed in a nice long format:
 
	Wednesday, January 3, 2007, 12:34 PM
 
 As the table column is resized, the date is dynamically reformatted to fit in the available width:
 
	 Wednesday, January 3, 2007, 12:34 PM
	 January 3, 2007, 12:34 PM
	 Jan 3, 2007, 12:34 PM
	 1/3/07, 12:34 PM
	 1/3/07
 
 It also displays relative date strings if the date is recent enough:
 
	 Today, 12:34 PM
	 Yesterday, 12:34 PM
 
 This level of craftsmanship and attention to detail is what made the classic Macintosh Finder so respected and loved.
 It’s nice that this behavior has been carried over to the Mac OS X Finder.
 
 Unfortunately, the standard Cocoa classes don’t give you this for free.
 TableColumnDateFormatter is a subclass of NSDateFormatter which implements similar behavior.

 Usage:
	- (void)awakeFromNib
	{
		NSTableColumn *tableColumn = [tableView tableColumnWithIdentifier:@"foo"];
 
		TableColumnDateFormatter *df = [[TableColumnDateFormatter alloc] init];
		[df setTableColumn:tableColumn];
		[df release];
	}
 */
@interface TableColumnDateFormatter : NSFormatter {	
	NSDateFormatter *_dateFormatter, *_timeFormatter;
	NSArray *_dateFormats, *_relativeDateFormats;

	NSTableColumn *_tableColumn;
}

- (id)init;

- (void)setTableColumn:(NSTableColumn *)tableColumn;

@end
