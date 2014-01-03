//
//  BTNotYetOrdersTVC.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-11.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTNotYetOrdersTVC.h"
#import "BTOrder.h"

@interface BTNotYetOrdersTVC ()
@property (nonatomic ,strong) NSMutableArray *orderArray;
@end

@implementation BTNotYetOrdersTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"尚未成交的挂单", @"");
    }
    return self;
}

- (void)handleRefresh:(id)sender
{
    [BCTradeAPIKit sharedAPIKit].accessKey = [BTDataManager shared].userAccessKey;
    [BCTradeAPIKit sharedAPIKit].secretKey = [BTDataManager shared].userSecretkey;
    [[BCTradeAPIKit sharedAPIKit] requestOrdersSuccess:^(NSDictionary *result) {
        NSArray *jsonOrderArray = [result objectForKey:@"order"];
        NSMutableArray *objectOrderArray = [NSMutableArray array];
        for (NSDictionary *dict in jsonOrderArray) {
            BTOrder *order = [MTLJSONAdapter modelOfClass:[BTOrder class] fromJSONDictionary:dict error:nil];
            [objectOrderArray addObject:order];
        }
        _orderArray = objectOrderArray;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = NSLocalizedString(@"订单更新可以会有延迟，请勿重复下单", @"");
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.font = [UIFont systemFontOfSize:15];
    return headerLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    BTOrder *order = _orderArray[indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[order.date doubleValue]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *typeString = [order.type isEqualToString:@"bid"]?@"买入":@"卖出";
    cell.textLabel.text = [NSString stringWithFormat:@"%@ | %@ | ฿%.3f | ¥%.2f",dateString,typeString,[order.amount floatValue],[order.price floatValue]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BTOrder *order = _orderArray[indexPath.row];
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"确认撤销此单？", @"")
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                      destructiveButtonTitle:NSLocalizedString(@"确认", @"")
                                           otherButtonTitles:nil];
    as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:NSLocalizedString(@"确认", @"")]) {
            MBProgressHUD *hud = [[DHActionManager shared] showHUDWithTitle:Nil detailText:Nil inView:self.view];
            hud.mode = MBProgressHUDModeIndeterminate;
            [[BCTradeAPIKit sharedAPIKit] requestCancelOrderWithId:order.order_id success:^(NSDictionary *result) {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"撤单成功", @"");
                double delayInSeconds1 = 1.8;
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                });
                [self handleRefresh:nil];
            } failure:^(NSError *error) {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"撤单失败", @"");
                double delayInSeconds1 = 1.8;
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                });
            }];
        }
    };
    [as showInView:[UIApplication sharedApplication].keyWindow];
}

@end
