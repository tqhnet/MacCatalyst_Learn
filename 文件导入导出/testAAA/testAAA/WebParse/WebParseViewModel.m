//
//  WebParseViewModel.m
//  testAAA
//
//  Created by xj_mac on 2021/10/21.
//

#import "WebParseViewModel.h"
#import "WJPathManager.h"
#import <TFHpple.h>
#import <WJKit.h>

//#import "WJParseJDDBModel"
@interface WebParseViewModel()

@property (nonatomic,strong) dispatch_semaphore_t sema;
@property (nonatomic,copy) NSString *currentUrl;
@property (nonatomic,strong) NSMutableArray *errorArray;
@property (nonatomic,copy) NSString *baseUrl;
@property (nonatomic,copy) NSString *currentTag;// 当前搜索的字段

@end

@implementation WebParseViewModel


/// 加载京东的数据规则
- (void)loadText:(NSString *)text loadWebBlock:(WebParseViewModelLoadWebBlock)loadWebBlock {
    
    self.baseUrl = @"https://search.jd.com/Search?keyword=";
    BOOL success = [[WJPathManager shareManager] openWebParseDB];
    
    if (!success) {
        NSLog(@"创建数据表出错");
        return;
    }
    
    /// 检测时间
    NSArray *arrayDB = [[WJPathManager shareManager].db jq_lookupTable:@"jd_data" dicOrModel:[WJParseJDDBModel class] whereFormat:@"ORDER BY time desc limit 1"];
    if (arrayDB.count>0) {
        WJParseJDDBModel *model = arrayDB[0];
        NSString *time = [NSDate stringForDateWithMDHM:model.time];
        NSLog(@"上次数据时间 = %@",time);
        NSString *now = [NSDate stringForDateWithMDHM:[NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSince1970];
        NSLog(@"当前时间 = %@",now);
        if ([NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSince1970 - model.time <= 600) {
            NSLog(@"距离上次时间不超过10分钟");
            return;
        }
    }
    
    [self.urlArray removeAllObjects];
    // 规则通过逗号判断
    NSArray *array = [text componentsSeparatedByString:@","];
    for (NSString *str in array) {
        [self.urlArray addObject:str];
    }
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        self.sema = dispatch_semaphore_create(0);
        for (int i  = 0; i < self.urlArray.count; i++) {
            NSLog(@"执行----%d",i);
            NSString *str = self.urlArray[i];
            NSString *url = [NSString stringWithFormat:@"%@%@",self.baseUrl,str];
            NSLog(@"%@",url);
            self.currentUrl = url;
            self.currentTag = str;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (loadWebBlock) {
                    loadWebBlock(url);
                }
                //执行了这个需要有个监听器时间太久了的话就是让它自动报错然后记录错误的url
            });
            dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
        }
        NSLog(@"---end--");
        /// 释放
        self.sema = nil;
    });
    
}

#pragma mark - 数据表查询






- (void)webloadFinish:(NSString *)html {
    
    NSData *data =[html dataUsingEncoding:NSUTF8StringEncoding];
    [self parseData:data];
    dispatch_semaphore_signal(self.sema);
}


- (void)parseData:(NSData *)data {
    NSLog(@"准备存入数据库");
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *dataArr = [xpathParser searchWithXPathQuery:@"//div[@class='gl-i-wrap']"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (TFHppleElement *element in dataArr) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        // 价格
        TFHppleElement *price = [element firstChildWithClassName:@"p-price"];
        NSString *str = [self stringDeleteblankSpace:price.content];
//        NSLog(@"%@",str);
        
        str = [str stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        [dic setObject:str forKey:@"price"];
        
        // 标题
        TFHppleElement *nameE = [element firstChildWithClassName:@"p-name p-name-type-2"];
        TFHppleElement *name = [nameE searchWithXPathQuery:@"//em"][0];
        NSString *str1 = [self stringDeleteblankSpace:name.content];
//        NSLog(@"%@",str1);
        
        [dic setObject:str1 forKey:@"title"];
        
        // 连接地址
        TFHppleElement *img_a = [nameE searchWithXPathQuery:@"//a"][0];
//        NSLog(@"http:%@",img_a.attributes[@"href"]);
        [dic setObject:[NSString stringWithFormat:@"http:%@",img_a.attributes[@"href"]] forKey:@"url"];
        
        NSString *string = [NSString stringWithFormat:@"%.3f",[NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSince1970];
        // 时间
        [dic setObject:@([string doubleValue]) forKey:@"time"];
        [dataArray addObject:dic];
        
        // 标记搜索词，用于筛选
        [dic setObject:self.currentTag forKey:@"tag"];
    }
    
    for (NSDictionary *dic in dataArray) {
        [[WJPathManager shareManager].db jq_insertTable:@"jd_data" dicOrModel:dic];
    }
    NSLog(@"存入数据库完成");
}

- (void)webloadError {
    NSLog(@"错误");
    if (self.currentUrl) {
        [self.errorArray addObject:self.currentUrl];
    }
    dispatch_semaphore_signal(self.sema);
}

#pragma mark - others

- (NSString *)stringDeleteblankSpace:(NSString *)countString{
    
    NSString *string=[countString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去除首位空格
    string = [string stringByReplacingOccurrencesOfString:@" "withString:@""];//去除中间空格
    string = [string stringByReplacingOccurrencesOfString:@"\n"withString:@""];//去除换行符
    return  string;
}


#pragma mark - layz

- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (NSMutableArray *)errorArray {
    if (!_errorArray) {
        _errorArray = [NSMutableArray array];
    }
    return _errorArray;
}

@end
