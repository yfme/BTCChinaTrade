//
//  BTLoginTVC.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-9.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTLoginTVC.h"

@interface BTLoginTVC () <RETableViewManagerDelegate>
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETextItem *accessKeyItem;
@property (strong, readwrite, nonatomic) RETextItem *secretKeyItem;
@end

@implementation BTLoginTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"登录", @"");
    }
    return self;
}

- (void)leftItemClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", @"") style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked:)];

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    [self addLoginSection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLoginSection{
    RETableViewSection *section = [RETableViewSection section];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 8)];
    section.footerView = footerView;
    [_manager addSection:section];
    
    RETextItem *accessKeyItem = [RETextItem itemWithTitle:NSLocalizedString(@"Access Key:", @"") value:@"" placeholder:@"访问密匙"];
    RETextItem *secretKeyItem = [RETextItem itemWithTitle:NSLocalizedString(@"Secret Key:", @"") value:@"" placeholder:@"秘密密匙"];
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:NSLocalizedString(@"登录", @"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        if ([_accessKeyItem.value isEqualToString:@""] || [_secretKeyItem.value isEqualToString:@""]) {
            [[DHActionManager shared] showAndHideHUDWithTitle:NSLocalizedString(@"提示", @"") detailText:NSLocalizedString(@"密匙不能为空", @"") inView:self.view];
            return;
        }
        self.hud = [[DHActionManager shared] showHUDWithTitle:Nil detailText:Nil inView:self.view];
        _hud.mode = MBProgressHUDModeIndeterminate;
        [BCTradeAPIKit sharedAPIKit].accessKey = _accessKeyItem.value;
        [BCTradeAPIKit sharedAPIKit].secretKey = _secretKeyItem.value;
        [[BCTradeAPIKit sharedAPIKit] requestAccountInfoSuccess:^(NSDictionary *result) {
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = NSLocalizedString(@"登录成功！", @"");
            _hud.detailsLabelText = NSLocalizedString(@"祝您投资顺利！", @"");
            
            [BTDataManager shared].userAccessKey = _accessKeyItem.value;
            [BTDataManager shared].userSecretkey = _secretKeyItem.value;
            NSString *encryptedAccesskey = [FBEncryptorAES encryptBase64String:_accessKeyItem.value
                                                                     keyString:@"y0ngf00"
                                                                 separateLines:NO];
            NSString *encryptedSecretkey = [FBEncryptorAES encryptBase64String:_secretKeyItem.value
                                                                     keyString:@"y0ngf00"
                                                                 separateLines:NO];
            [UICKeyChainStore setString:encryptedAccesskey forKey:@"accesskey"];
            [UICKeyChainStore setString:encryptedSecretkey forKey:@"secretkey"];
            double delayInSeconds1 = 1.8;
            dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
            dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        } failure:^(NSError *error) {
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = NSLocalizedString(@"登录失败", @"");
            _hud.detailsLabelText = NSLocalizedString(@"请您核对密匙是否填写正确", @"");
            [UICKeyChainStore removeAllItems];
            double delayInSeconds1 = 1.8;
            dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
            dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }];
        
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:accessKeyItem];
    [section addItem:secretKeyItem];
    self.accessKeyItem = accessKeyItem;
    self.secretKeyItem = secretKeyItem;
    
    RETableViewSection *btnSection = [RETableViewSection section];
    UIView *btnHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
    btnSection.headerView = btnHeaderView;
    [_manager addSection:btnSection];
    [btnSection addItem:buttonItem];
    
    RETableViewSection *blankSection = [RETableViewSection section];
    [_manager addSection:blankSection];

    RETableViewSection *blankSection1 = [RETableViewSection section];
    [_manager addSection:blankSection1];
    
    RETableViewSection *blankSection2 = [RETableViewSection section];
    [_manager addSection:blankSection2];

    RETableViewSection *textSection = [RETableViewSection section];
    textSection.headerTitle = NSLocalizedString(@"密匙：\n• 请访问 BTCCHINA 官网获取密匙对\n• 官网 - 账户管理 - API 访问 - 创建 API 密匙对\n\n说明：\n• 您的密匙被加密保存于系统 KEYCHAIN 中\n• 我们不以任何形式上传你的密匙\n• 您随时可以在 BTCChina 回收密匙", @"");
    [_manager addSection:textSection];
    
    RETableViewSection *helpPicSection = [RETableViewSection section];
    [_manager addSection:helpPicSection];
    UIView *helpFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    helpPicSection.headerView = helpFooterView;
    helpFooterView.backgroundColor = [UIColor clearColor];
    
    UIImageView *helpPic0 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 95, 95)];
    helpPic0.image = [UIImage imageNamed:@"login_0"];
    [helpFooterView addSubview:helpPic0];
    
    UIImageView *helpPic1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(helpPic0.frame)+5, 5, 190, 95)];
    helpPic1.image = [UIImage imageNamed:@"login_1"];
    [helpFooterView addSubview:helpPic1];
    
    UIImageView *helpPic2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(helpPic1.frame)+5, 290, 114)];
    helpPic2.image = [UIImage imageNamed:@"login_2"];
    [helpFooterView addSubview:helpPic2];
}

@end
