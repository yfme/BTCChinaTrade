//
//  BCTradeAPIKit.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-11-27.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BCTradeAPIKit.h"

NSString * const kBCTradeAPIBaseURLString      = @"https://api.btcchina.com/api_trade_v1.php";

@implementation BCTradeAPIKit

+ (BCTradeAPIKit *)sharedAPIKit {
    static BCTradeAPIKit *_sharedAPIKit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPIKit = [[BCTradeAPIKit alloc] init];
    });
    return _sharedAPIKit;
}

/*****************************************************************************************************
 *
 * 详细步骤：
 * 1.创建签名字符串 <signature>（注意是 Since1970）
 * 2.用 <signature> 和 <secretkey>，通过 HMAC-SHA1 算法生成哈希签名 <hash>
 * 3.使用 HTTP Basic Authentication 传递身份验证信息（<accesskey>:<hash>用base64编码，AFJSONRPCClient已包含）
 * 4.将 <Tonce> 也作为 HTTP 头（"Json-Rpc-Tonce"）传递给 API，Tonce 值和 1 中保持一致
 * 5.请求各种 API
 *
 *****************************************************************************************************/


// 获取账户信息和余额
- (void)requestAccountInfoSuccess:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure{
    NSString *accessKey = self.accessKey;
    NSString *secretKey = self.secretKey;
    NSString *method = @"getAccountInfo";
    NSString *params = @"";
    
    NSTimeInterval tonce = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *tonceString = [NSString stringWithFormat:@"%.0f",tonce*1000000];
    NSString *signature = [NSString stringWithFormat:@"tonce=%@&accesskey=%@&requestmethod=post&id=1&method=%@&params=%@", tonceString, accessKey, method, params];
    NSString *hash = [self signHmacSHA1String:signature withKey:secretKey];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:kBCTradeAPIBaseURLString]];
    [client setDefaultHeader:@"Json-Rpc-Tonce" value:tonceString];
    [client setAuthorizationHeaderWithUsername:accessKey password:hash];
    [client invokeMethod:@"getAccountInfo"
          withParameters:nil
               requestId:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

// 获得全部挂单的状态
- (void)requestOrdersSuccess:(void (^)(NSDictionary *result))success
                     failure:(void (^)(NSError *error))failure{
    NSString *accessKey = self.accessKey;
    NSString *secretKey = self.secretKey;
    NSString *method = @"getOrders";
    NSString *params = [NSString stringWithFormat:@"%@",@""];

    NSTimeInterval tonce = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *tonceString = [NSString stringWithFormat:@"%.0f",tonce*1000000];
    NSString *signature = [NSString stringWithFormat:@"tonce=%@&accesskey=%@&requestmethod=post&id=1&method=%@&params=%@", tonceString, accessKey, method, params];
    NSString *hash = [self signHmacSHA1String:signature withKey:secretKey];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:kBCTradeAPIBaseURLString]];
    [client setDefaultHeader:@"Json-Rpc-Tonce" value:tonceString];
    [client setAuthorizationHeaderWithUsername:accessKey password:hash];
    [client invokeMethod:@"getOrders"
          withParameters:nil
               requestId:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

// 获得用户全部充值记录
- (void)requestDepositsCurrency:(NSString *)currency
                    pendingOnly:(NSString *)flag
                        success:(void (^)(NSDictionary *result))success
                        failure:(void (^)(NSError *error))failure{
    NSString *accessKey = self.accessKey;
    NSString *secretKey = self.secretKey;
    NSString *method = @"getDeposits";
    NSString *params = [NSString stringWithFormat:@"%@",currency];
    
    NSTimeInterval tonce = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *tonceString = [NSString stringWithFormat:@"%.0f",tonce*1000000];
    NSString *signature = [NSString stringWithFormat:@"tonce=%@&accesskey=%@&requestmethod=post&id=1&method=%@&params=%@", tonceString, accessKey, method, params];
    NSString *hash = [self signHmacSHA1String:signature withKey:secretKey];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:kBCTradeAPIBaseURLString]];
    [client setDefaultHeader:@"Json-Rpc-Tonce" value:tonceString];
    [client setAuthorizationHeaderWithUsername:accessKey password:hash];
    [client invokeMethod:@"getDeposits"
          withParameters:@[params]
               requestId:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

// （getMarketDepth2）获得完整的市场深度，返回全部尚未成交的买单和卖单
- (void)requestMarketDepth2Limit:(NSString *)limit
                         success:(void (^)(NSDictionary *result))success
                         failure:(void (^)(NSError *error))failure{
    NSString *accessKey = self.accessKey;
    NSString *secretKey = self.secretKey;
    NSString *method = @"getMarketDepth2";
    NSString *params = [NSString stringWithFormat:@"%@",limit?limit:@""];
    
    NSTimeInterval tonce = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *tonceString = [NSString stringWithFormat:@"%.0f",tonce*1000000];
    NSString *signature = [NSString stringWithFormat:@"tonce=%@&accesskey=%@&requestmethod=post&id=1&method=%@&params=%@", tonceString, accessKey, method, params];
    NSString *hash = [self signHmacSHA1String:signature withKey:secretKey];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:kBCTradeAPIBaseURLString]];
    [client setDefaultHeader:@"Json-Rpc-Tonce" value:tonceString];
    [client setAuthorizationHeaderWithUsername:accessKey password:hash];
    [client invokeMethod:@"getMarketDepth2"
          withParameters:limit?@[params]:nil
               requestId:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

#pragma mark - HMAC-SHA1 (NO BASE64)

- (NSString *)signHmacSHA1String:(NSString *)string
                         withKey:(NSString *)key{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [string cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
}

// 下比特币“买”单
- (void)requestBuyOrderWithPrice:(NSString *)price
                          amount:(NSString *)amount
                         success:(void (^)(NSDictionary *result))success
                         failure:(void (^)(NSError *error))failure{
    NSString *accessKey = self.accessKey;
    NSString *secretKey = self.secretKey;
    NSString *method = @"buyOrder";
    NSString *params = [NSString stringWithFormat:@"%@,%@",price,amount];
    
    NSTimeInterval tonce = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *tonceString = [NSString stringWithFormat:@"%.0f",tonce*1000000];
    NSString *signature = [NSString stringWithFormat:@"tonce=%@&accesskey=%@&requestmethod=post&id=1&method=%@&params=%@", tonceString, accessKey, method, params];
    NSString *hash = [self signHmacSHA1String:signature withKey:secretKey];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:kBCTradeAPIBaseURLString]];
    [client setDefaultHeader:@"Json-Rpc-Tonce" value:tonceString];
    [client setAuthorizationHeaderWithUsername:accessKey password:hash];
    [client invokeMethod:@"buyOrder"
          withParameters:@[price,amount]
               requestId:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

// 下比特币“卖”单
- (void)requestSellOrderWithPrice:(NSString *)price
                           amount:(NSString *)amount
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure{
    NSString *accessKey = self.accessKey;
    NSString *secretKey = self.secretKey;
    NSString *method = @"sellOrder";
    NSString *params = [NSString stringWithFormat:@"%@,%@",price,amount];
    
    NSTimeInterval tonce = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *tonceString = [NSString stringWithFormat:@"%.0f",tonce*1000000];
    NSString *signature = [NSString stringWithFormat:@"tonce=%@&accesskey=%@&requestmethod=post&id=1&method=%@&params=%@", tonceString, accessKey, method, params];
    NSString *hash = [self signHmacSHA1String:signature withKey:secretKey];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:kBCTradeAPIBaseURLString]];
    [client setDefaultHeader:@"Json-Rpc-Tonce" value:tonceString];
    [client setAuthorizationHeaderWithUsername:accessKey password:hash];
    [client invokeMethod:@"sellOrder"
          withParameters:@[price,amount]
               requestId:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

// 取消一个还未完全成交的挂单，其状态应该为“open”
- (void)requestCancelOrderWithId:(NSString *)orderId
                         success:(void (^)(NSDictionary *result))success
                         failure:(void (^)(NSError *error))failure{
    NSString *accessKey = self.accessKey;
    NSString *secretKey = self.secretKey;
    NSString *method = @"cancelOrder";
    NSString *params = [NSString stringWithFormat:@"%@",orderId];
    
    NSTimeInterval tonce = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *tonceString = [NSString stringWithFormat:@"%.0f",tonce*1000000];
    NSString *signature = [NSString stringWithFormat:@"tonce=%@&accesskey=%@&requestmethod=post&id=1&method=%@&params=%@", tonceString, accessKey, method, params];
    NSString *hash = [self signHmacSHA1String:signature withKey:secretKey];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:kBCTradeAPIBaseURLString]];
    [client setDefaultHeader:@"Json-Rpc-Tonce" value:tonceString];
    [client setAuthorizationHeaderWithUsername:accessKey password:hash];
    [client invokeMethod:@"cancelOrder"
          withParameters:@[[NSNumber numberWithLongLong:[orderId longLongValue]]]
               requestId:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

@end
