//
//  EditImageView.m
//  WaterMarkDemo
//
//  Created by mac on 16/4/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WJCanvasItemView.h"
#import <WJKit.h>
#import "UITextView+CMInputView.h"

@interface WJCanvasItemView()

@property (nonatomic,strong) UIView *borderView;
@property (nonatomic,strong) UIButton *closeButton;

@end

@implementation WJCanvasItemView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        CGFloat space = 20;
        self.borderView.frame =CGRectMake(space, space, frame.size.width-space*2, frame.size.height-space*2);
        [self addSubview:self.borderView];
        [self addUI];
        self.textView.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setModel:(WJCanvasItemModel *)model {
    _model = model;
    [self updateView];
}

- (void)updateView {
    self.textView.font = [UIFont systemFontOfSize:self.model.fontSize weight:UIFontWeightBold];
    self.textView.textColor = [UIColor colorWithHexString:self.model.colorString];
}

- (void)addUI{
    CGFloat space = 20;
    UIView *borderView = self.borderView;
    
    UIImage *editImg = [UIImage imageNamed:@"Enlarge.png"];
    UIImageView *editImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-editImg.size.width/2-5, -space, editImg.size.width, editImg.size.height)];
    editImgView.image = editImg;
    editImgView.center = CGPointMake(borderView.frame.origin.x+borderView.frame.size.width, borderView.frame.origin.y);
    [self addSubview:editImgView];
    _editImgView = editImgView;
    
//    UIImage *norImage = [UIImage imageNamed:@"Close.png"];
//    UIImage *selImage = [UIImage imageNamed:@"Close.png"];
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeBtn.frame = CGRectMake(1, self.frame.size.height - space, norImage.size.width, norImage.size.height);
//    [closeBtn setImage:norImage forState:UIControlStateNormal];
//    [closeBtn setImage:selImage forState:UIControlStateHighlighted];
//    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:closeBtn];
//    closeBtn.center = CGPointMake(borderView.frame.origin.x, borderView.frame.origin.y+borderView.frame.size.height);
//    _closeImgView = closeBtn;
    
    [self addSubview:self.closeButton];
    _closeImgView = self.closeButton;
    
   _len = sqrt(self.frame.size.width/2*self.frame.size.width/2+self.frame.size.height/2*self.frame.size.height/2);
    
    self.textView.frame = borderView.frame;
    [self addSubview:self.textView];

}


- (void)closeBtnClick:(UIButton *)btn{
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:self];
}

- (void)showEditBtn{
    _borderView.hidden = NO;
    _editImgView.hidden = NO;
    _closeImgView.hidden = NO;
    
   
    
}
- (void)hideEditBtn{
    _borderView.hidden = YES;
    _editImgView.hidden = YES;
    _closeImgView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editImageViewDidTap:)]) {
        [self.delegate editImageViewDidTap:self];
    }
    [self showEditBtn];
    UITouch *touch = [touches anyObject];
    _startTouchPoint = [touch locationInView:self.superview];
    _startTouchCenter = self.center;
    _isMove = YES;
    CGPoint p = [touch locationInView:self];
//    NSLog(@"ttddddddddd----- %@   %@",NSStringFromCGRect(_editImgView.frame),NSStringFromCGPoint(p));
    if (CGRectContainsPoint(_editImgView.frame,p)) {
        _isMove = NO;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editImageViewDidTap:)]) {
        [self.delegate editImageViewDidTap:self];
    }
//    NSLog(@"touchesMoved");
    if (_isMove) {
        CGPoint curPoint = [[touches anyObject] locationInView:self.superview];
        self.center =  CGPointMake(curPoint.x-(_startTouchPoint.x-_startTouchCenter.x), curPoint.y-(_startTouchPoint.y-_startTouchCenter.y));

        
    }else{
        CGPoint curPoint = [[touches anyObject] locationInView:self.superview];
        CGFloat sx = curPoint.x - self.center.x;
        CGFloat sy = curPoint.y - self.center.y;
        CGFloat curLen = sqrtf(sx*sx+sy*sy);
        CGFloat scale = curLen/_len;
        CGFloat tan = atanf(sy/sx);  //取到弧度
        CGFloat angle = tan * 180/M_PI;
        if (sx >= 0) {
            angle = angle + 45;
        }else{
            angle = angle + 225;
        }
        
        _editImgView.transform = CGAffineTransformMakeScale(1.0f/scale, 1.0f/scale);
        _closeImgView.transform = CGAffineTransformMakeScale(1.0f/scale, 1.0f/scale);
        _borderView.layer.borderWidth = 2*1.0f/scale;

        CGFloat rad = angle/180*M_PI;
        self.transform = CGAffineTransformMakeScale(scale, scale);
        self.transform = CGAffineTransformRotate(self.transform,rad);
//        self.transform = CGAffineTransformMakeRotation(ra);
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isMove = NO;
}

- (void)layoutSubviews {
    
    CGFloat space = 20;
    
    self.borderView.frame =CGRectMake(space, space, self.frame.size.width-space*2, self.frame.size.height-space*2);
    self.textView.frame = self.borderView.frame;
    self.closeButton.frame = CGRectMake(0, 0, 30, 30);
    self.closeButton.center = CGPointMake(self.borderView.frame.origin.x, self.borderView.frame.origin.y+self.borderView.frame.size.height);
}


#pragma mark - layz

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectZero];
        _textView.font = [UIFont systemFontOfSize:50 weight:UIFontWeightBold];
        _textView.textColor = [UIColor redColor];
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        UIImage *norImage = [UIImage imageNamed:@"Close.png"];
        [_closeButton setImage:norImage forState:UIControlStateNormal];
        [_closeButton setImage:norImage forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [UIView new];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
        _borderView.layer.borderWidth = 2;
        _borderView.layer.masksToBounds = YES;
    }
    return _borderView;
}

@end

