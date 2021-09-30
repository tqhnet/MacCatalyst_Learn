//
//  FileGroupController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/30.
//

#import "FileGroupController.h"
#import "FileListController.h"
#import "WJFileManager.h"

@interface FileGroupController ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *openDirPath;

@end

@implementation FileGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件分组";
}

- (IBAction)openDirButtonPressed:(UIButton *)sender {
    NSLog(@"aaaaaaaaa");
    FileListController *detail = [[FileListController alloc]init];
    NSString *dirOutputPath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    detail.path = dirOutputPath;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)startButtonPressed:(UIButton *)sender {

    if (![WJFileManager isDirectory:self.openDirPath.text]) {
        self.tipsLabel.text = @"不正确的文件夹路径";
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@OutPut",self.openDirPath.text];
    NSLog(@"%@",path);
    [self changeMove:self.openDirPath.text outPutDirPath:path];
    self.tipsLabel.text = @"完成";
}


#pragma mark - Tool

- (void)changeMove:(NSString *)dirPath outPutDirPath:(NSString *)outPutDirPath {
    NSArray *oldarray = [WJFileManager getAllFileWithDirPath:dirPath];
    NSArray *array = [oldarray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
    return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSInteger index = 0;
    for (int i = 0; i<array.count; i++) {
        //通过移动该文件对文件重命名
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,array[i]];
        if(i % 100==0){
            index ++;
        }
        NSString *pathdir = [NSString stringWithFormat:@"%@/%ld",outPutDirPath,index];
        if([self createDir:pathdir]){
            NSString *moveToPath = [NSString stringWithFormat:@"%@/%@",pathdir,array[i]];
            BOOL isSuccess = [fileManager copyItemAtPath:filePath toPath:moveToPath error:nil];
            if (isSuccess) {
                NSLog(@"成功");
            }else{
                NSLog(@"失败");
            }
        }else {
            NSLog(@"失败");
        }
        double index = i;
        NSLog(@"进度%f,小标%d",index/array.count,i);
    }
}

/// 创建文件夹
-(BOOL)createDir:(NSString *)dirPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = dirPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    } else {
        return YES;
    }
    
}

@end
