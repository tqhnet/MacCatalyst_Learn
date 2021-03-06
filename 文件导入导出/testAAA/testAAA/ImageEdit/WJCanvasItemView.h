//
//  EditImageView.h
//  WaterMarkDemo
//
//  Created by mac on 16/4/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCanvasItemModel.h"

@class WJCanvasItemView;
@protocol WJCanvasItemViewDelegate <NSObject>

- (void)editImageViewDidTap:(WJCanvasItemView *)view;

@end

@interface WJCanvasItemView : UIImageView{
    BOOL _isMove;
    CGPoint _startTouchPoint;
    CGPoint _startTouchCenter;
//    UIView *_borderView;
    UIImageView *_editImgView;
    UIButton *_closeImgView;
    CGFloat _len;
}

- (void)hideEditBtn;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,weak) id<WJCanvasItemViewDelegate>delegate;

@property (nonatomic,copy) dispatch_block_t tapBlock;

@property (nonatomic,strong) WJCanvasItemModel *model;

- (void)updateView;

@end

