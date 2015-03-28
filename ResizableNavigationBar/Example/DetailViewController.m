//
//  ViewController.m
//  ResizableNavigationBar
//
//  Created by Todd Anderson on 3/13/15.
//  Copyright (c) 2015 Level Money. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detail";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)resizableNavigationBarControllerNavigationBarHeight {
    return 200;
}

- (UIColor *)resizableNavigationBarControllerNavigationBarTintColor {
    return [UIColor purpleColor];
}

@end
