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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,copy) NSString *fileName;

@end

@implementation ViewController

// ios修改图片尺寸的方法 https://www.jianshu.com/p/ba45f5539e4e
- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"点击批量转换";
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
    
//    NSString *path = [NSString stringWithFormat:@"%@/Documents/UE4/1.png",NSHomeDirectory()];
//    NSString *outputpath = [NSString stringWithFormat:@"%@/Documents/Output/1.png",NSHomeDirectory()];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *tmpImage = [UIImage getThumImgOfConextWithData:data withMaxPixelSize:800];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.label.bounds];
//    imageView.image = tmpImage;
//    [self.label addSubview:imageView];
    
//    NSString *dirPath = [NSString stringWithFormat:@"%@/Documents/UE4",NSHomeDirectory()];
//    NSString *dirSCVPath = [NSString stringWithFormat:@"%@/Documents/CSV",NSHomeDirectory()];
//    NSString *dirOutputPath = [NSString stringWithFormat:@"%@/Documents/Output",NSHomeDirectory()];
    
//    NSArray *array = [WJFileManager getAllFileWithDirPath:dirPath];
//    NSLog(@"%@",array);
    
//    YYCGImageCreateDecodedCopy(<#CGImageRef  _Nonnull imageRef#>, <#BOOL decodeForDisplay#>)
//
//    for (int i = 0; i<array.count; i++) {
//        NSString *path = [NSString stringWithFormat:@"%@/%@",dirPath,array[i]];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        UIImage *tmpImage = [UIImage getThumImgOfConextWithData:data withMaxPixelSize:800];
//        NSString *outputPath =  [NSString stringWithFormat:@"%@/%@",dirOutputPath,array[i]];
//        outputPath = [outputPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
//        BOOL result = [UIImageJPEGRepresentation(tmpImage, 0.8) writeToFile: outputPath atomically:YES];
//        if (result) {
//            NSLog(@"成功");
//        }else {
//            NSLog(@"失败名字=%@",array[i]);
//        }
//    }
    
    
    
    
    
//    NSArray *array = [self parseCSV:[NSString stringWithFormat:@"%@/%@",dirSCVPath,@"虚幻插件.csv"]];
//
//    for (int i = 0; i<array.count; i++) {
//
//        NSDictionary *dic = array[i];
////        NSLog(@"%@",dic);
//        NSString *name = dic[@"名称"];
//        NSString *url = dic[@"URL"];
//        NSString *outputPath =  [NSString stringWithFormat:@"%@/%@.jpg",dirOutputPath,name];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        UIImage *tmpImage = [UIImage imageWithData:data];
////        UIImage *tmpImage = [UIImage getThumImgOfConextWithData:data withMaxPixelSize:800];
//        BOOL result = [UIImageJPEGRepresentation(tmpImage, 0.8) writeToFile: outputPath atomically:YES];
//        if (result) {
//            NSLog(@"成功");
//        }else {
//            NSLog(@"失败名字=%@",array[i]);
//        }
//    }
    [self createFile];
    NSLog(@"完成");
}

// 因为有特殊字符
- (void)findAllReourceAndRname{
    NSString *dirOutputPath = [NSString stringWithFormat:@"%@/Documents/2021_9_15",NSHomeDirectory()];
    NSArray *array = [WJFileManager getAllFileWithDirPath:dirOutputPath];
    for (int i = 0; i<array.count; i++) {
        //通过移动该文件对文件重命名
//        NSString *documentsPath =[self getDocumentsPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirOutputPath,array[i]];
        NSString *str = array[i];
        if([str containsString:@":"]||[str containsString:@"："]){
            NSString *moveToPath = [filePath stringByReplacingOccurrencesOfString:@":" withString:@" "];
            moveToPath = [moveToPath stringByReplacingOccurrencesOfString:@"：" withString:@" "];
            BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
            if (isSuccess) {
                NSLog(@"成功");
            }else{
                NSLog(@"失败");
            }
        }
        double index = i;
        NSLog(@"进度%f,小标%d",index/array.count,i);
    }
    
}

- (void)changeMove{
    NSString *dirOutputPath = [NSString stringWithFormat:@"%@/Documents/2021_9_15",NSHomeDirectory()];
    NSArray *array = [WJFileManager getAllFileWithDirPath:dirOutputPath];
    NSInteger index = 0;
    for (int i = 0; i<array.count; i++) {
        //通过移动该文件对文件重命名
//        NSString *documentsPath =[self getDocumentsPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirOutputPath,array[i]];
//        NSString *str = array[i];
        if(i % 100==0){
            index ++;
        }
        NSString *pathdir = [NSString stringWithFormat:@"%@/%ld",dirOutputPath,index];
        NSLog(@"%@",pathdir);
        if([self createDir:pathdir]){
            NSString *moveToPath = [NSString stringWithFormat:@"%@/%@",pathdir,array[i]];
            BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
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


- (NSArray *)parseCSV:(NSString *)url{
    NSMutableArray *array = [NSMutableArray array];
    NSString *filepath = url;
       FILE *fp = fopen([filepath UTF8String], "r");
       if (fp) {
           char buf[BUFSIZ];
           fgets(buf, BUFSIZ, fp);
           NSString *a = [[NSString alloc] initWithUTF8String:(const char *)buf];
           NSString *aa = [a stringByReplacingOccurrencesOfString:@"\r" withString:@""];
           aa = [aa stringByReplacingOccurrencesOfString:@"\n" withString:@""];
          //获取的是表头的字段
           NSArray *b = [aa componentsSeparatedByString:@","];
           
           while (!feof(fp)) {
               char buff[BUFSIZ];
               fgets(buff, BUFSIZ, fp);
               //获取的是内容
               NSString *s = [[NSString alloc] initWithUTF8String:(const char *)buff];
               NSString *ss = [s stringByReplacingOccurrencesOfString:@"\r" withString:@""];
               ss = [ss stringByReplacingOccurrencesOfString:@"\n" withString:@""];
               NSArray *a = [ss componentsSeparatedByString:@","];
               
               NSMutableDictionary *dic = [NSMutableDictionary dictionary];
               for (int i = 0; i < b.count ; i ++) {
                  //组成字典数组
                   dic[b[i]] = a[i];
               }
               
               [array addObject:dic];
           }
       }
       
       NSLog(@"%@",array);
    return array;
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
    BOOL result = [UIImageJPEGRepresentation(image, 0.8) writeToFile: filePath atomically:YES];

    if (result) {
        NSLog(@"保存成功");
        return YES;
    }else{
        NSLog(@"保存失败");
        return NO;
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
