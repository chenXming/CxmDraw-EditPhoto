//
//  EditPhotoViewController.m
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/7/26.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "ClipView.h"
#import "TKImageView.h"



@interface EditPhotoViewController ()
{
    UIImageView *_BigImageView;
    UIImageOrientation currentRotate;

}

@property (nonatomic,retain) UIImageView* editImaegView; // 最低部的imageView
@property (nonatomic,retain) TKImageView* tkImageView; // 裁剪框
@property (nonatomic,retain) UIImage* transformImage; // 旋转变化之后的View


@end

@implementation EditPhotoViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initInterface];
    
    

}
#pragma mark- initData
- (void)initData{
    self.image = [self fixrotation:self.image];
    self.transformImage = self.image;
    currentRotate = UIImageOrientationUp;
}
#pragma mark - initInterface
- (void)initInterface{
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.editImaegView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20,Screen_Width,Screen_Height-20-100)];
//    self.editImaegView.image = self.image;
//    [self.editImaegView setContentMode:UIViewContentModeScaleToFill];
//    [self.view addSubview:self.editImaegView];
//    self.editImaegView.userInteractionEnabled = YES;
    
    _tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(0,20,Screen_Width,Screen_Height-20)];
    [self.view addSubview:_tkImageView];
    
    _tkImageView.toCropImage = self.image;
    _tkImageView.showMidLines = NO;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 4;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 6;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 4;
    _tkImageView.initialScaleFactor = .8f;
    _tkImageView.cropAspectRatio = 0;
    
    
    UIView* toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    [toolBarView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:toolBarView];
    
    //重拍
    UIButton* reTakeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reTakeBtn setFrame:CGRectMake(10, 40, 100, 40)];
    [reTakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [toolBarView addSubview:reTakeBtn];
    [reTakeBtn addTarget:self action:@selector(clickReTakeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //确定
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okBtn setFrame:CGRectMake(self.view.bounds.size.width - 10 - 100, 40, 100, 40)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [toolBarView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(clickOkBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *image =[UIImage imageNamed:@"rotate.png"];
    UIButton *rotateBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rotateBtn setImage:image forState:UIControlStateNormal];
    rotateBtn.frame =CGRectMake((self.view.bounds.size.width - 40) / 2, 40,40, 40);
    [toolBarView addSubview:rotateBtn];
    [rotateBtn addTarget:self action:@selector(clickRotateBtn) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark- Gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture{
    NSLog(@"controller pan === ");
}
#pragma mark- Click
- (void)clickReTakeBtn{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)clickOkBtn{
    
    NSLog(@"OK>>>>>>>");
    
    UIImage *imageX = [_tkImageView currentCroppedImage];
   // NSLog(@"imageX.W===%lf,imageX.H==%lf",imageX.size.width,imageX.size.height);
    
    
}
- (void)clickRotateBtn{
    NSLog(@"transform");
    switch (currentRotate) {
        case UIImageOrientationUp:
            currentRotate = UIImageOrientationRight;
            break;
        case UIImageOrientationDown:
            currentRotate = UIImageOrientationLeft;
            break;
        case UIImageOrientationRight:
            currentRotate = UIImageOrientationDown;
            break;
        case UIImageOrientationLeft:
            currentRotate = UIImageOrientationUp;
            break;
        default:
            break;
    }
    self.transformImage = [[UIImage alloc] initWithCGImage:[self.transformImage CGImage] scale:1.0 orientation:currentRotate];
    [self.editImaegView setImage:self.transformImage];
    _tkImageView.toCropImage = self.transformImage;

}

#pragma mark-
- (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
