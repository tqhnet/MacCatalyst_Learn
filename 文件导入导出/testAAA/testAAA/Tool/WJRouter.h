//
//  WJRouter.h
//  testAAA
//
//  Created by xj_mac on 2021/10/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WJRouterAPI.h"

@interface WJRouter : NSObject

+ (void)gotoController:(UIViewController *)controller name:(NSString *)name params:(NSDictionary *)params;

@end

