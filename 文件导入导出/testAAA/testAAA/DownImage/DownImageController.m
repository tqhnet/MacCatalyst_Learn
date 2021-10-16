//
//  DownImageController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/19.
//

#import "DownImageController.h"
#import "WJFileManager.h"
#import <WJKit.h>
#import "WJRouter.h"
#import <JQFMDB/JQFMDB.h>


@interface UEDataModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *imageUrl;

@end

@implementation UEDataModel

@end

@interface DownImageController ()
@property (weak, nonatomic) IBOutlet UITextField *csvPathTextField;
@property (weak, nonatomic) IBOutlet UITextField *outPutTextField;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic,copy) NSString *suffix;

@property (nonatomic,strong) JQFMDB *db;//同事只能打开一个数据库

@end

@implementation DownImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.suffix = @".csv";
}

/// 导出分组
- (IBAction)exportGroupButtonPressed:(UIButton *)sender {
    
//    [self changeMove:@"" outPutDirPath:@""];
}

/// 下载测试模板
- (IBAction)downButtonPressed:(UIButton *)sender {
   NSString *str = [self writJson:@[@{@"title":@"头像",@"imageUrl":@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0119d95c482e8fa801213f26847b0f.jpg%402o.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1635559515&t=66b25ac82899e9b3497ffb28a3a5c363"}]];
    if (str) {
        [WJFileManager exportFileFromPath:str controller:self];
    }else {
        self.progressLabel.text = @"数据不正确";
    }
}

/// 开始执行下载图片
- (IBAction)doneButtonPressed:(UIButton *)sender {
    
    NSString *suffix = self.suffix;
    self.progressLabel.textColor = [UIColor blackColor];
    NSString *csvPath = self.csvPathTextField.text;
    NSString *outPutPath = self.outPutTextField.text;
    if (![csvPath containsString:suffix]) {
        self.progressLabel.text = [NSString stringWithFormat:@"不是%@文件",suffix];
        self.progressLabel.textColor = [UIColor redColor];
        return;
    }
    
    if(outPutPath.length != 0){
        if (![WJFileManager isDirectory:outPutPath]) {
            self.progressLabel.text = @"输出目录不正确";
            self.progressLabel.textColor = [UIColor redColor];
            return;
        }
    }else {
        outPutPath = [csvPath stringByReplacingOccurrencesOfString:suffix withString:@""];
        if (![WJFileManager isDirectory:outPutPath]) {
            [self createDir:outPutPath];
        }
    }
    
    
    NSArray *array = [self parseCSV:csvPath];
    double index = 0;
    for (int i = 0; i< array.count; i++) {

        NSDictionary *dic = array[i];
        NSString *name = dic[@"title"];
        NSString *url = dic[@"imageUrl"];
        if([name containsString:@":"]||[name containsString:@"："]){// 过滤字符串
            name = [name stringByReplacingOccurrencesOfString:@":" withString:@" "];
        }
        NSString *outputPath =  [NSString stringWithFormat:@"%@/%@.jpg",outPutPath,name];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *tmpImage = [UIImage imageWithData:data];
        BOOL result = [UIImageJPEGRepresentation(tmpImage, 0.8) writeToFile: outputPath atomically:YES];
        if (result) {
            NSLog(@"成功");
        }else {
            NSLog(@"失败名字=%@",array[i]);
        }
        index ++;
        CGFloat progress = index/array.count;
        NSString *str = [NSString stringWithFormat:@"下载进度%.2f",progress];
        NSLog(@"%@",str);
        self.progressLabel.text = str;
    }
    
}
- (IBAction)getPathButtonPressed:(UIButton *)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = filePath;
    self.progressLabel.text = @"提示：沙盒路径已经复制到粘贴板,使用前往文件夹打开";
}


/// 自动检查字段

- (IBAction)autoCheckDataButton:(UIButton *)sender {
    NSArray *array = [self parseCSV:self.csvPathTextField.text];
    NSMutableArray *keyArray = [NSMutableArray array];
    NSMutableString *string = [[NSMutableString alloc]init];
    if (array.count>0) {
        NSDictionary *dic = array[0];
        for (int i = 0; i<[dic allKeys].count; i++) {
            NSString *key = [dic allKeys][i];
            [keyArray addObject:key];
            [string appendString:key];
            [string appendString:@","];
        }
        self.progressLabel.text = string;
    }else {
        self.progressLabel.text = @"没有识别到";
    }
}

/// 悬着文件路径
- (IBAction)importFileButton:(UIButton *)sender {
    [WJRouter gotoController:self name:WJRouterAPI_fileList params:nil];
}


/// 导入文件
- (IBAction)importButton:(UIButton *)sender {
    
    NSString *dir = [NSString stringWithFormat:@"%@/%@",[WJFileManager getDocumentsPath],@"csv.csv"];
    [[WJFileManager shareManager]importFileWithController:self filePath:dir types:@[] finishBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.csvPathTextField.text = dir;
        });
        
    }];
}

// 数据转化为sql
- (IBAction)dataToSqlButtonPressed:(UIButton *)sender {
    NSArray *array = [self parseCSV:self.csvPathTextField.text];
    NSString *dir = [WJFileManager createDir:@"dataTosql" isDocuments:YES];
    self.db = [[JQFMDB shareDatabase]initWithDBName:@"dataTosql.sqlite" path:dir];
    
    if ([self.db jq_isExistTable:@"environment"]) {// 避免录入重复数据
        return;
    }
    bool succes = [self.db jq_createTable:@"environment" dicOrModel:[UEDataModel class]];
    if (succes) {
        
        for (int i = 1; i<array.count; i++) {
            NSDictionary *dic = array[i];
            [self.db jq_insertTable:@"environment" dicOrModel:dic];
        }
    }
}

// 将数据转化为json
- (IBAction)dataToJsonButtonPressed:(UIButton *)sender {
    NSArray *array = [self parseCSV:self.csvPathTextField.text];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 1; i<array.count; i++) {
        NSDictionary *dic = array[i];
        [dataArray addObject:dic];
    }
    NSString *dataString = [dataArray yy_modelToJSONString];
    NSString *dir = [WJFileManager createDir:@"dataTosql" isDocuments:YES];
    CGFloat time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    [dataString writeToFile:[NSString stringWithFormat:@"%@/%f.json",dir,time] atomically:YES];
}

#pragma mark - others

// 因为有特殊字符所以重命名文件目录中的图片
- (void)findAllReourceAndRname:(NSString *)dirOutputPath {
//    NSString *dirOutputPath = [NSString stringWithFormat:@"%@/Documents/2021_9_15",NSHomeDirectory()];
    NSArray *array = [WJFileManager getAllFileWithDirPath:dirOutputPath];
    for (int i = 0; i<array.count; i++) {
        //通过移动该文件对文件重命名
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

/// 切分文件100个一组解决淘宝文件上传的时候不能太多的数量
//- (void)changeMove:(NSString *)dirPath outPutDirPath:(NSString *)outPutDirPath {
//    NSArray *array = [WJFileManager getAllFileWithDirPath:dirPath];
//    NSInteger index = 0;
//    for (int i = 0; i<array.count; i++) {
//        //通过移动该文件对文件重命名
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,array[i]];
//        if(i % 100==0){
//            index ++;
//        }
//        NSString *pathdir = [NSString stringWithFormat:@"%@/%ld",outPutDirPath,index];
//        if([self createDir:pathdir]){
//            NSString *moveToPath = [NSString stringWithFormat:@"%@/%@",pathdir,array[i]];
//            BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
//            if (isSuccess) {
//                NSLog(@"成功");
//            }else{
//                NSLog(@"失败");
//            }
//        }else {
//            NSLog(@"失败");
//        }
//        double index = i;
//        NSLog(@"进度%f,小标%d",index/array.count,i);
//    }
//}


- (NSArray *)parseJson:(NSString *)url {
    // 将文件数据化
//    NSString * path = [NSString stringWithFormat:url];
    NSString *path = [NSString stringWithFormat:@"%@",NSHomeDirectory()];
    NSLog(@"path = %@",path);
    NSLog(@"file = %@",url);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:url]];
    NSLog(@"data = %@",data);
    NSString *result =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@" --- %@",result);
    NSLog(@"22222%@",[result yy_modelToJSONObject]);
    
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

}

- (NSString *)writJson:(NSArray*)json_dic{
            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/myJson.json"];
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
    BOOL a =   [json_data writeToFile:filePath atomically:YES];
    if (a) {
        NSLog(@"路径：%@",filePath);
    }else {
        NSLog(@"存储失败");
    }
    
    return filePath;
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
