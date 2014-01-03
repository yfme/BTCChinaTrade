//
//  BTOrder.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-11.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTOrder.h"

@implementation BTOrder
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount": @"amount",
             @"amount_original": @"amount_original",
             @"currency": @"currency",
             @"date": @"date",
             @"order_id": @"id",
             @"price": @"price",
             @"status": @"status",
             @"type": @"type"
             };
}
@end
