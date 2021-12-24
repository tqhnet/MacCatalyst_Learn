//
//  ChangeTextController.m
//  testAAA
//
//  Created by xj_mac on 2021/12/24.
//

#import "ChangeTextController.h"
#import <WJKit.h>
#import <YYModel.h>

@interface ChangeTextController ()

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inputSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outputSegment;

@end

@implementation ChangeTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)startButton:(UIButton *)sender {
    
    //P_title=%E9%9B%B6%3A%E6%BF%A1%E9%B8%A6%E4%B9%8B%E5%B7%AB%E5%A5%B3+%E6%94%AF%E6%8C%814K%2F%E5%AE%98%E6%96%B9%E4%B8%AD%E6%96%87%2F%E6%95%B4%E5%90%881.0.4%E6%95%B0%E4%BD%8D%E8%B1%AA%E5%8D%8E%E7%89%88%2B%E5%85%A8DLC%2B%E7%89%B9%E5%85%B8%E8%8E%B1%E8%8E%8E&picpic1_0=http%3A%2F%2Fimgs.ali213.net%2Foday%2Fuploadfile%2F2021%2F10%2F28%2F202110289310331.jpg&P_price=1.00&P_vip=1&P_price3=0.00&P_limit=0.00&P_limitlong=0&P_limittime=2021-12-22+13%3A33%3A58&P_sort=26&P_view=105&P_time=2021-12-10+00%3A00%3A00&P_sold=0&P_order=0&P_sh=1&P_selltype=0&P_sell%5B%5D=%E7%99%BE%E5%BA%A6%EF%BC%9Ahttps%3A%2F%2Fpan.baidu.com%2Fs%2F1aRaVjL94QJ9s4BQ2Ctvl3A%0D%0A%E6%8F%90%E5%8F%96%E7%A0%81%EF%BC%9Ak5hk%0D%0A%E8%A7%A3%E5%8E%8B%E7%A0%81%2F%E5%AE%89%E8%A3%85%E7%A0%81+417768%0D%0A&P_sell%5B%5D=0&P_rest=100&name=name&mobile=mobile&address=address&P_keywords=&P_description=&P_code=&P_unlogin=0&P_fx=1&P_taobao=&P_video=&P_vshow=0&P_tag=&P_shuxing=&msgmsg1_0=%E7%94%B5%E5%AD%90%E9%82%AE%E7%AE%B1&msgmsg2_0=&msgmsg3_0=text&msgmsg4_0=0&msgmsg1_1=%E7%BB%99%E5%8D%96%E5%AE%B6%E7%95%99%E8%A8%80&msgmsg2_1=&msgmsg3_1=textarea&msgmsg4_1=0&P_bz=&P_content=%E4%B8%AD%E6%96%87%E8%AE%BE%E7%BD%AE%EF%BC%9A%3Cbr+%2F%3E%0D%0A%E6%89%93%E5%BC%80%E6%B8%B8%E6%88%8F%E6%A0%B9%E7%9B%AE%E5%BD%95%E4%B8%8B+%E7%94%A8%E8%AE%B0%E4%BA%8B%E6%9C%AC%E6%89%93%E5%BC%80steam_emu.ini%3Cbr+%2F%3E%0D%0A%E6%89%BE%E5%88%B0Language%3Denglish%3Cbr+%2F%3E%0D%0A%E6%94%B9%E4%B8%BALanguage%3DSChinese%3Cbr+%2F%3E%0D%0A%3Cbr+%2F%3E%0D%0A%E8%BF%9B%E5%85%A5%E6%B8%B8%E6%88%8F%E8%AE%BE%E7%BD%AE%E9%87%8C%E9%9D%A2%E5%B0%B1%E6%9C%89+%E4%B8%AD%E6%96%87%3Cbr+%2F%3E&
    NSString *str = @"";
    str = self.inputTextView.text;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *array = [str componentsSeparatedByString:@"&"];
    for (int i = 0; i<array.count; i++) {
        NSString *arrString = array[i];
        if ([arrString containsString:@"="]) {//如果有=
            NSArray *arr = [arrString componentsSeparatedByString:@"="];
            NSString *value = [arr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"%@",value);
            NSString *key = arr[0];
            if(key.length>0){
                [dic setObject:value forKey:key];
            }
        }
    }
//    NSLog(@"%@",dic);
    NSMutableString *mString = [NSMutableString string];
    for (NSString *key in dic.allKeys) {
        NSString *value = dic[key];
        value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSString *str = [NSString stringWithFormat:@"%@:%@\n",key,value];
        [mString appendString:str];
    }
    
    NSString *res = nil;
//
    
    switch (self.outputSegment.selectedSegmentIndex) {
        case 0:
            res = mString;
            break;
        case 1:
            res = [dic yy_modelToJSONString];
            break;
        default:
            res = @"输出错误!";
            break;
    }
    self.outputTextView.text = res;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
