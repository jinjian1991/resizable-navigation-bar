//
//  LVResizableNavigationBar.m
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

#import "LVResizableNavigationBar.h"

CGFloat const LVNavigationBarHeight = 44.0;
CGFloat const LVStatusBarHeight = 20.0;
CGFloat const LVAnimationDuration = 0.3;

@implementation LVResizableNavigationBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    //don't use fat headers with translucency. it messes things up with the layout guides
    self.translucent = NO;
    self.clipsToBounds = NO;
    [self setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    //remove shadow border image since we're relying on the navigationcontroller.view, and the line is a little ugly in flat design
    [self setShadowImage:[UIImage new]];
    self.backgroundColor = [UIColor clearColor];
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += _extraHeight;
    return amendedSize;
}

- (void)setExtraHeight:(CGFloat)extraHeight {
    _extraHeight = extraHeight;
}

- (void)setSubHeaderView:(UIView *)subHeaderView {
    [self setSubHeaderView:subHeaderView animated:NO push:YES];
}

- (void)setSubHeaderView:(UIView *)subHeaderView animated:(BOOL)animated push:(BOOL)push {
    if (subHeaderView == _subHeaderView) {
        return;
    }
    [self addSubview:subHeaderView];
    CGRect bounds = [self bounds];
    CGRect _subHeaderFrame = _subHeaderView.frame;
    _subHeaderFrame.origin.y = -(LVNavigationBarHeight);
    subHeaderView.autoresizingMask &= ~UIViewAutoresizingFlexibleHeight;
    subHeaderView.frame = CGRectMake(0,
                                     bounds.origin.y + LVNavigationBarHeight,
                                     bounds.size.width,
                                     _extraHeight);
    subHeaderView.alpha = 0;
    
    void(^animateHeader)() = ^{
        _subHeaderView.frame = _subHeaderFrame;
        subHeaderView.frame  = CGRectMake(0,
                                          bounds.origin.y + _extraHeight + LVNavigationBarHeight,
                                          bounds.size.width,
                                          _extraHeight);
        subHeaderView.alpha  = 1;
        _subHeaderView.alpha = 0;
    };
    
    void (^finished)(BOOL) = ^(BOOL isFinished){
        _subHeaderView.alpha = 1;
        [_subHeaderView removeFromSuperview];
        _subHeaderView = subHeaderView;
    };
    if (animated) {
        [UIView animateWithDuration:LVAnimationDuration animations:animateHeader completion:finished];
    } else {
        animateHeader();
        finished(YES);
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint pointForTargetView = [self.subHeaderView convertPoint:point fromView:self];
    
    if (CGRectContainsPoint(self.subHeaderView.bounds, pointForTargetView)) {
        return [self.subHeaderView hitTest:pointForTargetView withEvent:event];
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.origin.y = LVStatusBarHeight - _extraHeight;
    self.frame = frame;
    NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            frame.origin.y    = bounds.origin.y - 20.f;
            frame.size.height = bounds.size.height + 20.f;
            [view setFrame:frame];
        }
    }
    
}

- (void)adjustLayout {
    [self sizeToFit];
    CGRect frame = [self frame];
    frame.origin.y = LVStatusBarHeight;
    self.frame = frame;
    CGRect bounds = [self bounds];
    _subHeaderView.frame = CGRectMake(0,
                                      bounds.origin.y + bounds.size.height,
                                      bounds.size.width,
                                      _extraHeight);
}

@end
