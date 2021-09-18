//
//  FileListModel.h
//  testAAA
//
//  Created by xj_mac on 2021/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileListModel : NSObject

@property (nonatomic,copy) NSString *title;//文件名
@property (nonatomic,copy) NSString *path;//路径
@property (nonatomic,assign) BOOL isDirectory;//路径

@end

NS_ASSUME_NONNULL_END


