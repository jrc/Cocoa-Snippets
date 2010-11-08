//
//  TableColumnDateFormatter.m
//
//  Created by John Chang on 2007-06-07.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "TableColumnDateFormatter.h"


@implementation TableColumnDateFormatter

- (void)_setupDateFormatArrays
{
	NSString *dateTimeFormat = NSLocalizedStringFromTable(@"DATE_TIME", @"TableColumnDateFormatter", nil);
	
	/*
		3/21/01
		3/21/01, 12:34 PM
		Mar 21, 2001, 12:34 PM
		March 21, 2001, 12:34 PM
		Wednesday, March 21, 2001, 12:34 PM
	*/
	_dateFormats = [[NSMutableArray alloc] init];

	[_dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[(NSMutableArray *)_dateFormats addObject:[_dateFormatter dateFormat]];

	NSDateFormatterStyle dateStyle;
	for (dateStyle = NSDateFormatterShortStyle; dateStyle <= NSDateFormatterFullStyle; dateStyle++) {
		[_dateFormatter setDateStyle:dateStyle];

		NSString *format = [NSString stringWithFormat:dateTimeFormat, [_dateFormatter dateFormat], [_timeFormatter dateFormat]];
		[(NSMutableArray *)_dateFormats addObject:format];
	}
	
	/*
		Yesterday
		Yesterday, 12:34 PM
	*/
	_relativeDateFormats = [[NSMutableArray alloc] init];	
	NSString *relativeDateFormat = @"'%@'";

	[(NSMutableArray *)_relativeDateFormats addObject:relativeDateFormat];

	NSString *format = [NSString stringWithFormat:dateTimeFormat, relativeDateFormat, [_timeFormatter dateFormat]];
	[(NSMutableArray *)_relativeDateFormats addObject:format];
}

- (id)init
{
	if ((self = [super init])) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[_dateFormatter setTimeStyle:NSDateFormatterNoStyle];

		_timeFormatter = [[NSDateFormatter alloc] init];
		[_timeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[_timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[_timeFormatter setTimeStyle:NSDateFormatterShortStyle];		

		[self _setupDateFormatArrays];
	}
	return self;
}

- (void)dealloc
{
	[_dateFormatter release];
	[_timeFormatter release];
	
	[_dateFormats release];
	[_relativeDateFormats release];

	[_tableColumn release];

	[super dealloc];
}


- (void)setTableColumn:(NSTableColumn *)tableColumn
{
	[[tableColumn dataCell] setFormatter:nil];
	[_tableColumn release];
	
	_tableColumn = [tableColumn retain];
	[[tableColumn dataCell] setFormatter:self];
	[[tableColumn dataCell] setLineBreakMode:NSLineBreakByTruncatingMiddle];
}


- (NSString *)stringForObjectValue:(id)anObject
{
    if (![anObject isKindOfClass:[NSDate class]])
        return nil;

    return [_dateFormatter stringForObjectValue:anObject];
}


- (NSString *)_relativeDayDesignationForDate:(NSDate *)date
{
	NSCalendarDate *nowCalendarDate = [NSCalendarDate calendarDate];

	NSCalendarDate *todayCalendarDate = [NSCalendarDate dateWithYear:[nowCalendarDate yearOfCommonEra]
		month:[nowCalendarDate monthOfYear] day:[nowCalendarDate dayOfMonth] hour:0 minute:0 second:0 timeZone:nil];
	if ([date compare:todayCalendarDate] >= NSOrderedSame) {
		// NSThisDayDesignations isn't actually localized
		return NSLocalizedStringFromTable(@"TODAY", @"TableColumnDateFormatter", nil);
	}
	
	NSDate *yesterdayCalendarDate = [todayCalendarDate addTimeInterval:-60*60*24];
	if ([date compare:yesterdayCalendarDate] >= NSOrderedSame) {
		// NSPriorDayDesignations isn't actually localized
		return NSLocalizedStringFromTable(@"YESTERDAY", @"TableColumnDateFormatter", nil);
	}
	
	return nil;
}

- (NSString *)_stringByFittingDate:(NSDate *)date maxWidth:(float)maxWidth attributes:(NSDictionary *)attributes
{
	NSString *relativeDayDesignation = [self _relativeDayDesignationForDate:date];

	NSArray *dateFormatArray = (relativeDayDesignation ? _relativeDateFormats : _dateFormats);

	// Try growing the date and time until it doesn't fit anymore
	int i, count = [dateFormatArray count];
	for (i=0; i<count; i++) {
		NSString *dateFormat = [dateFormatArray objectAtIndex:i];
		if (relativeDayDesignation)
			dateFormat = [NSString stringWithFormat:dateFormat, relativeDayDesignation];
		[_dateFormatter setDateFormat:dateFormat];
		
		NSString *string = [_dateFormatter stringForObjectValue:date];
		NSSize stringSize = [string sizeWithAttributes:attributes];
		if (stringSize.width > maxWidth) {
			if (i > 0)
			{
				NSString *dateFormat = [dateFormatArray objectAtIndex:i-1];
				if (relativeDayDesignation)
					dateFormat = [NSString stringWithFormat:dateFormat, relativeDayDesignation];
				[_dateFormatter setDateFormat:dateFormat];
			}
			break;
		}
	}

	return [self stringForObjectValue:date];
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes
{
    if (![anObject isKindOfClass:[NSDate class]])
        return nil;

    if (_tableColumn == nil)
        return nil;

	// Get the current width of the text area
	NSTableView *tableView = [_tableColumn tableView];
	int columnIndex = [[tableView tableColumns] indexOfObject:_tableColumn];
	NSRect titleRect = [[_tableColumn dataCell] titleRectForBounds:[tableView rectOfColumn:columnIndex]];
	float width = titleRect.size.width - 3.0;

	NSString *string = [self _stringByFittingDate:anObject maxWidth:width attributes:attributes];
	return [[[NSAttributedString alloc] initWithString:string attributes:attributes] autorelease];
}

@end
