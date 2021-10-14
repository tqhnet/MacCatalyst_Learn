//
//  WJEditImageInfoController.m
//  testAAA
//
//  Created by xj_mac on 2021/10/13.
//

#import "WJEditImageInfoController.h"

@interface WJEditImageInfoController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *imageXTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageYTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageWTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageHTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageTextFontSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageTextColorTextField;


@property (nonatomic,strong) WJCanvasItemView *canvasItemView;

@end

@implementation WJEditImageInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageXTextField.delegate = self;
    self.imageYTextField.delegate = self;
    self.imageWTextField.delegate = self;
    self.imageHTextField.delegate = self;
}

- (void)loadCanvasIemView:(WJCanvasItemView *)view {
    
    self.canvasItemView = view;
    self.imageXTextField.text = [NSString stringWithFormat:@"%f",view.frame.origin.x];
    self.imageYTextField.text = [NSString stringWithFormat:@"%f",view.frame.origin.y];
    self.imageWTextField.text = [NSString stringWithFormat:@"%f",view.frame.size.width];
    self.imageHTextField.text = [NSString stringWithFormat:@"%f",view.frame.size.height];
    NSInteger fontSize =  view.model.fontSize;
    self.imageTextFontSizeTextField.text = [NSString stringWithFormat:@"%ld",fontSize];
    self.imageTextColorTextField.text = [NSString stringWithFormat:@"%@",view.model.colorString];
}

/// 更新数据
- (IBAction)updateButtonPressed:(UIButton *)sender {
    [self updateCanvas];
    
}

- (IBAction)showTextButton:(UIButton *)sender {
    if (self.canvasItemView) {
        self.canvasItemView.textView.userInteractionEnabled = !self.canvasItemView.textView.userInteractionEnabled;
    }
}


- (void)updateCanvas {
    if (self.canvasItemView) {
        self.canvasItemView.frame =[self itemCGRect];
        self.canvasItemView.model.fontSize = [self.imageTextFontSizeTextField.text intValue];
        self.canvasItemView.model.colorString = self.imageTextColorTextField.text;
        [self.canvasItemView updateView];
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateCanvas];
    return YES;
}

#pragma mark - others

- (CGRect)itemCGRect{
    CGFloat x = [self.imageXTextField.text floatValue];
    CGFloat y = [self.imageYTextField.text floatValue];
    CGFloat w = [self.imageWTextField.text floatValue];
    CGFloat h = [self.imageHTextField.text floatValue];
    return CGRectMake(x, y, w, h);;
}

@end

