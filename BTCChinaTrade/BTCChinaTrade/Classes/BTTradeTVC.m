//
//  BTTradeTVC.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-9.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTTradeTVC.h"
#import "BTLoginTVC.h"
#import "BTNotYetOrdersTVC.h"

@interface BTTradeTVC () <RETableViewManagerDelegate>
@property (nonatomic, strong) RETableViewManager *manager;
@end

@implementation BTTradeTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"交易", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_trade"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    [self addBuySection];
    [self addSellSection];
    [self addOrderSection];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)addBuySection{
    RETableViewSection *section = [RETableViewSection section];
    section.headerTitle = NSLocalizedString(@"买入比特币", @"");
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 8)];
    section.footerView = footerView;
    [_manager addSection:section];
    
    RETextItem *amountItem = [RETextItem itemWithTitle:NSLocalizedString(@"购买数额 (฿)：", @"") value:@"" placeholder:@"0.000"];
    amountItem.keyboardType = UIKeyboardTypeDecimalPad;
    RETextItem *priceItem = [RETextItem itemWithTitle:NSLocalizedString(@"出价 (¥)：", @"") value:@"" placeholder:@"0.00"];
    priceItem.keyboardType = UIKeyboardTypeDecimalPad;
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:NSLocalizedString(@"下买单", @"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        if ([BTDataManager shared].userAccessKey) {
            if ([amountItem.value isEqualToString:@""] || [priceItem.value isEqualToString:@""]) {
                [[DHActionManager shared] showAndHideHUDWithTitle:NSLocalizedString(@"提示", @"") detailText:NSLocalizedString(@"数额和价格不能为空", @"") inView:self.view];
                return;
            }
            [UIAlertView showWithTitle:NSLocalizedString(@"确认买单", @"")
                               message:[NSString stringWithFormat:@"购买数额 (฿)：%@\n出价 (¥)：%@",amountItem.value,priceItem.value]
                     cancelButtonTitle:NSLocalizedString(@"取消", @"")
                     otherButtonTitles:@[NSLocalizedString(@"提交", @"")]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
                                  if ([title isEqualToString:NSLocalizedString(@"提交", @"")]) {
                                      
                                      MBProgressHUD *hud = [[DHActionManager shared] showHUDWithTitle:Nil detailText:Nil inView:self.view];
                                      hud.mode = MBProgressHUDModeIndeterminate;
                                      [[BCTradeAPIKit sharedAPIKit] requestBuyOrderWithPrice:priceItem.value amount:amountItem.value success:^(NSDictionary *result) {
                                          hud.mode = MBProgressHUDModeText;
                                          hud.labelText = NSLocalizedString(@"提交买单成功", @"");
                                          double delayInSeconds1 = 1.8;
                                          dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
                                          dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [self dismissViewControllerAnimated:YES completion:NULL];
                                          });
                                          amountItem.value = nil;
                                          priceItem.value = nil;
                                          [self.tableView reloadData];
                                      } failure:^(NSError *error) {
                                          hud.mode = MBProgressHUDModeText;
                                          hud.labelText = NSLocalizedString(@"提交买单失败", @"");
                                          double delayInSeconds1 = 1.8;
                                          dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
                                          dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [self dismissViewControllerAnimated:YES completion:NULL];
                                          });
                                      }];
                                      
                                  }
                              }];
        }else{
            BTLoginTVC *loginTVC = [[BTLoginTVC alloc] initWithStyle:UITableViewStyleGrouped];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginTVC];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        }
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:amountItem];
    [section addItem:priceItem];
    
    RETableViewSection *btnSection = [RETableViewSection section];
    UIView *btnHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
    btnSection.headerView = btnHeaderView;
    [_manager addSection:btnSection];
    [btnSection addItem:buttonItem];
}

- (void)addSellSection{
    RETableViewSection *section = [RETableViewSection section];
    section.headerTitle = NSLocalizedString(@"卖出比特币", @"");
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 8)];
    section.footerView = footerView;
    [_manager addSection:section];
    
    RETextItem *amountItem = [RETextItem itemWithTitle:NSLocalizedString(@"出售数额 (฿)：", @"") value:@"" placeholder:@"0.000"];
    amountItem.keyboardType = UIKeyboardTypeDecimalPad;
    RETextItem *priceItem = [RETextItem itemWithTitle:NSLocalizedString(@"售价 (¥)：", @"") value:@"" placeholder:@"0.00"];
    priceItem.keyboardType = UIKeyboardTypeDecimalPad;
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:NSLocalizedString(@"下卖单", @"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        if ([BTDataManager shared].userAccessKey) {
            if (!amountItem.value || [amountItem.value isEqualToString:@""] || !priceItem.value || [priceItem.value isEqualToString:@""]) {
                [[DHActionManager shared] showAndHideHUDWithTitle:NSLocalizedString(@"提示", @"") detailText:NSLocalizedString(@"数额和价格不能为空", @"") inView:self.view];
                return;
            }
            [UIAlertView showWithTitle:NSLocalizedString(@"确认卖单", @"")
                               message:[NSString stringWithFormat:@"出售数额 (฿)：%@\n售价 (¥)：%@",amountItem.value,priceItem.value]
                     cancelButtonTitle:NSLocalizedString(@"取消", @"")
                     otherButtonTitles:@[NSLocalizedString(@"提交", @"")]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
                                  if ([title isEqualToString:NSLocalizedString(@"提交", @"")]) {
                                      
                                      MBProgressHUD *hud = [[DHActionManager shared] showHUDWithTitle:Nil detailText:Nil inView:self.view];
                                      hud.mode = MBProgressHUDModeIndeterminate;
                                      [[BCTradeAPIKit sharedAPIKit] requestSellOrderWithPrice:priceItem.value amount:amountItem.value success:^(NSDictionary *result) {
                                          hud.mode = MBProgressHUDModeText;
                                          hud.labelText = NSLocalizedString(@"提交卖单成功", @"");
                                          double delayInSeconds1 = 1.8;
                                          dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
                                          dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [self dismissViewControllerAnimated:YES completion:NULL];
                                          });
                                          amountItem.value = nil;
                                          priceItem.value = nil;
                                          [self.tableView reloadData];
                                      } failure:^(NSError *error) {
                                          hud.mode = MBProgressHUDModeText;
                                          hud.labelText = NSLocalizedString(@"提交卖单失败", @"");
                                          double delayInSeconds1 = 1.8;
                                          dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
                                          dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [self dismissViewControllerAnimated:YES completion:NULL];
                                          });
                                      }];
                                      
                                  }
                              }];
        }else{
            BTLoginTVC *loginTVC = [[BTLoginTVC alloc] initWithStyle:UITableViewStyleGrouped];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginTVC];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        }
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:amountItem];
    [section addItem:priceItem];
    
    RETableViewSection *btnSection = [RETableViewSection section];
    UIView *btnHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
    btnSection.headerView = btnHeaderView;
    [_manager addSection:btnSection];
    [btnSection addItem:buttonItem];
}

- (void)addOrderSection{
    RETableViewItem *orderItem = [RETableViewItem itemWithTitle:NSLocalizedString(@"尚未成交的挂单", @"")
                                                  accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                               selectionHandler:^(RETableViewItem *item) {
                                                   if ([BTDataManager shared].userAccessKey) {
                                                       BTNotYetOrdersTVC *vc = [[BTNotYetOrdersTVC alloc] initWithStyle:UITableViewStyleGrouped];
                                                       [self.navigationController pushViewController:vc animated:YES];
                                                   }else{
                                                       BTLoginTVC *loginTVC = [[BTLoginTVC alloc] initWithStyle:UITableViewStyleGrouped];
                                                       UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginTVC];
                                                       [self.navigationController presentViewController:nav animated:YES completion:NULL];
                                                   }
                                                   
                                               }];
    RETableViewSection *ordersSection = [RETableViewSection section];
    [ordersSection addItem:orderItem];
    [_manager addSection:ordersSection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
