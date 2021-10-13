//
//  EditImageController.h
//  testAAA
//
//  Created by xj_mac on 2021/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 绘制板
@interface EditImageController : UIViewController

/// 添加贴图元素
- (void)addImage:(UIImage *)image;

- (UIImage *)exportImage;

@end

NS_ASSUME_NONNULL_END
