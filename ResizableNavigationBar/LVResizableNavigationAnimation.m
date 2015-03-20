//
//  LVResizableNavigationAnimation.m
//  Level Money
//
//  Created by Todd Anderson on 3/11/15.
//
//  ========================================================================
//  Copyright (c) 2015 Level Money Financial, Inc.
//  ------------------------------------------------------------------------
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Eclipse Public License v1.0
//
//      The Eclipse Public License is available at
//      http://www.eclipse.org/legal/epl-v10.html
//
//
//  You may elect to redistribute this code under this license.
//  ========================================================================
//

#import "LVResizableNavigationAnimation.h"
#import "LVResizableNavigationBar.h"
#import "LVResizableNavigationController.h"

@interface LVResizableNavigationAnimation () <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL pushing;

@end


@implementation LVResizableNavigationAnimation

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(LVResizableNavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        self.pushing = NO;
        return self;
    } else if (operation == UINavigationControllerOperationPush) {
        self.pushing = YES;
        return self;
    }
    return nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return LVAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    
    
    LVResizableNavigationBar *navBar = (id)toVC.navigationController.navigationBar;
    
    UIView *originalSubHeaderView = navBar.subHeaderView;
    UIView *newSubHeaderView;
    if ([toVC respondsToSelector:@selector(resizableNavigationBarControllerSubHeaderView)]) {
        id<LVResizableNavigationBarController> resizableVC = (id<LVResizableNavigationBarController>)toVC;
        newSubHeaderView = [resizableVC resizableNavigationBarControllerSubHeaderView];
    }
    navBar.subHeaderView = newSubHeaderView;
    
    CGFloat toVCNavHeight = LVNavigationBarHeight;
    
    if ([toVC respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarHeight)]) {
        id<LVResizableNavigationBarController> resizableVC = (id<LVResizableNavigationBarController>)toVC;
        toVCNavHeight = [resizableVC resizableNavigationBarControllerNavigationBarHeight];
    }
    
    UIColor *color = navBar.barTintColor;
    if ([toVC respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor)]) {
        color = [toVC performSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor) withObject:nil];
    }
    fromVC.navigationController.view.backgroundColor = navBar.barTintColor;
    
    CGFloat originalExtraHeight = navBar.extraHeight;
    navBar.extraHeight = toVCNavHeight - LVNavigationBarHeight;
    
    CGRect toVCStartFrame = toVC.view.frame;
    //adjust target view controller to left (pop) or to right (push) of current view controller
    toVCStartFrame.origin.x    = self.pushing ? toVCStartFrame.size.width : -(toVCStartFrame.size.width);
    toVCStartFrame.origin.y    = fromVC.view.frame.origin.y;
    toVCStartFrame.size.height = fromVC.view.frame.size.height;
    
    //calculate navigation bar frame
    CGRect navFrame      = navBar.frame;
    navFrame.origin.y    = LVStatusBarHeight - navBar.extraHeight;
    navFrame.size.height = toVCNavHeight;
    
    //target view controller final frame
    CGRect toVCEndFrame      = toVCStartFrame;
    toVCEndFrame.origin.x    = 0;
    toVCEndFrame.origin.y    = toVCNavHeight + LVStatusBarHeight;
    toVCEndFrame.size.height = toVC.navigationController.view.frame.size.height - toVCNavHeight - LVStatusBarHeight;
    
    if (navBar.translucent) {
        toVCStartFrame.origin.y    =
        toVCEndFrame.origin.y      = 0;
        toVCStartFrame.size.height =
        toVCEndFrame.size.height   = toVC.navigationController.view.frame.size.height;
    }
    
    toVC.view.frame = toVCStartFrame;
    
    CGRect startFrameForNewSubHeader = [self startNavBarSubHeaderFrameForExtraHeight:navBar.extraHeight originalHeight:originalExtraHeight toVC:toVC fromRight:self.pushing];
    [toVC.navigationController.view addSubview:newSubHeaderView];
    newSubHeaderView.frame = startFrameForNewSubHeader;
    
    //current view controller final frame to right (pop) or to left (push)
    CGRect fromVCEndFrame      = fromVC.view.frame;
    fromVCEndFrame.origin.x    = self.pushing ? -(fromVCEndFrame.size.width) : fromVCEndFrame.size.width;
    fromVCEndFrame.origin.y    = toVCEndFrame.origin.y;
    fromVCEndFrame.size.height = toVCEndFrame.size.height;
    
    

    

    
    CGRect endFrameForOldHeader = [self endNavBarSubHeaderFrameForOriginalHeight:originalExtraHeight extraHeight:navBar.extraHeight fromVC:fromVC toLeft:self.pushing];
    CGRect endFrameForNewSubHeader = [self endNavBarSubHeaderFrameForExtraHeight:navBar.extraHeight toVC:toVC];
    
    
    NSArray * leftItems    = toVC.navigationItem.leftBarButtonItems;
    NSArray * rightItems   = toVC.navigationItem.rightBarButtonItems;
    NSString * toTitle     = toVC.title;
    NSString * fromTitle   = fromVC.navigationItem.title;
    toVC.navigationItem.leftBarButtonItems = nil;
    toVC.navigationItem.rightBarButtonItems = nil;
    toVC.navigationItem.title = nil;
    toVC.title = nil;
    fromVC.navigationItem.title = nil;
    
    [UIView animateWithDuration:LVAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         originalSubHeaderView.frame = endFrameForOldHeader;
                         newSubHeaderView.frame      = endFrameForNewSubHeader;
                         //adjust colors
                         navBar.barTintColor                              = color;
                         [navBar sizeToFit];
                         //adjust frames
                         navBar.frame      = navFrame;
                         toVC.view.frame   = toVCEndFrame;
                         fromVC.view.frame = fromVCEndFrame;
                         
                     } completion:^(BOOL finished) {
                         //cleanup
                         [originalSubHeaderView removeFromSuperview];
                         [self setExtraHeightForViewController:toVC];
                         toVC.navigationItem.leftBarButtonItems = leftItems;
                         toVC.navigationItem.rightBarButtonItems = rightItems;
                         toVC.title = toTitle;
                         fromVC.title = fromTitle;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (void)setExtraHeightForViewController:(UIViewController *)viewController {
    CGFloat extraHeight = 0;
    if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarHeight)]) {
        id<LVResizableNavigationBarController> resizableVC = (id<LVResizableNavigationBarController>)viewController;
        CGFloat totalHeight = [resizableVC resizableNavigationBarControllerNavigationBarHeight];
        extraHeight = totalHeight - LVNavigationBarHeight;
    }
    LVResizableNavigationBar *navBar = (id)viewController.navigationController.navigationBar;
    navBar.extraHeight = extraHeight;
    [navBar sizeToFit];
}

- (UIView *)subHeaderForViewController:(UIViewController *)viewController {
    UIView *subHeaderView;
    if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerSubHeaderView)]) {
        subHeaderView = [viewController performSelector:@selector(resizableNavigationBarControllerSubHeaderView) withObject:nil];
    }
    return subHeaderView;
}

- (CGRect)endNavBarSubHeaderFrameForExtraHeight:(CGFloat)extraHeight toVC:(UIViewController *)toVC {
    CGRect toVCFrame = toVC.view.frame;
    CGRect targetFrame = CGRectZero;
    targetFrame.origin.x = 0;
    targetFrame.origin.y = LVNavigationBarHeight + LVStatusBarHeight;
    targetFrame.size.width = toVCFrame.size.width;
    targetFrame.size.height = extraHeight;
    return targetFrame;
}

- (CGRect)startNavBarSubHeaderFrameForExtraHeight:(CGFloat)extraHeight originalHeight:(CGFloat)originalHeight toVC:(UIViewController *)toVC fromRight:(BOOL)fromRight {
    CGRect toVCFrame = toVC.view.frame;
    CGRect targetFrame = CGRectZero;
    targetFrame.origin.x = fromRight ? toVCFrame.size.width : -(toVCFrame.size.width);
    targetFrame.origin.y = LVNavigationBarHeight + LVStatusBarHeight - (extraHeight - originalHeight);
    targetFrame.size.width = toVCFrame.size.width;
    targetFrame.size.height = extraHeight;
    return targetFrame;
}

- (CGRect)endNavBarSubHeaderFrameForOriginalHeight:(CGFloat)originalHeight extraHeight:(CGFloat)extraHeight fromVC:(UIViewController *)fromVC toLeft:(BOOL)toLeft {
    CGRect fromVCFrame = fromVC.view.frame;
    CGRect targetFrame = CGRectZero;
    targetFrame.origin.x = toLeft ? -(fromVCFrame.size.width) : fromVCFrame.size.width;
    targetFrame.origin.y = LVNavigationBarHeight + LVStatusBarHeight + (extraHeight - originalHeight);
    targetFrame.size.width = fromVCFrame.size.width;
    targetFrame.size.height = originalHeight;
    return targetFrame;
}

- (CGRect)startNavBarSubHeaderFrameForExtraHeight:(CGFloat)extraHeight fromVC:(UIViewController *)fromVC {
    CGRect fromVCFrame = fromVC.view.frame;
    CGRect targetFrame = CGRectZero;
    targetFrame.origin.x = - (fromVCFrame.size.width);
    targetFrame.origin.y = LVNavigationBarHeight + LVStatusBarHeight;
    targetFrame.size.width = fromVCFrame.size.width;
    targetFrame.size.height = extraHeight;
    return targetFrame;
}

- (void)setBarTintColorForViewController:(UIViewController *)viewController {
    if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor)]) {
        viewController.navigationController.navigationBar.barTintColor = [viewController performSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor) withObject:nil];
    }
}

- (void)updateNavigationBarForViewController:(UIViewController *)viewController {
    LVResizableNavigationBar *navBar = (id)viewController.navigationController.navigationBar;
    [self setExtraHeightForViewController:viewController];
    [navBar adjustLayout];
    
    CGRect targetFrame = [self endNavBarSubHeaderFrameForExtraHeight:navBar.extraHeight toVC:viewController];
    UIView *subView = [self subHeaderForViewController:viewController];
    if (subView) {
        [viewController.navigationController.view addSubview:subView];
        subView.frame = targetFrame;
        navBar.subHeaderView = subView;
    }
    [self setBarTintColorForViewController:viewController];
    
}

@end
