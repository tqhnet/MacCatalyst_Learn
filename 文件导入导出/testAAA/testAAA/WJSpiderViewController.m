//
//  WJSpiderViewController.m
//  testAAA
//
//  Created by xj_mac on 2021/10/20.
//

#import "WJSpiderViewController.h"
#import "WJSpiderManager.h"

@interface WJSpiderViewController ()

@end

@implementation WJSpiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [PPNetworkHelper openLog];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self requestjd];
}

- (void)requestjd {
//    NSString *url = @"https://api.m.jd.com/client.action?functionId=search";
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"1" forKey:@"bef"];
//    [dic setObject:@"" forKey:@"body"];
//    [PPNetworkHelper POST:url parameters:dic success:^(id responseObject) {
//        NSLog(@"成功");
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    WJSpiderManager *spider = [[WJSpiderManager alloc]init];
    NSString *url = @"https://search.jd.com/Search?keyword=switch";
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",data);
    } failure:^(NSError *error) {
        NSLog(@"请求出错");
        NSLog(@"%@",error);

    }];
    
}

@end
