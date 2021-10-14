//
//  WJExtImageFileCell.m
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import "WJExtImageFileCell.h"

@interface WJExtImageFileCell()

@end

@implementation WJExtImageFileCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setModel:(WJCanvasItemModel *)model {
    _model = model;
    _imageView.image = [UIImage imageWithContentsOfFile:model.filePath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

#pragma mark - layz

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"a.png"];
    }
    return _imageView;
}

@end
