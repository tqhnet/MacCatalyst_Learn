//
//  WJExtImageFileController.h
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WJExtImageFileControllerDelegate <NSObject>


- (void)WJExtImageFileControllerDidImage:(UIImage *)image;

@end

@interface WJExtImageFileController : UIViewController

@property (nonatomic,weak) id<WJExtImageFileControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
