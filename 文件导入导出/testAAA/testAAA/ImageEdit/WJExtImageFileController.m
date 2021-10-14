//
//  WJExtImageFileController.m
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import "WJExtImageFileController.h"
#import "WJExtImageFileCell.h"
#import <WJKit.h>
#import "WJFileManager.h"

@interface WJExtImageFileController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *importButton; // 导入
@property (nonatomic,strong) NSString *filePath;
@end

@implementation WJExtImageFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.lineView];
    
    NSString *path = [WJFileManager createDir:@"editImage" isDocuments:YES];
    NSArray *array = [WJFileManager getCurrentDirectoryFileWithDirPath:path];
    
    self.filePath = path;
    
    for (int i = 0; i<array.count; i++) {
        WJCanvasItemModel *model = [WJCanvasItemModel new];
        model.filePath = [NSString stringWithFormat:@"%@/%@",path,array[i]];
        [self.dataArray addObject:model];
    }
    [self.collectionView reloadData];
    
    [self.view addSubview:self.importButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.importButton.frame = CGRectMake(0, 80, 60, 30);
    self.collectionView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 30);
    self.lineView.frame = CGRectMake(0, 0, 1, self.view.frame.size.height);
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WJExtImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(wjExtImageFileControllerDidModel:)]) {
        [self.delegate wjExtImageFileControllerDidModel:self.dataArray[indexPath.row]];
    }
}

#pragma mark - OnClick

- (void)importButtonPressed {
    NSLog(@"导入");
    CGFloat time = [[NSDate dateWithTimeIntervalSinceNow:1] timeIntervalSince1970];
    NSString *path = [NSString stringWithFormat:@"%@/%f",self.filePath,time];
    [[WJFileManager shareManager]importFileWithController:self filePath:path types:@[] finishBlock:^{
        WJCanvasItemModel *model = [WJCanvasItemModel new];
        model.filePath = path;
        [self.dataArray addObject:model];
        [self.collectionView reloadData];
    }];
    

}

#pragma mark - lazy

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

- (UIButton *)importButton {
    if (!_importButton) {
        _importButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_importButton setTitle:@"导入" forState:UIControlStateNormal];
        [_importButton addTarget:self action:@selector(importButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importButton;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
