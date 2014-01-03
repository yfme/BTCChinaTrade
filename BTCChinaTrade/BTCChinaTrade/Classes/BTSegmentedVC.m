//
//  BTSegmentedVC.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-6.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTSegmentedVC.h"

#define ANIMATION_DURATION 0.3

static NSString *const imageKeyPath = @"self.tabBarItem.image";
static NSString *const titleKeyPath = @"self.title";

@interface BTSegmentedVC ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *mutableViewControllers;

- (void)_commonInit;

- (void)_addViewController:(UIViewController *)viewController segmentAtIndex:(NSUInteger)idx animated:(BOOL)animated;
- (void)_removeAllObservers;
- (void)_updateSegmentedControl:(BOOL)animated;
- (void)_resetSegmentedControl;
- (void)_removeObserversFromViewController:(UIViewController *)controller;
- (void)_segmentChanged:(id)segmentChanged;
@end

@implementation BTSegmentedVC

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (id)initWithViewControllers:(NSArray *)viewControllers {
    self = [self init];
    if (self) {
        self.viewControllers = viewControllers;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

#pragma mark - Public setter methods

- (void)setViewControllers:(NSArray *)viewControllers {
    UIViewController *lastSelectedViewController = self.selectedViewController;
    
    if (self.mutableViewControllers && self.mutableViewControllers.count > 0) {
        for (UIViewController *controller in self.mutableViewControllers) {
            [self _removeObserversFromViewController:controller];
            [controller willMoveToParentViewController:nil];
            [controller removeFromParentViewController];
        }
    }
    
    self.mutableViewControllers = [NSMutableArray arrayWithArray:viewControllers];
    [self _resetSegmentedControl];
    
    for (UIViewController *controller in self.mutableViewControllers) {
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
    }
    
    NSUInteger idx = [self.mutableViewControllers indexOfObject:lastSelectedViewController];
    
    if (idx == NSNotFound) idx = 0;
    
    [self setSelectedViewControllerIndex:idx];
}

- (void)setSelectedViewControllerIndex:(NSUInteger)idx {
    [self setSelectedViewControllerIndex:idx animated:NO];
}

- (void)setSelectedViewControllerIndex:(NSUInteger)idx animated:(BOOL)animated {
    NSAssert(idx < [self.mutableViewControllers count], @"Index is out of bounds");
    
    UIViewController *prevController = self.selectedViewController;
    UIViewController *nextController = [self.mutableViewControllers objectAtIndex:idx];
    
    _selectedViewControllerIndex = idx;
    [self _updateSegmentedControl:animated];
    
    if (prevController == nextController) {
        prevController = nil;
    }
    
    if (prevController) {
        nextController.view.frame = self.view.bounds;
        if (animated) {
            [self transitionFromViewController:prevController
                              toViewController:nextController
                                      duration:ANIMATION_DURATION
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:nil completion:nil];
        } else {
            [prevController.view removeFromSuperview];
            [self.view addSubview:nextController.view];
        }
    } else {
        nextController.view.frame = self.view.bounds;
        [self.view addSubview:nextController.view];
    }
    
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    [self setSelectedViewController:selectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSUInteger idx = [self.mutableViewControllers indexOfObject:viewController];
    if (idx != NSNotFound) {
        [self setSelectedViewControllerIndex:idx animated:animated];
    }
}

- (void)setDefaultWidth:(CGFloat)defaultWidth {
    _defaultWidth = defaultWidth;
    [self _updateSegmentedControl:NO];
}

#pragma mark - Container view controller methods

- (void)addViewController:(UIViewController *)viewController {
    [self addViewController:viewController animated:NO];
}

- (void)addViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self insertViewController:viewController atIndex:self.mutableViewControllers.count animated:animated];
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index animated:(BOOL)animated {
    if (_selectedViewControllerIndex >= index) _selectedViewControllerIndex++;
    
    [self.mutableViewControllers insertObject:viewController atIndex:index];
    
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    [self _addViewController:viewController segmentAtIndex:index animated:animated];
    [self _updateSegmentedControl:animated];
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
    [self insertViewController:viewController atIndex:index animated:NO];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index {
    [self removeViewControllerAtIndex:index animated:NO];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated {
    NSUInteger curIdx = self.selectedViewControllerIndex;
    NSUInteger idx = index;
    
    if (self.mutableViewControllers.count > index) {
        UIViewController *viewController = [self.mutableViewControllers objectAtIndex:idx];
        
        if (idx == curIdx && self.segmentedControl.numberOfSegments > 1) {
            
            NSInteger tNum = [[NSNumber numberWithUnsignedInteger:idx] integerValue];
            NSUInteger newIdx = (tNum - 1 >= 0) ? idx - 1 : idx + 1;
            [self setSelectedViewControllerIndex:newIdx animated:animated];
            
            if (tNum <= 0) {_selectedViewControllerIndex--;}
            
        } else if (self.segmentedControl.numberOfSegments == 1) {
            [viewController.view removeFromSuperview];
        }
        
        [self _removeObserversFromViewController:viewController];
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
        
        [self.mutableViewControllers removeObject:viewController];
        
        // I HAVE NO IDEA WHY IT WORKS LIKE THIS. HOPE NO ONE WILL USE IT ANYWAY
        [self _removeAllObservers];
        [self _resetSegmentedControl];
    }
}

- (void)removeViewController:(UIViewController *)viewController {
    [self removeViewController:viewController animated:NO];
}

- (void)removeViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSUInteger idx = [self.mutableViewControllers indexOfObject:viewController];
    if (idx != NSNotFound) {
        [self removeViewControllerAtIndex:idx animated:animated];
    }
}

#pragma mark - Public getter methods

- (NSArray *)viewControllers {
    return [NSArray arrayWithArray:self.mutableViewControllers];
}

- (UIViewController *)selectedViewController {
    if (self.selectedViewControllerIndex != NSNotFound) {
        return [self.mutableViewControllers objectAtIndex:self.selectedViewControllerIndex];
    } else {
        return nil;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([self.mutableViewControllers containsObject:object]) {
        if ([keyPath isEqualToString:titleKeyPath]) {
            NSUInteger idx = [self.viewControllers indexOfObject:object];
            [self.segmentedControl setTitle:[change objectForKey:NSKeyValueChangeNewKey] forSegmentAtIndex:idx];
        } else if ([keyPath isEqualToString:imageKeyPath]) {
            NSUInteger idx = [self.viewControllers indexOfObject:object];
            [self.segmentedControl setImage:[change objectForKey:NSKeyValueChangeNewKey] forSegmentAtIndex:idx];
        }
        [self _updateSegmentedControl:NO];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Private helper methods

- (void)_commonInit {
    self.segmentedControl = [[UISegmentedControl alloc] init];
    //self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.momentary = NO;
    [self.segmentedControl addTarget:self action:@selector(_segmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)_addViewController:(UIViewController *)viewController segmentAtIndex:(NSUInteger)idx animated:(BOOL)animated {
    if (viewController.title) {
        [self.segmentedControl insertSegmentWithTitle:viewController.title atIndex:idx animated:animated];
    } else if (viewController.tabBarItem.image) {
        [self.segmentedControl insertSegmentWithImage:viewController.tabBarItem.image atIndex:idx animated:animated];
    } else {
        [self.segmentedControl insertSegmentWithTitle:@"" atIndex:idx animated:animated];
    }
    
    [viewController addObserver:self forKeyPath:titleKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [viewController addObserver:self forKeyPath:imageKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_segmentChanged:(id)segmentChanged {
    UISegmentedControl *control = (UISegmentedControl *) segmentChanged;
    [self setSelectedViewControllerIndex:(NSUInteger) control.selectedSegmentIndex animated:NO];
}

- (void)_resetSegmentedControl {
    [self.segmentedControl removeAllSegments];
    
    for (UIViewController *ctrl in self.mutableViewControllers) {
        NSUInteger idx = [self.mutableViewControllers indexOfObject:ctrl];
        [self _addViewController:ctrl segmentAtIndex:idx animated:NO];
    }
    
    [self _updateSegmentedControl:NO];
}

- (void)_removeAllObservers {
    for (UIViewController *ctrl in self.mutableViewControllers) {
        [self _removeObserversFromViewController:ctrl];
    }
}

- (void)_updateSegmentedControl:(BOOL)animated {
    [self.segmentedControl setSelectedSegmentIndex:self.selectedViewControllerIndex];
    CGFloat width = (self.defaultWidth > 0) ? self.defaultWidth : INFINITY;
    CGSize size = [self.segmentedControl sizeThatFits:CGSizeMake(width, INFINITY)];
    CGRect frame = self.segmentedControl.frame;
    CGRect newRect = CGRectMake(frame.origin.x, frame.origin.y, (self.defaultWidth > 0 && size.width < self.defaultWidth) ? self.defaultWidth : size.width, size.height);
    if (animated) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.segmentedControl.frame = newRect;
        }];
    } else {
        self.segmentedControl.frame = newRect;
    }
}

- (void)_removeObserversFromViewController:(UIViewController *)controller {
    [controller removeObserver:self forKeyPath:titleKeyPath];
    [controller removeObserver:self forKeyPath:imageKeyPath];
}

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkTextColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.navigationItem.titleView = self.segmentedControl;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Memory management

- (void)dealloc {
    self.segmentedControl = nil;
    self.mutableViewControllers = nil;
}

@end
