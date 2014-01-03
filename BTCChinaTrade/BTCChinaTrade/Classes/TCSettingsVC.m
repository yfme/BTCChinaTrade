//
//  TCSettingsVC.m
//  
//
//  Created by Yang Fei on 13-11-24.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "TCSettingsVC.h"
#import "UMFeedbackViewController.h"

@interface TCSettingsVC () <UIAppearanceContainer>

@end

@implementation TCSettingsVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"More", @"");
    }
    return self;
}

- (void)leftItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")){
        self.tableView.backgroundView = [[UIView alloc] init];
        self.tableView.backgroundView.backgroundColor = MP_RGB(239, 239, 245);
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.showsTouchWhenHighlighted = YES;
        backBtn.frame = CGRectMake(0, 0, 39, 44);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"button_item_back_ios6"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    [self addSection];
    [self addSectionMore];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Basic

- (void)addSection
{
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    
    RETableViewItem *item0 = [RETableViewItem itemWithTitle:NSLocalizedString(@"Rate", @"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [Appirater rateApp];
        [MobClick event:@"rate"]; 
    }];
    item0.image = [UIImage imageNamed:@"cell_icon_star"];
    [section addItem:item0];
    
    RETableViewItem *item1 = [RETableViewItem itemWithTitle:NSLocalizedString(@"Feedback", @"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [self feedback];
    }];
    item1.image = [UIImage imageNamed:@"cell_icon_feedback"];
    [section addItem:item1];
}

- (void)addSectionMore{
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    
    RETableViewItem *itemApps = [RETableViewItem itemWithTitle:NSLocalizedString(@"Appxyz Studio", @"")];
    itemApps.image = [UIImage imageNamed:@"cell_icon_about"];
    itemApps.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    itemApps.selectionHandler = ^(RETableViewItem *item){
        [item deselectRowAnimated:YES];
        DAAppsViewController *vc = [[DAAppsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.pageTitle = NSLocalizedString(@"Appxyz Studio", @"");
        [vc loadAppsWithAppIds:@[@657222343,@770929044,@686847255,@646655397] completionBlock:nil];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addItem:itemApps];
}

#pragma mark - Umeng

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.translucent = NO;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)feedback{
    [self showNativeFeedbackWithAppkey:kUmengKey];
}

@end
