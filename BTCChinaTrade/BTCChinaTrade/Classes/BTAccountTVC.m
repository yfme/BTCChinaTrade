//
//  BTAccountTVC.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-8.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTAccountTVC.h"
#import "BTLoginTVC.h"
#import "TCSettingsVC.h"

@interface BTAccountTVC ()
@property (nonatomic, strong) NSDictionary *accountDict;
@end

@implementation BTAccountTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"账户", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_account"];
        if ([BTDataManager shared].userAccessKey) {
            [BCTradeAPIKit sharedAPIKit].accessKey = [BTDataManager shared].userAccessKey;
            [BCTradeAPIKit sharedAPIKit].secretKey = [BTDataManager shared].userSecretkey;
            [[BCTradeAPIKit sharedAPIKit] requestAccountInfoSuccess:^(NSDictionary *result) {
                _accountDict = result;
                [self.tableView reloadData];
            } failure:^(NSError *error) {
            }];
        }
    }
    return self;
}

- (void)handleRefresh:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://data.btcchina.com/data/ticker"];
    [[AFHTTPClient clientWithBaseURL:url] getPath:@"" parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [BTDataManager shared].tickerDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
    }];
    
    if ([BTDataManager shared].userAccessKey) {
        [BCTradeAPIKit sharedAPIKit].accessKey = [BTDataManager shared].userAccessKey;
        [BCTradeAPIKit sharedAPIKit].secretKey = [BTDataManager shared].userSecretkey;
        [[BCTradeAPIKit sharedAPIKit] requestAccountInfoSuccess:^(NSDictionary *result) {
            _accountDict = result;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(NSError *error) {
            [self.refreshControl endRefreshing];
        }];
    }else{
        _accountDict = nil;
        [self.tableView reloadData];
    }
}

- (void)rightItemClicked:(id)sender{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl *depthRefreshControl = [[UIRefreshControl alloc] init];
    [depthRefreshControl addTarget:self
                            action:@selector(handleRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl = depthRefreshControl;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleRefresh:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"基本资料", @"");
            break;
        case 1:
            title = NSLocalizedString(@"账户可用余额", @"");
            break;
        case 2:
            title = NSLocalizedString(@"账户冻结金额", @"");
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [BTDataManager shared].userAccessKey?5:4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        default:
            break;
        }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"用户名"];
        cell.textLabel.text = NSLocalizedString(@"用户名", @"");
        if ([BTDataManager shared].userAccessKey) {
            cell.detailTextLabel.text = [[_accountDict objectForKey:@"profile"] objectForKey:@"username"];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = NSLocalizedString(@"点击登录", @"");
        }
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"总资产"];
        cell.textLabel.text = NSLocalizedString(@"总资产折合", @"");
        float balance_cny = [[[[_accountDict objectForKey:@"balance"] objectForKey:@"cny"] objectForKey:@"amount"] floatValue];
        float balance_btc = [[[[_accountDict objectForKey:@"balance"] objectForKey:@"btc"] objectForKey:@"amount"] floatValue];
        float frozen_cny = [[[[_accountDict objectForKey:@"frozen"] objectForKey:@"cny"] objectForKey:@"amount"] floatValue];
        float frozen_btc = [[[[_accountDict objectForKey:@"frozen"] objectForKey:@"btc"] objectForKey:@"amount"] floatValue];
        float last = [[[[BTDataManager shared].tickerDict objectForKey:@"ticker"] objectForKey:@"last"] floatValue];
        if (last) {
            float all = balance_cny + balance_btc*last + frozen_cny + frozen_btc*last;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",all];
        }else{
            if ([BTDataManager shared].userAccessKey) {
                cell.detailTextLabel.text = NSLocalizedString(@"计算中...", @"");
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",0.00];
            }
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"人民币"];
        cell.textLabel.text = NSLocalizedString(@"人民币", @"");
        NSString *amount = [NSString stringWithFormat:@"%@",[[[_accountDict objectForKey:@"balance"] objectForKey:@"cny"] objectForKey:@"amount"]];
        if (amount) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",[amount floatValue]];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"比特币"];
        cell.textLabel.text = NSLocalizedString(@"比特币", @"");
        NSString *amount = [NSString stringWithFormat:@"%@",[[[_accountDict objectForKey:@"balance"] objectForKey:@"btc"] objectForKey:@"amount"]];
        if (amount) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"฿%.3f",[amount floatValue]];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"人民币"];
        cell.textLabel.text = NSLocalizedString(@"人民币", @"");
        NSString *amount = [NSString stringWithFormat:@"%@",[[[_accountDict objectForKey:@"frozen"] objectForKey:@"cny"] objectForKey:@"amount"]];
        if (amount) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",[amount floatValue]];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"比特币"];
        cell.textLabel.text = NSLocalizedString(@"比特币", @"");
        NSString *amount = [NSString stringWithFormat:@"%@",[[[_accountDict objectForKey:@"frozen"] objectForKey:@"btc"] objectForKey:@"amount"]];
        if (amount) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"฿%.3f",[amount floatValue]];
        }
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"cell_icon_info"];
        cell.textLabel.text = NSLocalizedString(@"更多", @"");
        cell.textLabel.textColor = nil;
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"退账户"];
        cell.textLabel.text = NSLocalizedString(@"退出账户", @"");
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"用户名", @"")] && [cell.detailTextLabel.text isEqualToString:NSLocalizedString(@"点击登录", @"")]) {
        BTLoginTVC *loginTVC = [[BTLoginTVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginTVC];
        [self.navigationController presentViewController:nav animated:YES completion:NULL];
    }
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"退出账户", @"")]) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"确认退出账户？", @"")
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                          destructiveButtonTitle:NSLocalizedString(@"退出", @"")
                                               otherButtonTitles:nil];
        as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
            if ([title isEqualToString:NSLocalizedString(@"退出", @"")]) {
                [UICKeyChainStore removeAllItems];
                [BTDataManager shared].userAccessKey = nil;
                [BTDataManager shared].userSecretkey = nil;
                [self handleRefresh:nil];
                [[DHActionManager shared] showAndHideHUDWithTitle:NSLocalizedString(@"账户已退出", @"") detailText:nil inView:self.view];
            }
        };
        [as showInView:[UIApplication sharedApplication].keyWindow];
    }
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"更多", @"")]) {
        TCSettingsVC *vc = [[TCSettingsVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
