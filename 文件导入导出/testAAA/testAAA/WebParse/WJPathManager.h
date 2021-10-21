//
//  WJPathManager.h
//  testAAA
//
//  Created by xj_mac on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import <JQFMDB.h>
//NS_ASSUME_NONNULL_BEGIN

//￥
@interface WJParseJDDBModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign) CGFloat time;
@property (nonatomic,copy) NSString *tag;
@end


/// 文件路径管理
@interface WJPathManager : NSObject

@property (nonatomic,strong) JQFMDB *db; //只有一个

+ (instancetype)shareManager;

- (BOOL)openWebParseDB;


- (void)closeDB;

@end

//NS_ASSUME_NONNULL_END
