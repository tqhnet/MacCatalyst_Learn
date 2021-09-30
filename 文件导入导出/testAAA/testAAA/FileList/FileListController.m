//
//  FileListController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/18.
//

#import "FileListController.h"
#import "WJFileManager.h"
#import "FileListCell.h"

@interface FileListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation FileListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"退出选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSLog(@"path = %@",self.path);
    NSArray *array = [WJFileManager getCurrentDirectoryFileWithDirPath:self.path];

    [self.view addSubview:self.tableView];
    
    for (int i = 0; i<array.count; i++) {
        FileListModel *model = [FileListModel new];
        NSString *path =[NSString stringWithFormat:@"%@/%@",self.path,array[i]];
        model.title = array[i];
        model.path = path;
        if([WJFileManager isDirectory:path]){
            model.isDirectory = YES;
        }
        [self.dataArray addObject:model];
    }
    
    [self.dataArray sortUsingComparator:^NSComparisonResult(FileListModel *  _Nonnull obj1, FileListModel*  _Nonnull obj2) {
        if (!obj1.isDirectory)
         {
             return NSOrderedDescending;
         }
         else
         {
             return NSOrderedAscending;
         }
    }];
    
    
    self.title = [self.path stringByReplacingOccurrencesOfString:NSHomeDirectory() withString:@""];
}

- (void)rightItemButtonPressed {
    NSArray *array = self.navigationController.viewControllers;
    NSInteger index = 0;
    for (int i = 0 ; i <array.count; i++) {
        if ([array[i] isKindOfClass:[FileListController class]]) {
            index = i;
            break;
        }
    }
    if (index != 0) {
        [self.navigationController popToViewController:array[index-1] animated:YES];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileListModel *model = self.dataArray[indexPath.row];
    FileListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.model = model;
    [cell setExportBlock:^{
        [self showMoreAlert:model];
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FileListModel *model = self.dataArray[indexPath.row];
    NSString *path = model.path;
    if(model.isDirectory){
        FileListController *detail = [FileListController new];
        detail.path = path;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

/// 显示弹窗
- (void)showMoreAlert:(FileListModel *)model{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择对应的操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"复制路径" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.path;
        [self rightItemButtonPressed];
    }];
    [alert addAction:action];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"导出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WJFileManager exportFileFromPath:model.path controller:self];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FileListCell class] forCellReuseIdentifier:@"cellId"];
    }
    return _tableView;
}

@end

