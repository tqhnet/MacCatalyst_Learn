//
//  FileListCell.m
//  testAAA
//
//  Created by xj_mac on 2021/9/18.
//

#import "FileListCell.h"
#import <WJKit.h>
@interface FileListCell()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *exportButton;


@end

@implementation FileListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.exportButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.exportButton.frame = CGRectMake(self.width - 100, 0, 100, 20);
    self.titleLabel.frame = CGRectMake(15, 0, self.width- 100 - 100, 20);
    self.exportButton.centerY = self.height/2;
    self.titleLabel.centerY = self.height/2;
}

- (void)setModel:(FileListModel *)model {
    _model = model;
    if(model.isDirectory){
        self.titleLabel.text = [NSString stringWithFormat:@"[文件夹] %@",model.title];
    }else {
        self.titleLabel.text = model.title;
    }
    
//    self.exportButton.hidden = model.isDirectory;
   
    
}


- (void)exportButtonPressed {
    if (self.exportBlock) {
        self.exportBlock();
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_exportButton setTitle:@"操作" forState:UIControlStateNormal];
//        _exportButton.hidden = YES;
        [_exportButton addTarget:self action:@selector(exportButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exportButton;
}

@end
