//
//  NavigationController.h
//
//  Created by John Chang on 2010-11-09.
//  Copyright 2010 Barefoot Hackers AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/*
 Like UINavigationController, but NSViewController-based.
 */
@interface NavigationController : NSViewController <NSAnimationDelegate> {
	NSMutableArray *viewControllers;
	NSViewController *_disappearingViewController; // weak
}

@property(nonatomic, copy) NSArray *viewControllers;

- (id)initWithRootViewController:(NSViewController *)viewController;

- (void)pushViewController:(NSViewController *)viewController usingAnimationFromBlock:(NSAnimation *(^)(NSView *disappearingView))animationBlock;
- (NSViewController *)popViewControllerUsingAnimationFromBlock:(NSAnimation *(^)(NSView *appearingView))animationBlock;

- (NSArray *)popToRootViewControllerUsingAnimationFromBlock:(NSAnimation *(^)(NSView *appearingView))animationBlock;

// animated=YES is not implemented
- (void)pushViewController:(NSViewController *)viewController animated:(BOOL)animated;
- (NSViewController *)popViewControllerAnimated:(BOOL)animated;

@end


@interface NSViewController (NavigationController)

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

@property(nonatomic,readonly,retain) NavigationController *navigationController;

@end


#if DEBUG
// e.g. LogResponderChainFromResponder([[[self view] window] initialFirstResponder])
void LogResponderChainFromResponder(NSResponder *r);
void LogKeyViewChainFromView(NSView *v);
#endif
