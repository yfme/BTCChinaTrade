//
//  BTDepthCell.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-7.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTDepthCell.h"

@interface BTDepthCell ()

@end

@implementation BTDepthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UILabel *sellPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, 36)];
        sellPriceLabel.backgroundColor = [UIColor clearColor];
        sellPriceLabel.textAlignment = NSTextAlignmentLeft;
        sellPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:sellPriceLabel];
        self.sellPriceLabel = sellPriceLabel;
        
        UILabel *sellAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sellPriceLabel.frame)+5, 0, 65, 36)];
        sellAmountLabel.backgroundColor = [UIColor clearColor];
        sellAmountLabel.textAlignment = NSTextAlignmentRight;
        sellAmountLabel.textColor = [UIColor lightGrayColor];
        sellAmountLabel.font = [UIFont systemFontOfSize:14];
        sellAmountLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:sellAmountLabel];
        self.sellAmountLabel = sellAmountLabel;
        
        UILabel *buyPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0+10, 0, 65, 36)];
        buyPriceLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        buyPriceLabel.backgroundColor = [UIColor clearColor];
        buyPriceLabel.textAlignment = NSTextAlignmentLeft;
        buyPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:buyPriceLabel];
        self.buyPriceLabel = buyPriceLabel;
        
        UILabel *buyAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buyPriceLabel.frame)+5, 0, 65, 36)];
        buyAmountLabel.backgroundColor = [UIColor clearColor];
        buyAmountLabel.textAlignment = NSTextAlignmentRight;
        buyAmountLabel.textColor = [UIColor lightGrayColor];
        buyAmountLabel.font = [UIFont systemFontOfSize:14];
        buyAmountLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:buyAmountLabel];
        self.buyAmountLabel = buyAmountLabel;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBuyDict:(NSDictionary *)buyDict{
    _buyDict = buyDict;
    _buyPriceLabel.text = [NSString stringWithFormat:@"¥%.2f ",[[_buyDict objectForKey:@"price"] floatValue]];
    _buyAmountLabel.text = [NSString stringWithFormat:@"฿%.3f",[[_buyDict objectForKey:@"amount"] floatValue]];
}

- (void)setSellDict:(NSDictionary *)sellDict{
    _sellDict = sellDict;
    _sellPriceLabel.text = [NSString stringWithFormat:@"¥%.2f ",[[_sellDict objectForKey:@"price"] floatValue]];
    _sellAmountLabel.text = [NSString stringWithFormat:@"฿%.3f",[[_sellDict objectForKey:@"amount"] floatValue]];
}

@end
