//
//  WJEditImageListController.h
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WJEditImageListControllerDelegate <NSObject>

// 储存
- (void)WJExtImageFileControllerDidSave;

@end

@interface WJEditImageListController : UIViewController

@property (nonatomic,weak) id<WJEditImageListControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
