//
//  BTDataManager.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-9.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTDataManager.h"

@implementation BTDataManager

+ (BTDataManager *)shared{
    static BTDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BTDataManager alloc] init];
    });
    return _sharedInstance;
}

- (void)setTickerDict:(NSDictionary *)tickerDict{
    _tickerDict = tickerDict;
    _highPrice = [[[_tickerDict objectForKey:@"ticker"] objectForKey:@"high"] floatValue];
    _lowPrice = [[[_tickerDict objectForKey:@"ticker"] objectForKey:@"low"] floatValue];
    _lastPrice = [[[_tickerDict objectForKey:@"ticker"] objectForKey:@"last"] floatValue];
}

@end
