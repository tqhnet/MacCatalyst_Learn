//
//  WebParseController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/30.
//

#import "WebParseController.h"
#import <WebKit/WebKit.h>

@interface WebParseController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WebParseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config  = self.webView.configuration;
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.requiresUserActionForMediaPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    
    [self loadUrl:@"https://www.baidu.com"];
}

- (void)loadUrl:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

/// 刷新网页
- (IBAction)refreshButtonPressed:(UIButton *)sender {
    [self loadUrl:@"https://www.jianshu.com"];
//    [self loadUrl:self.textField.text];
}

/// 下一步
- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self.webView goBack];
}

/// 上一步
- (IBAction)lastButtonPressed:(UIButton *)sender {
    [self.webView goForward];
}


@end

