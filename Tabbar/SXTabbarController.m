//
//  SXTabbarController.m
//  Tabbar
//
//  Created by Home on 25/12/15.
//  Copyright © 2015年 sure. All rights reserved.
//

#import "SXTabbarController.h"

@interface SXTabbarController ()<SXTabbarDelegate>
@property (nonatomic, strong) UIView *presentationView;
@property (nonatomic, strong) SXTabbar *tabBarView;
@property (nonatomic, assign) BOOL isFirstAppear;
@end

@implementation SXTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    _tabBarView = [[SXTabbar alloc] initWithFrame:CGRectZero viewControllers:_viewControllers];
    _tabBarView.delegate = self;
    _presentationView = [[UIView alloc] init];
    _presentationView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_tabBarView];
    [self.view addSubview:_presentationView];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutTabBarView];
    [_tabBarView needsUpdateConstraints];
}
- (void)tabBar:(SXTabbar *)tabBar didPressButton:(UIButton *)button atIndex:(NSUInteger)tabIndex
{
    UIViewController *selectedViewController = _viewControllers[tabIndex];
    [self selectViewController:selectedViewController withIndex:tabIndex];
}
- (void)selectViewController:(UIViewController *)viewController withIndex:(NSUInteger)tabIndex
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(SXTabBarController:didSelectViewController:AtIndex:)]) {
        [self.delegate SXTabBarController:self didSelectViewController:viewController AtIndex:tabIndex];
    }
    [self selectViewController:viewController];
}
- (void)viewWillAppear:(BOOL)animated
{
//    NSParameterAssert(_viewControllers.count > 0);
    if (!_isFirstAppear) {
        _isFirstAppear = YES;
        [self selectViewController:[_viewControllers firstObject]];
    }
}
- (void)selectViewController:(UIViewController *)viewController
{
    UIView *presentedView = [_presentationView.subviews firstObject];
    if (presentedView) {
        [presentedView removeFromSuperview];
    }
    [self addChildViewController:viewController];
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_presentationView addSubview:viewController.view];
    [self fitView:viewController.view intoView:_presentationView];
}

#pragma mark - Layout

- (void)layoutTabBarView
{
    NSDictionary *viewsDictionary = @{@"tabbar_view" : _tabBarView,
                                      @"presentation_view" : _presentationView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tabbar_view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[presentation_view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[presentation_view][tabbar_view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
}

- (void)fitView:(UIView *)toPresentView intoView:(UIView *)containerView
{
    NSDictionary *viewsDictioanry = @{@"presented_view" : toPresentView};
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[presented_view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictioanry]];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[presented_view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictioanry]];
}
@end
