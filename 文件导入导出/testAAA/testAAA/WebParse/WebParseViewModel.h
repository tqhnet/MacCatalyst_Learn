//
//  WebParseViewModel.h
//  testAAA
//
//  Created by xj_mac on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^WebParseViewModelLoadWebBlock)(NSString * url);

@interface WebParseViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *urlArray;
@property (nonatomic,assign) BOOL loadWebLock;  // 锁定加载web用于队列访问

/// 加载内容解析成数组
- (void)loadText:(NSString *)text loadWebBlock:(WebParseViewModelLoadWebBlock)loadWebBlock;

/// 加载完成
- (void)webloadFinish:(NSString *)html;

/// 加载失败
- (void)webloadError;

@end

NS_ASSUME_NONNULL_END
