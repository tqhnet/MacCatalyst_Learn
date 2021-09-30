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

/// 获取沙盒路径
+ (NSString *)getDocumentsPath;
+ (NSArray *)getAllFileWithDirPath:(NSString *)dirPath;
+ (NSArray *)getCurrentDirectoryFileWithDirPath:(NSString *)dirPath;
+ (BOOL)isDirectory:(NSString *)filePath;

/// 导出文件
+ (void)exportFileFromPath:(NSString *)filePath controller:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
