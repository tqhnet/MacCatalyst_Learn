//
//  WJRouter.m
//  testAAA
//
//  Created by xj_mac on 2021/10/16.
//

#import "WJRouter.h"
#import "FileListController.h"
#import "WJRouterAPI.h"
#import <YYModel.h>
#import "WJFileManager.h"

@implementation WJRouter

+ (void)gotoController:(UIViewController *)controller name:(NSString *)name params:(NSDictionary *)params {
    
    if ([name isEqualToString:WJRouterAPI_fileList]) {
        FileListController *vc = [[FileListController alloc]init];
        if (params == nil) {
            FileListParamsModel *model = [FileListParamsModel new];
            model.path = [WJFileManager getDocumentsPath];
            vc.paramsmodel = model;
            
        }else {
            vc.paramsmodel = [FileListParamsModel yy_modelWithJSON:params];
        }
        
        [controller.navigationController pushViewController:vc animated:YES];
    }
}

@end
