//
//  BCTradeAPIKit.h
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-11-27.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTradeAPIKit : NSObject

+ (BCTradeAPIKit *)sharedAPIKit;
@property (nonatomic,copy)      NSString *accessKey;
@property (nonatomic,copy)      NSString *secretKey;

/**
 *  获取账户信息和余额
 *
 *  @param success
 *  @param failure
 */
- (void)requestAccountInfoSuccess:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  获得全部挂单的状态
 *
 *  @param flag    （非必选）默认为“true”。如果为“true”，仅返回还未完全成交的挂单。(传参失败，暂搁浅)
 *  @param success
 *  @param failure
 */
- (void)requestOrdersSuccess:(void (^)(NSDictionary *result))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  （getDeposits）获得用户全部充值记录
 *
 *  @param currency （必选）目前仅支持“BTC”
 *  @param flag     （非必选）默认为“true”，如果为“true”，仅返回尚未入账的比特币充值
 *  @param success
 *  @param failure
 */
- (void)requestDepositsCurrency:(NSString *)currency
                    pendingOnly:(NSString *)flag
                        success:(void (^)(NSDictionary *result))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  （getMarketDepth2）获得完整的市场深度，返回全部尚未成交的买单和卖单
 *
 *  @param limit    （非必选）限制返回的买卖单数目，默认是买单卖单各10条
 *  @param success
 *  @param failure
 */
- (void)requestMarketDepth2Limit:(NSString *)limit
                         success:(void (^)(NSDictionary *result))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  下比特币“买”单
 *
 *  @param price   （必选）买 1 比特币所用人民币的价格，最多支持小数点后 5 位精度
 *  @param amount  （必选）要买的比特币数量，最多支持小数点后 8 位精度
 *  @param success
 *  @param failure
 */
- (void)requestBuyOrderWithPrice:(NSString *)price
                          amount:(NSString *)amount
                         success:(void (^)(NSDictionary *result))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  下比特币“卖”单
 *
 *  @param price   （必选）卖 1 比特币所用人民币的价格，最多支持小数点后 5 位精度
 *  @param amount  （必选）要卖的比特币数量，最多支持小数点后 8 位精度
 *  @param success
 *  @param failure
 */
- (void)requestSellOrderWithPrice:(NSString *)price
                           amount:(NSString *)amount
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  取消一个还未完全成交的挂单，其状态应该为“open”
 *
 *  @param orderId （必选）要取消的挂单的 ID
 *  @param success
 *  @param failure
 */
- (void)requestCancelOrderWithId:(NSString *)orderId
                         success:(void (^)(NSDictionary *result))success
                         failure:(void (^)(NSError *error))failure;

@end
