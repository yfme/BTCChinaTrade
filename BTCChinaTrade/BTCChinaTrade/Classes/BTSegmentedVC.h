//
//  BTSegmentedVC.h
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-6.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTSegmentedVC : UIViewController

@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedViewControllerIndex;
@property (nonatomic, assign) CGFloat defaultWidth;

- (id)initWithViewControllers:(NSArray *)viewControllers;

- (void)addViewController:(UIViewController *)viewController;
- (void)addViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)removeViewControllerAtIndex:(NSUInteger)index;
- (void)removeViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeViewController:(UIViewController *)viewController;
- (void)removeViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)setSelectedViewControllerIndex:(NSUInteger)index animated:(BOOL)animated;

@end
