//
//  BTDepthTVC.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-7.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTDepthTVC.h"
#import "BTDepthCell.h"

@interface BTDepthTVC ()
@property (nonatomic, strong) NSDictionary *depthResultDict;
@property (nonatomic, strong) NSArray *bidResultArray, *askResultArray;
@property (nonatomic, strong) UILabel *lastPriceLabel;
@property (nonatomic, strong) UILabel *highLowPriceLabel;
@end

@implementation BTDepthTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"行情", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_market"];
    }
    return self;
}

- (void)handleRefresh:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://data.btcchina.com/data/ticker"];
    [[AFHTTPClient clientWithBaseURL:url] getPath:@"" parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tickerDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [BTDataManager shared].tickerDict = tickerDict;
        _lastPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[BTDataManager shared].lastPrice];
        _highLowPriceLabel.text = [NSString stringWithFormat:@"最高 ¥%.2f  |  ¥%.2f 最低",[BTDataManager shared].highPrice,[BTDataManager shared].lowPrice];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
    }];
    
    [BCTradeAPIKit sharedAPIKit].accessKey = @"36583b14-3ed9-47c4-ae54-6ab245b7b38d";
    [BCTradeAPIKit sharedAPIKit].secretKey = @"78ce05b1-9993-45dd-81d4-eb03076f6055";
    [[BCTradeAPIKit sharedAPIKit] requestMarketDepth2Limit:Nil success:^(NSDictionary *result) {
        _depthResultDict = result;
        _bidResultArray = [[_depthResultDict objectForKey:@"market_depth"] objectForKey:@"bid"];
        _askResultArray = [[_depthResultDict objectForKey:@"market_depth"] objectForKey:@"ask"];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadView {
    [super loadView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    self.tableView.tableHeaderView = header;
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *lastPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 30)];
    lastPriceLabel.font = [UIFont systemFontOfSize:25];
    lastPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[BTDataManager shared].lastPrice];
    lastPriceLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:lastPriceLabel];
    self.lastPriceLabel = lastPriceLabel;
    
    UILabel *highLowPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastPriceLabel.frame)+2, 320, 20)];
    highLowPriceLabel.font = [UIFont systemFontOfSize:14];
    highLowPriceLabel.text = [NSString stringWithFormat:@"最高 ¥%.2f  |  ¥%.2f 最低",[[[[BTDataManager shared].tickerDict objectForKey:@"ticker" ] objectForKey:@"high"] floatValue],[[[[BTDataManager shared].tickerDict objectForKey:@"ticker" ] objectForKey:@"low"] floatValue]];
    highLowPriceLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:highLowPriceLabel];
    self.highLowPriceLabel = highLowPriceLabel;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BTDepthCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BTDepthCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.sellPriceLabel.text = NSLocalizedString(@"卖出价", @"");
        cell.sellAmountLabel.text = NSLocalizedString(@"委单量", @"");
        cell.buyPriceLabel.text = NSLocalizedString(@"买入价", @"");
        cell.buyAmountLabel.text = NSLocalizedString(@"委单量", @"");
        return cell;
    }
    
    NSDictionary *buyDict = _bidResultArray[indexPath.row-1];
    NSDictionary *sellDict = _askResultArray[indexPath.row-1];
    [cell setBuyDict:buyDict];
    [cell setSellDict:sellDict];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
