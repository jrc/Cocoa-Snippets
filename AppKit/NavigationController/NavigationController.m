//
//  NavigationController.m
//
//  Created by John Chang on 2010-11-09.
//  Copyright 2010 Barefoot Hackers AB. All rights reserved.
//

#import "NavigationController.h"

#import <objc/runtime.h>


@interface NavigationController ()
// sends -viewWillDisappear:
- (void)_startDetachingViewController:(NSViewController *)viewController animated:(BOOL)animated;
// removes view from superview, sends -viewDidDisappear:
- (void)_finishDetachingViewController:(NSViewController *)viewController animated:(BOOL)animated;

// loads view, sends -viewWillAppear:, and adds view to superview
- (void)_startAttachingViewController:(NSViewController *)viewController animated:(BOOL)animated;
// sends -viewDidAppear:, fixes up responder chain and key view loop
- (void)_finishAttachingViewController:(NSViewController *)viewController animated:(BOOL)animated;
@end


#pragma mark -

@implementation NavigationController

- (id)initWithRootViewController:(NSViewController *)viewController
{
	self = [super init];
	if (self != nil) {
		viewControllers = [[NSMutableArray alloc] initWithObjects:viewController, nil];
	}
	return self;
}

- (void)dealloc
{
	[self _startDetachingViewController:[viewControllers lastObject] animated:NO];
	[self _finishDetachingViewController:[viewControllers lastObject] animated:NO];
	[viewControllers release];
	[super dealloc];
}


- (void)setView:(NSView *)theView
{
	[super setView:theView];

	if (theView) {
		// Insert this controller into the responder chain, after the view
		[self setNextResponder:[theView nextResponder]];
		[theView setNextResponder:self];

		// Add top view controller
		[self _startAttachingViewController:[viewControllers lastObject] animated:NO];	
		[self _finishAttachingViewController:[viewControllers lastObject] animated:NO];	
	}
}


@synthesize viewControllers;


#pragma mark Debugging

#if DEBUG
void LogResponderChainFromResponder(NSResponder *r)
{
	NSLog(@"%s()", __func__);
	while (r) {
		NSLog(@"* %@", r);
		r = [r nextResponder];
	}
}

void LogKeyViewChainFromView(NSView *v)
{
	NSLog(@"%s(%@)", __func__, v);
	v = [v nextValidKeyView];
	NSView *view = v;
	while (view) {
		NSLog(@"* %@", view);
		view = [view nextValidKeyView];
		if (view == v)
			break;
	}
}
#endif


#pragma mark Implementing Pushing and Popping

static NSString *kNavigationControllerKey = @"NavigationControllerKey";

- (void)_startDetachingViewController:(NSViewController *)viewController animated:(BOOL)animated
{
	[viewController viewWillDisappear:animated]; // callback
}

- (void)_finishDetachingViewController:(NSViewController *)viewController animated:(BOOL)animated
{
	// detach subview
	[[viewController view] removeFromSuperview];

	// clear viewController.navigationController reference
	objc_setAssociatedObject(viewController, &kNavigationControllerKey, nil, OBJC_ASSOCIATION_ASSIGN);

	[viewController viewDidDisappear:animated]; // callback
}

- (void)_startAttachingViewController:(NSViewController *)viewController animated:(BOOL)animated
{
	// Load the new view
	[viewController loadView];
		
	// set viewController.navigationController reference
	objc_setAssociatedObject(viewController, &kNavigationControllerKey, self, OBJC_ASSOCIATION_ASSIGN);
	
	[viewController viewDidLoad]; // callback
	
	[viewController viewWillAppear:YES]; // callback
	
	// resize subview
	NSView *subview = [viewController view];
	[subview setFrame:[[self view] bounds]];
	NSUInteger autoresizingMask = [subview autoresizingMask];
	autoresizingMask %= NSViewMaxYMargin; // upper margin is fixed for toolbar
	[subview setAutoresizingMask:autoresizingMask];
	
	// attach subview
	[[self view] addSubview:subview];	
}

- (void)_finishAttachingViewController:(NSViewController *)viewController animated:(BOOL)animated
{
	// Insert the view controller into the responder chain, after the view
	[viewController setNextResponder:[[viewController view] nextResponder]];
	[[viewController view] setNextResponder:viewController];

	[[[self view] window] setInitialFirstResponder:[viewController view]];
	[[[self view] window] recalculateKeyViewLoop];

	[viewController viewDidAppear:YES]; // callback	
	
	//LogResponderChainFromResponder([[[self view] window] initialFirstResponder]);
}


- (void)pushViewController:(NSViewController *)viewController usingAnimationFromBlock:(NSAnimation *(^)(NSView *disappearingView))animationBlock
{
	_disappearingViewController = [[viewControllers lastObject] retain];
	
	[self _startDetachingViewController:_disappearingViewController animated:(animationBlock != NULL)];
	[viewControllers addObject:viewController];
	[self _startAttachingViewController:viewController animated:(animationBlock != NULL)];
		
	// At this point, viewController is now loaded and on-screen
	
	if (animationBlock != NULL) {
		NSAnimation *animation = animationBlock([_disappearingViewController view]);
		animation.delegate = self;
		if (([[NSApp currentEvent] type] != NSKeyUp) && ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask))
			[animation setDuration:(5.0/0.3 * [animation duration])]; // Slo-mo
		[animation startAnimation];		
	}
	else {
		[self animationDidEnd:nil];
	}	
}

- (NSViewController *)popViewControllerUsingAnimationFromBlock:(NSAnimation *(^)(NSView *appearingView))animationBlock
{
	_disappearingViewController = [[viewControllers lastObject] retain];
	NSViewController *poppedViewController = [[_disappearingViewController retain] autorelease];

	[self _startDetachingViewController:_disappearingViewController animated:(animationBlock != NULL)];
	[viewControllers removeObject:_disappearingViewController];
	[self _startAttachingViewController:[viewControllers lastObject] animated:(animationBlock != NULL)];
	
	if (animationBlock != NULL) {
		NSAnimation *animation = animationBlock([poppedViewController view]);
		animation.delegate = self;
		if (([[NSApp currentEvent] type] != NSKeyUp) && ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask))
			[animation setDuration:(5.0/0.3 * [animation duration])]; // Slo-mo
		[animation startAnimation];		
	}
	else {
		[self animationDidEnd:nil];
	}
	
	return poppedViewController;
}

- (NSArray *)popToRootViewControllerUsingAnimationFromBlock:(NSAnimation *(^)(NSView *appearingView))animationBlock
{
	_disappearingViewController = [[viewControllers lastObject] retain];
	NSArray *poppedViewControllers = [viewControllers subarrayWithRange:NSMakeRange(1, [viewControllers count]-1)];
	
	[self _startDetachingViewController:_disappearingViewController animated:(animationBlock != NULL)];
	[viewControllers removeObjectsInArray:poppedViewControllers];
	[self _startAttachingViewController:[viewControllers lastObject] animated:(animationBlock != NULL)];
	
	if (animationBlock != NULL) {
		NSAnimation *animation = animationBlock([[viewControllers lastObject] view]);
		animation.delegate = self;
		if (([[NSApp currentEvent] type] != NSKeyUp) && ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask))
			[animation setDuration:(5.0/0.3 * [animation duration])]; // Slo-mo
		[animation startAnimation];		
	}
	else {
		[self animationDidEnd:nil];
	}
	
	return poppedViewControllers;
}

- (void)pushViewController:(NSViewController *)viewController animated:(BOOL)animated
{
	[self pushViewController:viewController usingAnimationFromBlock:NULL];
}

- (NSViewController *)popViewControllerAnimated:(BOOL)animated
{
	return [self popViewControllerUsingAnimationFromBlock:NULL];
}


#pragma mark <NSAnimationDelegate>

- (void)animationDidEnd:(NSAnimation *)animation
{
	[self _finishDetachingViewController:_disappearingViewController animated:(animation != nil)];
	[_disappearingViewController release];
	_disappearingViewController = nil;
	
	[self _finishAttachingViewController:[viewControllers lastObject] animated:(animation != nil)];
	
	// Clear the undo/redo stacks when changing view to prevent the
	// user from undoing actions performed in a different view
	// Do this after the current run loop iteration is finished to
	// handle delayed action registrations
	[[self undoManager] performSelector:@selector(removeAllActions) withObject:nil afterDelay:0.0];
}

@end


#pragma mark -

@implementation NSViewController (MainWindowController)

- (void)viewDidLoad {
	// do nothing
}

- (void)viewWillAppear:(BOOL)animated {
	// do nothing
}

- (void)viewDidAppear:(BOOL)animated {
	// do nothing
}

- (void)viewWillDisappear:(BOOL)animated {
	// do nothing
}

- (void)viewDidDisappear:(BOOL)animated {
	// do nothing
}


- (NavigationController *)navigationController {
	return objc_getAssociatedObject(self, &kNavigationControllerKey);
}

@end
