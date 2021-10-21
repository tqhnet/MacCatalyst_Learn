//
//  WJPathManager.m
//  testAAA
//
//  Created by xj_mac on 2021/10/21.
//

#import "WJPathManager.h"
#import "WJFileManager.h"

@implementation WJParseJDDBModel

@end

@implementation WJPathManager

+ (instancetype)shareManager {
    static WJPathManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WJPathManager new];
    });
    return manager;
}

- (BOOL)openWebParseDB {
    [self closeDB];
    NSString *dir = [WJFileManager createDir:@"webParse" isDocuments:YES];
    NSLog(@"打开数据库目录:%@",dir);
    self.db =  [[JQFMDB shareDatabase]initWithDBName:@"webParse.sqlite" path:dir];
    BOOL haveDB = [self.db jq_isExistTable:@"jd_data"];
    if (haveDB) {
//        [self.db jq_alterTable:@"jd_data" dicOrModel:[WJParseJDDBModel class]];
        return haveDB;
    }
    bool succes = [self.db jq_createTable:@"jd_data" dicOrModel:[WJParseJDDBModel class]];
    return succes;
}

- (void)closeDB {
    if (self.db) {
        [self.db close];
        self.db = nil;
    }
}

@end
