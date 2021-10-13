//
//  ViewController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/10.
//

#import "ViewController.h"
#import "WJSpiderManager.h"
#import "UIImage+WJExt.h"
#import "WJFileManager.h"
#import "FileListController.h"
#import "WJExtImageFileController.h"
#import "EditImageController.h"
#import <WJKit.h>
#import "WJEditImageListController.h"
@interface ViewController ()<WJExtImageFileControllerDelegate,WJEditImageListControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,strong) WJExtImageFileController *fileController;
@property (nonatomic,strong) EditImageController *canvasController;
@property (nonatomic,strong) WJEditImageListController *editController;

@end

@implementation ViewController

// ios修改图片尺寸的方法 https://www.jianshu.com/p/ba45f5539e4e
- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"点击批量转换";
    self.label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    self.fileName = @"test.png";
    
    self.fileController = [[WJExtImageFileController alloc]init];
    self.fileController.delegate = self;
    self.canvasController = [[EditImageController alloc]init];
    
    
    [self.view addSubview:self.canvasController.view];
    [self.view addSubview:self.fileController.view];
    [self.view addSubview:self.editController.view];
    
    
    [self addChildViewController:self.canvasController];
    [self addChildViewController:self.fileController];
    [self addChildViewController:self.editController];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.canvasController.view.frame = CGRectMake(0, 0, self.view.width - 200, self.view.height);
    self.editController.view.frame = CGRectMake(0, 0, 100, self.view.height);
    self.fileController.view.frame = CGRectMake(self.view.frame.size.width - 200, 0, 200, self.view.frame.size.height);
}

- (NSString *)fileName {
    if (!_fileName) {
        _fileName = @"test.png";
    }
    return _fileName;
}

- (IBAction)buttonPressed:(UIButton *)sender {
   
//    NSLog(@"%@",NSHomeDirectory());
//
//    [self createFile];
//    NSLog(@"完成");
}



//- (void)createFile {
//    [self.label.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 800, 800)];
//    view.backgroundColor = [UIColor blackColor];
//    UILabel *label = [[UILabel alloc ]initWithFrame:view.bounds];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor blackColor];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"测试资源";
//    label.font = [UIFont systemFontOfSize:100 weight:UIFontWeightBold];
//    [view addSubview:label];
//    [self createImage:view];
//
//    NSString *path = [NSString stringWithFormat:@"%@",NSHomeDirectory()];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"图片地址" message:path preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"test");
//    }];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:nil];
//}

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
    NSLog(@"%@",filePath);
    BOOL result = [UIImageJPEGRepresentation(image, 0.8) writeToFile: filePath atomically:YES];

    if (result) {
        NSLog(@"保存成功");
        return YES;
    }else{
        NSLog(@"保存失败");
        return NO;
    }
}


#pragma mark - <右侧栏 WJExtImageFileControllerDelegate>

- (void)WJExtImageFileControllerDidImage:(UIImage *)image {
    [self.canvasController addImage:image];
}

#pragma mark - <左侧栏 WJEditImageListControllerDelegate>

- (void)WJExtImageFileControllerDidSave {
    UIImage *image = [self.canvasController exportImage];
    [self saveFile:self.fileName image:image];
}

#pragma mark - layz

- (WJEditImageListController *)editController {
    if (!_editController) {
        _editController = [[WJEditImageListController alloc]init];
        _editController.delegate = self;
    }
    return _editController;
}

@end
