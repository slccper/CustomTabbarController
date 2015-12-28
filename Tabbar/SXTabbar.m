//
//  SXTabbar.m
//  Tabbar
//
//  Created by Home on 25/12/15.
//  Copyright © 2015年 sure. All rights reserved.
//

#import "SXTabbar.h"
@interface SXTabbar ()
@property (nonatomic,copy)NSMutableArray *buttons;
@property (nonatomic,copy)NSArray *viewControllers;
@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@end
@implementation SXTabbar
- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttons=[NSMutableArray array];
        _viewControllers=viewControllers;
        self.tabBarHeight =49;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initSubView];
        [self addHeightConstraints];
        [self addAllLayoutConstraints];
    }
    return self;
}
- (void)tabButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag%10;
    NSUInteger buttonIndex = index;
    [_delegate tabBar:self didPressButton:sender atIndex:buttonIndex];
    [self setSelectedButton:_buttons[index]];
}
- (void)setSelectedButton:(UIButton *)selectedButton
{
    NSUInteger oldButtonIndex = [_buttons indexOfObject:_selectedButton];
    NSUInteger newButtonIndex = [_buttons indexOfObject:selectedButton];
    
    if (oldButtonIndex != NSNotFound) {
        for (UIButton *btn in _selectedButton.subviews) {
            btn.selected = NO;
        }
    }
    
    if (newButtonIndex != NSNotFound) {
        for (UIButton *btn in selectedButton.subviews) {
            btn.selected = YES;
        }
    }
    
    _selectedButton = selectedButton;
}
-(void)initSubView
{
    NSUInteger tagCounter = 0;
    for (UIViewController *vc in _viewControllers) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag  = tagCounter;
        [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttons addObject:button];
        
        UIButton *imagebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imagebtn.translatesAutoresizingMaskIntoConstraints = NO;
        imagebtn.tag  = tagCounter+10;
        
        [imagebtn setFrame:CGRectMake(0, 0, 30, 30)];
        [imagebtn addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [imagebtn setImage:vc.tabBarItem.image forState:UIControlStateNormal];
        [imagebtn setImage:vc.tabBarItem.image forState:UIControlStateHighlighted];
        [imagebtn setImage:vc.tabBarItem.selectedImage forState:UIControlStateSelected];
        [imagebtn sizeToFit];
        [button addSubview:imagebtn];
        
        UIButton *Titlebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        Titlebtn.translatesAutoresizingMaskIntoConstraints = NO;
        Titlebtn.tag  = tagCounter+20;
        [Titlebtn setFrame:CGRectMake(0, 30, 30, 19)];
        [Titlebtn setTitle:vc.tabBarItem.title forState:UIControlStateNormal];
        [Titlebtn setTitle:vc.tabBarItem.title forState:UIControlStateHighlighted];
        [Titlebtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [Titlebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Titlebtn sizeToFit];
        [Titlebtn addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        Titlebtn.titleLabel.font=[UIFont systemFontOfSize:12];
        Titlebtn.titleLabel.adjustsFontSizeToFitWidth=YES;
        [button addSubview:Titlebtn];
        
        tagCounter++;
    }
}
- (void)didMoveToSuperview
{
    // When the app is first launched set the selected button to be the first button
    [self setSelectedButton:[_buttons firstObject]];
}
-(void)layoutSubviews{
    
}
- (void)addHeightConstraints
{
    if (_heightConstraint) {
        [self removeConstraint:_heightConstraint];
        _heightConstraint = nil;
    }
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.0
                                                      constant:self.tabBarHeight];
    
    [self addConstraint:_heightConstraint];
}
- (void)addAllLayoutConstraints
{
    NSDictionary *viewsDictionary = [self visualFormatStringViewsDictionaryWithButtons:_buttons];
    
    NSString *visualFormatString = [self visualFormatConstraintStringWithButtons:_buttons];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[self separatorWidthConstraintsWithSeparators:_buttons]];
    [self addConstraints:[self centerAlignmentConstraintsWithButtons:_buttons
                                                          separators:nil]];
    [self addSubButtonConstrainstWithButtons];
}
-(void)addSubButtonConstrainstWithButtons
{
    for (UIButton *button in _buttons) {
        NSDictionary *viewsDictionary = [self visualFormatStringViewsDictionaryWithButtons:button.subviews];
        
        NSString *visualFormatString = [self visualFormatConstraintStringWithSubButton:button.subviews];
        
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary]];
        [button addConstraints:[self separatorWidthConstraintsWithSubButto:button.subviews :button]];
        [button addConstraints:[self centerAlignmentConstraintsWithSubButton:button.subviews :button]];
    }
}
- (NSArray *)separatorWidthConstraintsWithSubButto:(NSArray *)separators :(UIButton *)button
{
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [separators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *separator = (UIView *)obj;
        UIView *targetSeparator;
        if ([obj isEqual:[separators lastObject]]) {
            targetSeparator = [separators firstObject];
        } else {
            targetSeparator = [separators objectAtIndex:(idx + 1)];
        }
        
        NSLayoutConstraint *constraint;
        if (separator.tag<20) {
            constraint = [NSLayoutConstraint constraintWithItem:separator
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:button
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
            [constraints addObject:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:separator
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:button
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:0
                                                       constant:30];
            [constraints addObject:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:separator
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:targetSeparator
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1.0
                                                       constant:30];
            [constraints addObject:constraint];
            constraint = [NSLayoutConstraint constraintWithItem:targetSeparator
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:button
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0];
            [constraints addObject:constraint];
        }
    }];
    
    return constraints;
}


- (NSArray *)centerAlignmentConstraintsWithSubButton:(NSArray *)buttons :(UIButton *)button
{
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    NSMutableArray *buttonsAndSeparators = [[NSMutableArray alloc] init];
    
    [buttonsAndSeparators addObjectsFromArray:buttons];
    for (UIView *view in buttonsAndSeparators) {
        NSLayoutConstraint *constraint;
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeCenterX
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:button
                                                  attribute:NSLayoutAttributeCenterX
                                                 multiplier:1.0
                                                   constant:0];
        [constraints addObject:constraint];
    }
    
    return constraints;
}

- (NSDictionary *)visualFormatStringViewsDictionaryWithButtons:(NSArray *)buttons
{
    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] init];
    
    for (UIButton *button in buttons) {
        NSString *key = [NSString stringWithFormat:@"button%ld", (long)button.tag];
        viewsDictionary[key] = button;
    }
    return viewsDictionary;
}
- (NSString *)visualFormatConstraintStringWithSubButton:(NSArray *)buttons
{
    NSEnumerator *buttonsEnumerator = [buttons objectEnumerator];
    NSMutableArray *constraintParts = [[NSMutableArray alloc] init];
    
    UIButton *button;
    while (button = [buttonsEnumerator nextObject]) {
        NSString *buttonFormat = [NSString stringWithFormat:@"button%ld", (long)button.tag];
        [constraintParts addObject:[NSString stringWithFormat:@"[%@]", buttonFormat]];
        
        if ([button isEqual:[buttons lastObject]]) {
            break;
        }
        
    }
    NSMutableString *constraint = [NSMutableString stringWithFormat:@"V:|"];
    [constraint appendString:[constraintParts componentsJoinedByString:@""]];
    [constraint appendString:[NSString stringWithFormat:@"|"]];
    
    return constraint;
}

- (NSString *)visualFormatConstraintStringWithButtons:(NSArray *)buttons
{
    NSEnumerator *buttonsEnumerator = [buttons objectEnumerator];
    NSMutableArray *constraintParts = [[NSMutableArray alloc] init];
    
    UIButton *button;
    while (button = [buttonsEnumerator nextObject]) {
        NSString *buttonFormat = [NSString stringWithFormat:@"button%ld", (long)button.tag];
        [constraintParts addObject:[NSString stringWithFormat:@"[%@]", buttonFormat]];
        
        if ([button isEqual:[buttons lastObject]]) {
            break;
        }
    }
    NSMutableString *constraint = [NSMutableString stringWithFormat:@"H:|"];
    [constraint appendString:[constraintParts componentsJoinedByString:@""]];
    [constraint appendString:[NSString stringWithFormat:@"|"]];
    
    return constraint;
}
- (NSArray *)separatorWidthConstraintsWithSeparators:(NSArray *)separators
{
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [separators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *separator = (UIView *)obj;
        UIView *targetSeparator;
        
        if ([obj isEqual:[separators lastObject]]) {
            targetSeparator = [separators firstObject];
        } else {
            targetSeparator = [separators objectAtIndex:(idx + 1)];
        }
        
        NSLayoutConstraint *constraint;
        constraint = [NSLayoutConstraint constraintWithItem:separator
                                                  attribute:NSLayoutAttributeWidth
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:targetSeparator
                                                  attribute:NSLayoutAttributeWidth
                                                 multiplier:1.0
                                                   constant:0.0];
        [constraints addObject:constraint];
    }];
    
    return constraints;
}
- (NSArray *)centerAlignmentConstraintsWithButtons:(NSArray *)buttons
                                        separators:(NSArray *)separators
{
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    NSMutableArray *buttonsAndSeparators = [[NSMutableArray alloc] init];
    
    [buttonsAndSeparators addObjectsFromArray:buttons];
    for (UIView *view in buttonsAndSeparators) {
        NSLayoutConstraint *constraint;
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeCenterY
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                  attribute:NSLayoutAttributeCenterY
                                                 multiplier:1.0
                                                   constant:0];
        [constraints addObject:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                  attribute:NSLayoutAttributeHeight
                                                 multiplier:0
                                                   constant:self.tabBarHeight];
        [constraints addObject:constraint];
    }
    
    return constraints;
}

@end
