//
//  UIImage+WJExt.h
//  testAAA
//
//  Created by xj_mac on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WJExt)

+ (UIImage*) getThumImgOfImgIOWithData:(NSData*)data withMaxPixelSize:(int)maxPixelSize;
+ (UIImage*) getThumImgOfConextWithData:(NSData*)data withMaxPixelSize:(int)maxPixelSize;
@end

NS_ASSUME_NONNULL_END
