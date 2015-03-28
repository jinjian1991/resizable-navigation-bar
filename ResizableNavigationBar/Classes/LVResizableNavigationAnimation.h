//
//  LVResizableNavigationAnimation.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LVResizableNavigationAnimation : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

- (void)updateNavigationBarForViewController:(UIViewController *)viewController;

@end
