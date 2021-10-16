//
//  WJFileManager.h
//  testAAA
//
//  Created by xj_mac on 2021/9/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WJFileManager : NSObject

+ (instancetype)shareManager;

/// 获取沙盒路径
+ (NSString *)getDocumentsPath;

// 获取当前以及子目录所有文件
+ (NSArray *)getAllFileWithDirPath:(NSString *)dirPath;

// 获取当前目录所有文件
+ (NSArray *)getCurrentDirectoryFileWithDirPath:(NSString *)dirPath;

// 是否是文件夹
+ (BOOL)isDirectory:(NSString *)filePath;

/// 导出文件
+ (void)exportFileFromPath:(NSString *)filePath controller:(UIViewController *)controller;
/// 创建文件目录
+ (NSString *)createDir:(NSString *)dirName isDocuments:(BOOL)isDocuments;

- (void)importFileWithController:(UIViewController *)vc filePath:(NSString *)filePath types:(NSArray *)types finishBlock:(dispatch_block_t)finishBlock;

@end

NS_ASSUME_NONNULL_END
