//
//  WJFileManager.m
//  testAAA
//
//  Created by xj_mac on 2021/9/14.
//

#import "WJFileManager.h"

@implementation WJFileManager

+ (void)exportFileFromPath:(NSString *)filePath controller:(UIViewController *)controller {

    UIDocumentPickerViewController *vccc = [[UIDocumentPickerViewController alloc]initWithURL:[NSURL fileURLWithPath:filePath] inMode:UIDocumentPickerModeExportToService];
    [controller presentViewController:vccc animated:YES completion:nil];
}

+ (NSArray *)getAllFileWithDirPath:(NSString *)dirPath {
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath error:nil];
    return files;
}

+ (NSArray *)getCurrentDirectoryFileWithDirPath:(NSString *)dirPath {
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    return files;
}

+ (BOOL)isDirectory:(NSString *)filePath
{
  BOOL isDirectory = NO;
  [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
  return isDirectory;
}


- (void)createDir:(NSString *)dirName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //test文件夹
    documentsDir = [documentsDir stringByAppendingPathComponent:dirName];
    //是否是文件夹
    BOOL isDir;
    BOOL isExit = [fileManager fileExistsAtPath:documentsDir isDirectory:&isDir];
    //文件夹是否存在
    if (!isExit || !isDir) {
        [fileManager createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)deleteDir:(NSString *)dirName {
    //删除Wtdb文件夹
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *wtdbPath = [cachesDir stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:wtdbPath]) {
        BOOL isSuccess = [fileManager removeItemAtPath:wtdbPath error:nil];
    }
}

- (void)move {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
    NSString *moveToPath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    if (isSuccess) {
        NSLog(@"rename success");
    }else{
        NSLog(@"rename fail");
    }
}

//
//
//+ (UIViewController *)findCurrentShowingViewController {
//    //获得当前活动窗口的根视图
//    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
//    return currentShowingVC;
//}
//
////注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
///* 完整的描述请参见文件头部 */
//+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
//{
//    //方法1：递归方法 Recursive method
//    UIViewController *currentShowingVC;
//    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
//        // 当前视图是被presented出来的
//        UIViewController *nextRootVC = [vc presentedViewController];
//        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
//
//    } else if ([vc isKindOfClass:[UITabBarController class]]) {
//        // 根视图为UITabBarController
//        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
//        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
//
//    } else if ([vc isKindOfClass:[UINavigationController class]]){
//        // 根视图为UINavigationController
//        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
//        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
//
//    } else {
//        // 根视图为非导航类
//        currentShowingVC = vc;
//    }
//
//    return currentShowingVC;
//
//    /*
//    //方法2：遍历方法
//    while (1)
//    {
//        if (vc.presentedViewController) {
//            vc = vc.presentedViewController;
//
//        } else if ([vc isKindOfClass:[UITabBarController class]]) {
//            vc = ((UITabBarController*)vc).selectedViewController;
//
//        } else if ([vc isKindOfClass:[UINavigationController class]]) {
//            vc = ((UINavigationController*)vc).visibleViewController;
//
//        //} else if (vc.childViewControllers.count > 0) {
//        //    //如果是普通控制器，找childViewControllers最后一个
//        //    vc = [vc.childViewControllers lastObject];
//        } else {
//            break;
//        }
//    }
//    return vc;
//    //*/
//}


@end
