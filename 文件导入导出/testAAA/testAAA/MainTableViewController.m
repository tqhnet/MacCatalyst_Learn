//
//  MainTableViewController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/18.
//

#import "MainTableViewController.h"
#import "FileListController.h"
#import "DownImageController.h"
#import "FileGroupController.h"
#import "WebParseController.h"


@interface MainTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIDocumentPickerDelegate>

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSString *fileName;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"3333333");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.dataArray addObjectsFromArray:@[@"导入文件",@"查看目录",@"文字转图片",@"批量下载图片",@"将文件分组",@"网页解析"]];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    }
    return _tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.dataArray[indexPath.row];
    if ([string isEqualToString:@"导入文件"]) {
        self.fileName = @"test";
        [self importFile];
    }else if ([string isEqualToString:@"查看目录"]){
        FileListController *detail = [[FileListController alloc]init];
        NSString *dirOutputPath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
        detail.path = dirOutputPath;
        [self.navigationController pushViewController:detail animated:YES];
    }else if ([string isEqualToString:@"文字转图片"]){
        [self gotoCreatImage];
    }else if ([string isEqualToString:@"批量下载图片"]){
        [self gotoDownImage];
    }else if ([string isEqualToString:@"将文件分组"]){
        FileGroupController *group = [[FileGroupController alloc]init];
        [self.navigationController pushViewController:group animated:YES];
    }else if ([string isEqualToString:@"网页解析"]){
        [self gotoWebParse];
    }
}


#pragma mark - push vc

- (void)gotoCreatImage{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"createImageVc"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoWebParse{
    WebParseController *web = [[WebParseController alloc]initWithNibName:@"WebParseController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:web animated:YES];
}


- (void)importFile {
    NSArray *types = @[]; // 可以选择的文件类型
        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
        documentPicker.delegate = self;
        documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)gotoDownImage{
    DownImageController *vc = [[DownImageController alloc]initWithNibName:@"DownImageController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <UIDocumentPickerDelegate>

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls API_AVAILABLE(ios(11.0)){
    NSURL *url = urls[0];
    BOOL canAccessingResource = [url startAccessingSecurityScopedResource];
    if(canAccessingResource) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            NSData *fileData = [NSData dataWithContentsOfURL:newURL];
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = [arr lastObject];
            NSString *desFileName = [documentPath stringByAppendingPathComponent:self.fileName];
            NSLog(@"导入的文件路径%@",desFileName);
            [fileData writeToFile:desFileName atomically:YES];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        if (error) {
            // error handing
        }
    } else {
        // startAccessingSecurityScopedResource fail
    }
    [url stopAccessingSecurityScopedResource];
    
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"取消");
}

@end
