//
//  WJExtImageFileController.m
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import "WJExtImageFileController.h"
#import "WJExtImageFileCell.h"
#import <WJKit.h>

@interface WJExtImageFileController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation WJExtImageFileController

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
    cell.layer.borderWidth = 1;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WJExtImageFileCell *cell = (WJExtImageFileCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(WJExtImageFileControllerDidImage:)]) {
        [self.delegate WJExtImageFileControllerDidImage:cell.imageView.image];
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
