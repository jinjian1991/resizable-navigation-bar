//
//  LVResizableNavigationBar.h
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

#import <UIKit/UIKit.h>

extern CGFloat const LVNavigationBarHeight;
extern CGFloat const LVStatusBarHeight;
extern CGFloat const LVAnimationDuration;

@interface LVResizableNavigationBar : UINavigationBar

// These properties and methods should never be accessed externally.  Instead
// refer to the LVResizableNavigationController protocol
@property (nonatomic) CGFloat extraHeight;
@property (nonatomic) UIView *subHeaderView;

- (void)setSubHeaderView:(UIView *)subHeaderView animated:(BOOL)animated push:(BOOL)push;
- (void)adjustLayout;
- (void)updateBackgroundView;

@end
