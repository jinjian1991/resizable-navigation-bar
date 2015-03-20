//
//  LVResizableNavigationController.m
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

#import "LVResizableNavigationController.h"
#import "LVResizableNavigationBar.h"
#import "LVResizableNavigationAnimation.h"

@interface LVResizableNavigationController ()

@property (nonatomic) BOOL pushing;
@property (nonatomic) LVResizableNavigationAnimation *animationObject;

@end

@implementation LVResizableNavigationController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[LVResizableNavigationBar class] toolbarClass:nil];
    if (self) {
        [self initialize];
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:nil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.animationObject = [LVResizableNavigationAnimation new];
    self.delegate = self.animationObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    UIViewController *topViewController = self.topViewController;
    [self.animationObject updateNavigationBarForViewController:topViewController];
    LVResizableNavigationBar *bar = (id)self.navigationBar;
    __weak LVResizableNavigationController *weak = self;
    bar.colorChanged = ^{
        weak.view.backgroundColor = weak.navigationBar.barTintColor;
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = self.navigationBar.barTintColor;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    [super setViewControllers:viewControllers];
    UIViewController *viewController = self.viewControllers[0];
    [self.animationObject updateNavigationBarForViewController:viewController];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    UIViewController *viewController = self.viewControllers[0];
    [self.animationObject updateNavigationBarForViewController:viewController];
}




@end
