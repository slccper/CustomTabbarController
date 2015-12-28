//
//  SXTabbar.h
//  Tabbar
//
//  Created by Home on 25/12/15.
//  Copyright © 2015年 sure. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SXTabbarDelegate;

@interface SXTabbar : UIView
@property (nonatomic, weak) id<SXTabbarDelegate> delegate;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIViewController *selectedViewController;
- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers;
@end

@protocol SXTabbarDelegate <NSObject>
- (void)tabBar:(SXTabbar *)tabBar didPressButton:(UIButton *)button atIndex:(NSUInteger)tabIndex;
@end