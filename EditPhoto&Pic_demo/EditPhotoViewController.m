//
//  EditPhotoViewController.m
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/7/26.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "ClipView.h"

@interface EditPhotoViewController ()
{
    UIImageView *_BigImageView;
    UIImageOrientation currentRotate;

}

@property (nonatomic,retain) UIImageView* editImaegView;
@property (nonatomic,retain) ClipView* coverView;
@property (nonatomic,retain) UIImage* transformImage;


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
    
    self.editImaegView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    self.editImaegView.image = self.image;
    [self.editImaegView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.editImaegView];
    self.editImaegView.userInteractionEnabled = YES;
    
    self.coverView = [[ClipView alloc] initWithFrame:self.editImaegView.frame];
    self.coverView.backgroundColor = [UIColor clearColor];
    self.coverView.opaque = NO;
    self.coverView.userInteractionEnabled = YES;
    self.coverView.parentView = self.view;
    [self.view addSubview:self.coverView];
    [self.coverView setUserInteractionEnabled:YES];
    
    UIView* toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    [toolBarView setBackgroundColor:[UIColor blackColor]];
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
    
//    UIImage *imageX = [self clipWithImageRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height) clipRect:self.coverView.holeRect clipImage:self.image];
    
    UIImage *imageX = [self image:self.image fortargetSize:CGSizeMake(self.coverView.holeRect.size.width, self.coverView.holeRect.size.height)];
    
    NSLog(@"holeRectWidth==%lf,holdHeight===%lf",self.coverView.holeRect.size.width,self.coverView.holeRect.size.height);
    
    //{1080, 1920}
    NSLog(@"imageWidth ===%lf,imageHeight===%lf",imageX.size.width,imageX.size.height);
    
    
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
-(UIImage*)image:(UIImage*)image fortargetSize: (CGSize)targetSize{
    
    UIImage*sourceImage = image;

    CGSize imageSize = sourceImage.size;//图片的size

    CGFloat imageWidth = imageSize.width;//图片宽度

    CGFloat imageHeight = imageSize.height;//图片高度
    
    NSInteger judge;//声明一个判断属性

    //判断是否需要调整尺寸(这个地方的判断标准又个人决定,在此我是判断高大于宽),因为图片是800*480,所以也可以变成480*800
  
    if( ( imageHeight - imageWidth)>0) {

        //在这里我将目标尺寸修改成480*800

        CGFloat tempW = targetSize.width;

        CGFloat tempH = targetSize.height;

        targetSize.height= tempW;

        targetSize.width= tempH;

    }

    CGFloat targetWidth = targetSize.width;//获取最终的目标宽度尺寸

    CGFloat targetHeight = targetSize.height;//获取最终的目标高度尺寸

    CGFloat scaleFactor ;//先声明拉伸的系数

    CGFloat scaledWidth = targetWidth;

    CGFloat scaledHeight = targetHeight;
 
    CGPoint thumbnailPoint =CGPointMake(0.0,0.0);//这个是图片剪切的起点位置

    //第一个判断,图片大小宽跟高都小于目标尺寸,直接返回image

    if( imageHeight < targetHeight && imageWidth < targetWidth) {

        return image;

    }

    if ( CGSizeEqualToSize(imageSize, targetSize ) ==NO ){

        CGFloat widthFactor = targetWidth / imageWidth; //这里是目标宽度除以图片宽度

        CGFloat heightFactor = targetHeight / imageHeight; //这里是目标高度除以图片高度

        //分四种情况,

        //第一种,widthFactor,heightFactor都小于1,也就是图片宽度跟高度都比目标图片大,要缩小
 
        if(widthFactor <1&& heightFactor<1){

            //第一种,需要判断要缩小哪一个尺寸,这里看拉伸尺度,我们的scale在小于1的情况下,谁越小,等下就用原图的宽度高度✖️那一个系数(这里不懂的话,代个数想一下,例如目标800*480  原图1600*800  系数就采用宽度系数widthFactor = 1/2  )

            if(widthFactor > heightFactor){

                judge =1;//右部分空白

                scaleFactor = heightFactor; //修改最后的拉伸系数是高度系数(也就是最后要*这个值)

            }else{

                judge =2;//下部分空白

                scaleFactor = widthFactor;

            }
                
            }else if(widthFactor >1&& heightFactor <1){

                //第二种,宽度不够比例,高度缩小一点点(widthFactor大于一,说明目标宽度比原图片宽度大,此时只要拉伸高度系数)
  
                judge =3;//下部分空白
 
                //采用高度拉伸比例

                scaleFactor = imageWidth / targetWidth;// 计算高度缩小系数
                
            }else if(heightFactor >1&&widthFactor <1){

                //第三种,高度不够比例,宽度缩小一点点(heightFactor大于一,说明目标高度比原图片高度大,此时只要拉伸宽度系数)
                judge =4;//下边空白

                //采用高度拉伸比例

                scaleFactor = imageHeight / targetWidth;

            }else{

                //第四种,此时宽度高度都小于目标尺寸,不必要处理放大(如果有处理放大的,在这里写).

            }

        scaledWidth= imageWidth * scaleFactor;

        scaledHeight = imageHeight * scaleFactor;

    }
    
    if(judge ==1){

        //右部分空白

        targetWidth = scaledWidth;//此时把原来目标剪切的宽度改小,例如原来可能是800,现在改成780
        
    }else if(judge ==2){
        
        //下部分空白

        targetHeight = scaledHeight;
        
    }else if(judge ==3){

        //第三种,高度不够比例,宽度缩小一点点

        targetWidth = scaledWidth;
        
    }else{

        //第三种,高度不够比例,宽度缩小一点点

        targetHeight= scaledHeight;
        
    }

    UIGraphicsBeginImageContext(targetSize);//开始剪切

    CGRect thumbnailRect =CGRectZero;//剪切起点(0,0)

    thumbnailRect.origin= thumbnailPoint;

    thumbnailRect.size.width= scaledWidth;

    thumbnailRect.size.height= scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
  
    return newImage;
    
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
