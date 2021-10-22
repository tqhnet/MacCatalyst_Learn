//
//  WebParseController.m
//  testAAA
//
//  Created by xj_mac on 2021/9/30.
//

#import "WebParseController.h"
#import <WebKit/WebKit.h>
#import "WJFileManager.h"
#import <TFHpple.h>
#import <YYModel.h>
#import "WebParseViewModel.h"
#import "WJPathManager.h"
#import <WJKit.h>

//https://www.jianshu.com/p/5cf0d241ae12 这篇文章介绍的比较详细可以参考
//https://www.jianshu.com/p/6e022ccf5aa3 iOS获取WebView加载的HTML
//https://www.jianshu.com/p/06771493001d/ iOS 数据解析之使用TFHpple解析html

@interface WebParseController ()<WKUIDelegate,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,strong) WebParseViewModel *viewModel;
@property (nonatomic,assign) BOOL loadWebLock;  // 锁定加载web用于队列访问

@end

@implementation WebParseController

- (void)dealloc {
    [[WJPathManager shareManager] closeDB];
//    self.viewModel close
}

- (WebParseViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [WebParseViewModel new];
    }
    return _viewModel;;
}

- (void)rightItemPressed {
    return;
    
    NSLog(@"地址:%@",self.path);
    NSData *data = [NSData dataWithContentsOfFile:self.path];
    NSLog(@"%@",data);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
//    NSString *xpath = @"//*[@id=\"J_GoodsList\"]/ul/li";
    //gl-i-wrap
    //gl-item
    NSArray *dataArr = [xpathParser searchWithXPathQuery:@"//div[@class='gl-i-wrap']"];
//    NSInteger index = 0;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (TFHppleElement *element in dataArr) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        // 价格
        TFHppleElement *price = [element firstChildWithClassName:@"p-price"];
        NSString *str = [self stringDeleteblankSpace:price.content];
//        NSLog(@"%@",str);
        
        [dic setObject:str forKey:@"price"];
        
        // 标题
        TFHppleElement *nameE = [element firstChildWithClassName:@"p-name p-name-type-2"];
        TFHppleElement *name = [nameE searchWithXPathQuery:@"//em"][0];
        NSString *str1 = [self stringDeleteblankSpace:name.content];
//        NSLog(@"%@",str1);
        
        [dic setObject:str1 forKey:@"title"];
        
        // 连接地址
        TFHppleElement *img_a = [nameE searchWithXPathQuery:@"//a"][0];
//        NSLog(@"http:%@",img_a.attributes[@"href"]);
        
        [dic setObject:[NSString stringWithFormat:@"http:%@",img_a.attributes[@"href"]] forKey:@"url"];
        
        // 时间
        [dic setObject:@([NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSince1970) forKey:@"time"];
        
        
//        NSLog(@"%@",dic);
        
//        for (TFHppleElement *el in array) {
//            NSString *str = [self stringDeleteblankSpace:el.content];
//            NSLog(@"%@",str);
//        }
//        NSLog(@"%@",array);
        [dataArray addObject:dic];
    }
    
    
//    for (int i = 1; i<array.count; i++) {
//        NSDictionary *dic = array[i];
//        [dataArray addObject:dic];
//    }
    NSString *dataString = [dataArray yy_modelToJSONString];
    NSString *dir = [WJFileManager createDir:@"webParse" isDocuments:YES];
    CGFloat time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    NSString *file = [NSString stringWithFormat:@"%@/%f.json",dir,time] ;
    [dataString writeToFile:file atomically:YES];
    NSLog(@"地址 = %@",file);
}

- (NSString *)stringDeleteblankSpace:(NSString *)countString{
    
    NSString *string=[countString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去除首位空格
    string = [string stringByReplacingOccurrencesOfString:@" "withString:@""];//去除中间空格
    string = [string stringByReplacingOccurrencesOfString:@"\n"withString:@""];//去除换行符
    return  string;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"点击" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemPressed)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSString *dir = [WJFileManager createDir:@"webParse" isDocuments:YES];
    NSString *path = [NSString stringWithFormat:@"%@/jd.html",dir];
    NSLog(@"京东地址 = %@",path);
    self.path = path;
    
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
//    设置视频是否需要用户手动播放  设置为NO则会允许自动播放
//    config.requiresUserActionForMediaPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    
    self.textField.text = @"https://www.jianshu.com/u/e163bc6048d8";
//    [self loadUrl:self.textField.text];

    //\nhttps://search.jd.com/Search?keyword=pc\nhttps://www.jianshu.com/u/e163bc6048d8
    NSString *str = @"switch,pc";
//    NSString *message = [NSString stringWithFormat:@"路径 = %@",self.path];
    [self.viewModel loadText:str loadWebBlock:^(NSString * _Nonnull url) {
        self.textField.text = url;
        [self loadUrl:url];
    }finish:^(NSString *message){
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:message cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
    }];
}

- (void)loadUrl:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

/// 刷新网页
- (IBAction)refreshButtonPressed:(UIButton *)sender {
//    [self loadUrl:@"https://search.jd.com/Search?keyword=switch"];
    [self loadUrl:self.textField.text];
}

/// 下一步
- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self.webView goForward];
}

/// 上一步
- (IBAction)lastButtonPressed:(UIButton *)sender {
   
    [self.webView goBack];
}


#pragma mark - <WKUIDelegate>

/**
     *  web界面中有弹出警告框时调用
     *
     *  @param webView           实现该代理的webview
     *  @param message           警告框中的内容
     *  @param completionHandler 警告框消失调用
     */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    // 确认框
    //JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    // 输入框
    //JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

    // 页面是弹出窗口 _blank 处理(没写这个点击当前页面刷新可能就是被拦截了哦)
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//- shouldStartLoadWithRequest

#pragma mark - <WKNavigationDelegate>


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//[self.progressView setProgress:0.0f animated:NO];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//[self getCookie];
    
    NSString *str = [NSString stringWithFormat:@"%ld",navigation.effectiveContentMode];
    NSLog(@"页面加载完成-%@",str);
    
//    [self.viewModel webloadFinish];
    
    [webView evaluateJavaScript:@"document.getElementsByTagName('html')[0].innerHTML" completionHandler:^(id data, NSError * _Nullable error) {
        NSString *html = data;
        [self.viewModel webloadFinish:html];
        
//        NSString *dir = [WJFileManager createDir:@"webParse" isDocuments:YES];
//        NSString *path = [NSString stringWithFormat:@"%@/jd.html",dir];
//        [html writeToFile:path atomically:YES encoding:NSUTF16StringEncoding error:nil];
    }];
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//[self.progressView setProgress:0.0f animated:NO];
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

NSString * urlStr = navigationAction.request.URL.absoluteString;
NSLog(@"发送跳转请求：%@",urlStr);
//自己定义的协议头
NSString *htmlHeadString = @"github://";
if([urlStr hasPrefix:htmlHeadString]){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
        [[UIApplication sharedApplication] openURL:url];
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    decisionHandler(WKNavigationActionPolicyCancel);
}else{
    decisionHandler(WKNavigationActionPolicyAllow);
}
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //用户身份信息
    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
    //为 challenge 的发送方提供 credential
    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
}
//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
}

@end

