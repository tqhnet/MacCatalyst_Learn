//
//  WJSpiderManager.m
//  testAAA
//
//  Created by xj_mac on 2021/9/14.
//

#import "WJSpiderManager.h"
#import "TFHpple.h"
#import <WJKit.h>
#import <YYModel.h>

@implementation WJSpiderManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        [PPNetworkHelper openLog];
        [PPNetworkHelper setResponseSerializer:PPResponseSerializerHTTP];
        [PPNetworkHelper setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36" forHTTPHeaderField:@"user-agent"];
        // af不验证证书:https://www.jianshu.com/p/e727fc5d08ea
        [PPNetworkHelper setAFHTTPSessionManagerProperty:^(AFHTTPSessionManager *sessionManager) {
            sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            sessionManager.securityPolicy.allowInvalidCertificates = YES;
            [sessionManager.securityPolicy setValidatesDomainName:NO];
        }];
    }
    return self;
}

- (void)setCookie:(NSString *)cookie {
    [PPNetworkHelper setValue:cookie forHTTPHeaderField:@"Cookie"];
}


- (void)requestUE4 {
    NSString *url = @"https://www.unrealengine.com/marketplace/zh-CN/content-cat/assets/blueprints?count=20&sortBy=currentPrice&sortDir=DESC&start=0";
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",data);
    } failure:^(NSError *error) {
        NSLog(@"请求出错");
        NSLog(@"%@",error);
//        errorBlock();
    }];
}



@end
