//
//  ViewController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/10.
//

#import "ViewController.h"
#import "UIImage+WJExt.h"
#import "WJFileManager.h"
#import "FileListController.h"
#import "WJExtImageFileController.h"
#import "WJCanvasController.h"
#import <WJKit.h>
#import "WJEditImageListController.h"
#import "WJEditImageInfoController.h"

@interface ViewController ()<WJExtImageFileControllerDelegate,WJEditImageListControllerDelegate,WJCanvasControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,strong) WJExtImageFileController *fileController;
@property (nonatomic,strong) WJCanvasController *canvasController;
@property (nonatomic,strong) WJEditImageListController *editController;
@property (nonatomic,strong) WJEditImageInfoController *editInfoController;
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
    self.canvasController = [[WJCanvasController alloc]init];
    self.canvasController.delegate = self;
    
    [self.view addSubview:self.canvasController.view];
    [self.view addSubview:self.fileController.view];
    [self.view addSubview:self.editController.view];
    [self.view addSubview:self.editInfoController.view];
    
    
    [self addChildViewController:self.canvasController];
    [self addChildViewController:self.fileController];
    [self addChildViewController:self.editController];
    [self addChildViewController:self.editInfoController];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.editController.view.frame = CGRectMake(0, 0, 100, self.view.height);
    self.fileController.view.frame = CGRectMake(self.view.frame.size.width - 200, 0, 200, self.view.frame.size.height);
    self.editInfoController.view.frame = CGRectMake(self.editController.view.width, self.view.frame.size.height-300, self.fileController.view.x -self.editController.view.width , 300);
    CGFloat x = self.editController.view.width;
    CGFloat y = 0;
    CGFloat width = self.fileController.view.x - self.editController.view.width;
    CGFloat height = self.editInfoController.view.y;
    
    self.canvasController.view.frame = CGRectMake(x, y, width, height);
}

- (NSString *)fileName {
    if (!_fileName) {
        _fileName = @"test.png";
    }
    return _fileName;
}

- (IBAction)buttonPressed:(UIButton *)sender {
   
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


#pragma mark - <画布 wjCanvasControllerDidItem>

- (void)wjCanvasControllerDidItem:(WJCanvasItemView *)view {
    [self.editInfoController loadCanvasIemView:view];
}

#pragma mark - <右侧栏 WJExtImageFileControllerDelegate>

- (void)wjExtImageFileControllerDidModel:(WJCanvasItemModel *)model {
    WJCanvasItemView *view = [self.canvasController addModel:model];
    [self.editInfoController loadCanvasIemView:view];
    
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

- (WJEditImageInfoController *)editInfoController {
    if (!_editInfoController) {
        _editInfoController = [[WJEditImageInfoController alloc]initWithNibName:@"WJEditImageInfoController" bundle:nil];
        _editInfoController.view.backgroundColor = [UIColor whiteColor];
        _editInfoController.view.layer.borderWidth =1 ;
    }
    return _editInfoController;
}

@end
