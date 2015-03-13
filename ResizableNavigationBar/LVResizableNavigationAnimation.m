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
//  You may elect to redistribute this code under either of these licenses.
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
    
    
    navBar.extraHeight = toVCNavHeight - LVNavigationBarHeight;
    [self setSubHeaderForViewController:toVC animated:YES push:self.pushing];
    
    CGRect toVCStartFrame = toVC.view.frame;
    //adjust target view controller to left (pop) or to right (push) of current view controller
    toVCStartFrame.origin.x    = self.pushing ? toVCStartFrame.size.width : -(toVCStartFrame.size.width);
    toVCStartFrame.origin.y    = fromVC.view.frame.origin.y;
    toVCStartFrame.size.height = fromVC.view.frame.size.height;
    toVC.view.frame            = toVCStartFrame;
    
    //calculate navigation bar frame
    CGRect navFrame      = navBar.frame;
    navFrame.origin.y    = LVStatusBarHeight - navBar.extraHeight;
    navFrame.size.height = toVCNavHeight;
    
    //target view controller final frame
    CGRect toVCEndFrame      = toVCStartFrame;
    toVCEndFrame.origin.x    = 0;
    toVCEndFrame.origin.y    = toVCNavHeight + LVStatusBarHeight;
    toVCEndFrame.size.height = toVC.navigationController.view.frame.size.height - toVCNavHeight - LVStatusBarHeight;
    
    //current view controller final frame to right (pop) or to left (push)
    CGRect fromVCEndFrame      = fromVC.view.frame;
    fromVCEndFrame.origin.x    = self.pushing ? -(fromVCEndFrame.size.width) : fromVCEndFrame.size.width;
    fromVCEndFrame.origin.y    = toVCEndFrame.origin.y;
    fromVCEndFrame.size.height = toVCEndFrame.size.height;
    
    NSArray * leftItems  = toVC.navigationItem.leftBarButtonItems;
    NSArray * rightItems = toVC.navigationItem.rightBarButtonItems;
    NSString * toTitle     = toVC.title;
    NSString * fromTitle   = fromVC.title;
    toVC.navigationItem.leftBarButtonItems = nil;
    toVC.navigationItem.rightBarButtonItems = nil;
    toVC.title = nil;
    fromVC.title = nil;
    
    [UIView animateWithDuration:LVAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //adjust colors
                         navBar.barTintColor                              = color;
                         fromVC.navigationController.view.backgroundColor = color;
                         [navBar sizeToFit];
                         //adjust frames
                         navBar.frame      = navFrame;
                         toVC.view.frame   = toVCEndFrame;
                         fromVC.view.frame = fromVCEndFrame;
                         
                     } completion:^(BOOL finished) {
                         //cleanup
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

- (void)setSubHeaderForViewController:(UIViewController *)viewController animated:(BOOL)animated push:(BOOL)push {
    UIView *subHeaderView;
    if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerSubHeaderView)]) {
        subHeaderView = [viewController performSelector:@selector(resizableNavigationBarControllerSubHeaderView) withObject:nil];
    }
    LVResizableNavigationBar *navBar = (id)viewController.navigationController.navigationBar;
    [navBar setSubHeaderView:subHeaderView animated:animated push:push];
}

- (void)setBarTintColorForViewController:(UIViewController *)viewController {
    if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor)]) {
        viewController.navigationController.navigationBar.barTintColor = [viewController performSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor) withObject:nil];
    }
}

- (void)updateNavigationBarForViewController:(UIViewController *)viewController {
    [self setSubHeaderForViewController:viewController animated:NO push:YES];
    [self setExtraHeightForViewController:viewController];
    [self setBarTintColorForViewController:viewController];
    LVResizableNavigationBar *navBar = (id)viewController.navigationController.navigationBar;
    [navBar adjustLayout];
}

@end
