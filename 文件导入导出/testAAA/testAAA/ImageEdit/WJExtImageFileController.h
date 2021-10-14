//
//  WJExtImageFileController.h
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import <UIKit/UIKit.h>
#import "WJCanvasItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WJExtImageFileControllerDelegate <NSObject>

@optional
- (void)WJExtImageFileControllerDidImage:(UIImage *)image;
- (void)wjExtImageFileControllerDidModel:(WJCanvasItemModel *)model;

@end

@interface WJExtImageFileController : UIViewController

@property (nonatomic,weak) id<WJExtImageFileControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
