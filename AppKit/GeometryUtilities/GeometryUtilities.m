//
//  GeometryUtilities.m
//
//  Created by John Chang on 2011-02-08.
//  This code is Creative Commons Public Domain.  You may use it for any purpose whatsoever.
//  http://creativecommons.org/licenses/publicdomain/
//

#import "GeometryUtilities.h"


NSRect CenterRectInRect(NSRect rect, NSRect containerRect)
{
	rect.origin.x = NSMinX(containerRect) + round((NSWidth(containerRect) - NSWidth(rect)) * 0.5);
	rect.origin.y = NSMinY(containerRect) + round((NSHeight(containerRect) - NSHeight(rect)) * 0.5);
	return rect;
}
