//
//  BTOrder.h
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-11.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "MTLModel.h"

@interface BTOrder : MTLModel <MTLJSONSerializing>
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *amount_original;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;
@end
