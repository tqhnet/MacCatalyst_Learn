//
//  WJCanvasItemModel.h
//  testAAA
//
//  Created by xj_mac on 2021/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// item的数据源（用于持久化操作）
@interface WJCanvasItemModel : NSObject

@property (nonatomic,assign) CGRect rect;           // 数据大小
@property (nonatomic,assign) BOOL showText;         // 是否显示文本
@property (nonatomic,assign) NSString *colorString; // 字体颜色
@property (nonatomic,assign) NSInteger fontSize;    // 字体大小
@property (nonatomic,copy) NSString *filePath;      // 文件路径

@end

NS_ASSUME_NONNULL_END
