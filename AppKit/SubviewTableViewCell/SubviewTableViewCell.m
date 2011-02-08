//
//  SubviewTableViewCell.m
//
//  Created by John Chang on 2011-02-08.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "SubviewTableViewCell.h"

#include <objc/runtime.h>


@implementation SubviewTableViewCell

@synthesize subview;

/*
 The Subview-TableView <http://www.joar.com/code/>
 NSCell with Embedded NSView <http://lists.apple.com/archives/cocoa-dev/2006/Apr/msg00380.html>
 NSView inside NSCell <http://www.omnigroup.com/mailman/archive/macosx-dev/2004-September/054363.html>
 */
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
    if ([subview superview] != controlView) {
		[subview setFrame:cellFrame];
		[controlView addSubview:subview];
    }
	
	[subview setNeedsDisplay:YES];
}

@end


@implementation NSTableView (SubviewTableViewCell)

static NSString *const kSubviewTableViewCellFrameToReusableSubviewDictionaryKey = @"kSubviewTableViewCellFrameToReusableSubviewDictionaryKey";

- (NSMutableDictionary *)SubviewTableViewCell_cellFrameToReusableSubviewDictionaryForTableColumn:(NSTableColumn *)tableColumn
{
	id dictionary = objc_getAssociatedObject(tableColumn, kSubviewTableViewCellFrameToReusableSubviewDictionaryKey);
	if (dictionary == nil) {
		dictionary = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(tableColumn, kSubviewTableViewCellFrameToReusableSubviewDictionaryKey, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return dictionary;
}


- (void)SubviewTableViewCell_setReusableSubview:(NSView *)subview forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSMutableDictionary *cellFrameToReusableSubviewDictionary = [self SubviewTableViewCell_cellFrameToReusableSubviewDictionaryForTableColumn:tableColumn];

	// Cache this subview
	NSTableView *tableView = [tableColumn tableView];
	NSRect cellFrame = [tableView frameOfCellAtColumn:[[tableView tableColumns] indexOfObject:tableColumn] row:row];
	[cellFrameToReusableSubviewDictionary setObject:subview forKey:[NSValue valueWithRect:cellFrame]];
	
	// Collect unused subviews
	NSMutableArray *unusedKeys = [NSMutableArray array];
	for (NSValue *key in [cellFrameToReusableSubviewDictionary allKeys]) {
		NSRect rect = [key rectValue];
		if (NSIntersectsRect(rect, [tableView visibleRect]) == NO) {
			[unusedKeys addObject:key];
		}
	}
	
	// Remove and release the unused subviews
	for (NSValue *key in unusedKeys) {
		NSView *subview = [cellFrameToReusableSubviewDictionary objectForKey:key];
		[subview removeFromSuperview];
	}
	[cellFrameToReusableSubviewDictionary removeObjectsForKeys:unusedKeys];
}

- (NSView *)SubviewTableViewCell_dequeueReusableSubviewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSMutableDictionary *cellFrameToReusableSubviewDictionary = [self SubviewTableViewCell_cellFrameToReusableSubviewDictionaryForTableColumn:tableColumn];
	
	// If already visible, return it
	NSTableView *tableView = [tableColumn tableView];
	NSRect cellFrame = [tableView frameOfCellAtColumn:[[tableView tableColumns] indexOfObject:tableColumn] row:row];
	NSView *subview = [cellFrameToReusableSubviewDictionary objectForKey:[NSValue valueWithRect:cellFrame]];
	if (subview)
		return subview;
	
	// Look for a non-used subview
	for (NSValue *key in [cellFrameToReusableSubviewDictionary allKeys]) {
		subview = [cellFrameToReusableSubviewDictionary objectForKey:key];
		if (NSIsEmptyRect([subview visibleRect])) {
			return subview;
		}
	}
	
	return nil;
}

@end
