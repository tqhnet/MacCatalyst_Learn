//
//  EditImageController.m
//  testAAA
//
//  Created by xj_mac on 2021/10/12.
//

#import "WJCanvasController.h"
#import "WJCanvasItemView.h"

@interface WJCanvasController ()<WJCanvasItemViewDelegate>

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSMutableArray *editImageViewArray;
@property (nonatomic,strong) UIView *tapView;

@end

@implementation WJCanvasController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEdit:) name:@"remove" object:NULL];
    [self addUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.bgView.frame = self.view.bounds;
    self.tapView.frame = self.view.bounds;
}

- (void)addUI{
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.tapView];
}


//- (void)addImage:(UIImage *)image {
//    UIImage *img = image;
//    WJCanvasItemView *editImgView = [[WJCanvasItemView alloc] initWithFrame:CGRectMake(100, 100, img.size.width, img.size.height)];
//    editImgView.delegate =self;
//    editImgView.center = CGPointMake(self.view.center.x - 50, self.view.center.y);
//    editImgView.image = img;
//    [self.bgView addSubview:editImgView];
//    [self.editImageViewArray addObject:editImgView];
//}

- (WJCanvasItemView *)addModel:(WJCanvasItemModel *)model {
    
    UIImage *img = [UIImage imageWithContentsOfFile:model.filePath];
    WJCanvasItemView *editImgView = [[WJCanvasItemView alloc] initWithFrame:CGRectMake(100, 100, img.size.width, img.size.height)];
    editImgView.delegate =self;
    editImgView.model = model;
    editImgView.center = CGPointMake(self.view.center.x - 50, self.view.center.y);
    editImgView.image = img;
    [self.bgView addSubview:editImgView];
    [self.editImageViewArray addObject:editImgView];
    return editImgView;
}

#pragma mark - <EditImageViewDelegate>

- (void)editImageViewDidTap:(WJCanvasItemView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(wjCanvasControllerDidItem:)]) {
        [self.delegate wjCanvasControllerDidItem:view];
    }
}

#pragma mark - others

- (UIImage *)exportImage {
    [self hideAllBtn];
    CGPoint point = [[_bgView superview] convertPoint:_bgView.frame.origin toView:_bgView];
    CGRect rect = CGRectMake(point.x, point.y, _bgView.frame.size.width, _bgView.frame.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    [_bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}


- (void)hideAllBtn {
    for (WJCanvasItemView *editImgView in self.editImageViewArray) {
        [editImgView hideEditBtn];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"点击空白区域");
    [self.view endEditing:YES];
    [self hideAllBtn];
}

- (void)removeEdit:(NSNotification *)notify{
    WJCanvasItemView *editImgView = notify.object;
    [self.editImageViewArray removeObject:editImgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - layz

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [UIView new];
        _tapView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_tapView addGestureRecognizer:tap];
    }
    return _tapView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor grayColor];
    }
    return _bgView;
}

- (NSMutableArray *)editImageViewArray {
    if (!_editImageViewArray) {
        _editImageViewArray = [NSMutableArray array];
    }
    return _editImageViewArray;;
}

@end
