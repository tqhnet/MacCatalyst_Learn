//
//  ViewController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/10.
//

#import "ViewController.h"
//#import <AppKit/AppKit.h>

@interface ViewController ()<UIDocumentPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic,copy) NSString *fileName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"点击生成图片资源";
    self.label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    self.fileName = @"test.png";
}

- (NSString *)fileName {
    if (!_fileName) {
        _fileName = @"test.png";
    }
    return _fileName;
}

- (IBAction)buttonPressed:(UIButton *)sender {
   
    NSLog(@"%@",NSHomeDirectory());
//    [self importFile];
    [self exportFile:self.fileName];
}

- (void)importFile {
    NSArray *types = @[]; // 可以选择的文件类型
        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
        documentPicker.delegate = self;
        documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)createFile {
    [self.label.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 800, 800)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc ]initWithFrame:view.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"测试资源";
    label.font = [UIFont systemFontOfSize:100 weight:UIFontWeightBold];
    [view addSubview:label];
    [self createImage:view];

    NSString *path = [NSString stringWithFormat:@"%@",NSHomeDirectory()];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"图片地址" message:path preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"test");
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exportFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    // 保存文件的名称
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    UIDocumentPickerViewController *vccc = [[UIDocumentPickerViewController alloc]initWithURL:[NSURL fileURLWithPath:filePath] inMode:UIDocumentPickerModeExportToService];
    [self presentViewController:vccc animated:YES completion:nil];
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

#pragma mark - others

- (void)createImage:(UIView *)view {
    UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
       format.prefersExtendedRange = YES;
       UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:view.frame.size format:format];
       UIImage *tmpImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
           return [view.layer renderInContext:rendererContext.CGContext];
       }];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.label.bounds];
    imageView.image = tmpImage;
    [self.label addSubview:imageView];
    [self saveFile:self.fileName image:tmpImage];
    
}

- (BOOL)saveFile:(NSString *)fileName image:(UIImage *)image{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL result = [UIImagePNGRepresentation(image) writeToFile: filePath atomically:YES];

    if (result) {
        NSLog(@"保存成功");
        return YES;
    }else{
        NSLog(@"保存失败");
        return NO;
    }
}

/// 创建文件夹
-(BOOL)createDir:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
    BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return res;
    } else return NO;
    
}


@end
