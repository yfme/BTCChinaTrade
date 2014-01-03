//
//  BTDepthCell.h
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-7.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTDepthCell : UITableViewCell
@property (nonatomic, strong) UILabel *sellPriceLabel;
@property (nonatomic, strong) UILabel *sellAmountLabel;
@property (nonatomic, strong) UILabel *buyPriceLabel;
@property (nonatomic, strong) UILabel *buyAmountLabel;
@property (nonatomic, strong) NSDictionary *buyDict;
@property (nonatomic, strong) NSDictionary *sellDict;
@end
