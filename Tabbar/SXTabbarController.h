//
//  SXTabbarController.h
//  Tabbar
//
//  Created by Home on 25/12/15.
//  Copyright © 2015年 sure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTabbar.h"
@protocol SXTabbarControllerDelegate;

@interface SXTabbarController : UIViewController
@property(nonatomic, copy)NSArray *viewControllers;
@property(nonatomic, assign)UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;
@property(nonatomic,weak)id<SXTabbarControllerDelegate> delegate;
@end

@protocol SXTabbarControllerDelegate <NSObject>

- (void)SXTabBarController:(SXTabbarController *)tabBarController didSelectViewController:(UIViewController *)viewController AtIndex:(NSUInteger)Selectedindex;

@end
