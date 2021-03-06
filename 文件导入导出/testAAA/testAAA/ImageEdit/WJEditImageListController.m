//
//  WJEditImageListController.m
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import "WJEditImageListController.h"
#import "WJExtImageFileCell.h"
#import <WJKit.h>

@interface WJEditImageListController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation WJEditImageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.lineView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    self.lineView.frame = CGRectMake(0, 0, 1, self.view.frame.size.height);
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WJExtImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"edit_save.png"];
    cell.layer.borderWidth = 1;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(WJExtImageFileControllerDidSave)]) {
        [self.delegate WJExtImageFileControllerDidSave];
    }
}

#pragma mark - lazy

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(80, 80);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
        [_collectionView registerClass:[WJExtImageFileCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _collectionView;;
}
@end
