//
//  EditImageController.h
//  testAAA
//
//  Created by xj_mac on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "WJCanvasItemView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WJCanvasControllerDelegate <NSObject>

- (void)wjCanvasControllerDidItem:(WJCanvasItemView *)view;

@end

/// 绘制板控制器
@interface WJCanvasController : UIViewController

@property (nonatomic,weak) id<WJCanvasControllerDelegate>delegate;


/// 添加贴图元素
//- (void)addImage:(UIImage *)image;

- (WJCanvasItemView *)addModel:(WJCanvasItemModel *)model;


/// 将画板导出为图片
- (UIImage *)exportImage;

@end

NS_ASSUME_NONNULL_END
