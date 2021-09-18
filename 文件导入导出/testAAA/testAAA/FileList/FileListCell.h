//
//  FileListCell.h
//  testAAA
//
//  Created by xj_mac on 2021/9/18.
//

#import <UIKit/UIKit.h>
#import "FileListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileListCell : UITableViewCell

@property (nonatomic,strong) FileListModel *model;
@property (nonatomic,copy) dispatch_block_t exportBlock;


@end

NS_ASSUME_NONNULL_END
