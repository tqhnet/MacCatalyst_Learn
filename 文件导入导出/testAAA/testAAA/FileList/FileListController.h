//
//  FileListController.h
//  testAAA
//
//  Created by xj_mac on 2021/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 文件列表查看
@interface FileListParamsModel : NSObject

@property (nonatomic,copy) NSString *path;//路径

@end

@interface FileListController : UIViewController

@property (nonatomic,copy) FileListParamsModel *paramsmodel;

@end



NS_ASSUME_NONNULL_END
