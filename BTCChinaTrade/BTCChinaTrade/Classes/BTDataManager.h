//
//  BTDataManager.h
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-9.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTDataManager : NSObject
@property (nonatomic, strong) NSString *userAccessKey;
@property (nonatomic, strong) NSString *userSecretkey;
@property (nonatomic, strong) NSDictionary *tickerDict;
@property (nonatomic ,assign) float highPrice;
@property (nonatomic ,assign) float lowPrice;
@property (nonatomic ,assign) float lastPrice;
+ (BTDataManager *)shared;
@end
