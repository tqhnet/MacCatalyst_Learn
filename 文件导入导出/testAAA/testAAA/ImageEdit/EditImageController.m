//
//  EditImageController.m
//  testAAA
//
//  Created by xj_mac on 2021/10/12.
//

#import "EditImageController.h"
#import "EditImageView.h"

@interface EditImageController ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSMutableArray *editImageViewArray;
@property (nonatomic,strong) UIView *tapView;

@end

@implementation EditImageController

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


- (void)addImage:(UIImage *)image {
    UIImage *img = image;
    EditImageView *editImgView = [[EditImageView alloc] initWithFrame:CGRectMake(100, 100, img.size.width, img.size.height)];
    editImgView.center = self.view.center;
    editImgView.image = img;
    [self.bgView addSubview:editImgView];
    [self.editImageViewArray addObject:editImgView];
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
    for (EditImageView *editImgView in self.editImageViewArray) {
        [editImgView hideEditBtn];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"tttttttt");
    [self.view endEditing:YES];
    [self hideAllBtn];
}

- (void)removeEdit:(NSNotification *)notify{
    EditImageView *editImgView = notify.object;
    [self.editImageViewArray removeObject:editImgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - lazy

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
