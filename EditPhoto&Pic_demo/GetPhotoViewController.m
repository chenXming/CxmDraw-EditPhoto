//
//  GetPhotoViewController.m
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/7/27.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "GetPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EditPhotoViewController.h"


@interface GetPhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    

    UIImagePickerController *imagePicker;

}
// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)AVCaptureSession *session;

// AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong)AVCaptureDeviceInput *videoInput;

// 照片输出流对象
@property (nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;

// 预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;

// 切换前后镜头的按钮
@property (nonatomic, strong)UIButton *toggleButton;

// 拍照按钮
@property (nonatomic, strong)UIButton *shutterButton;

// 放置预览图层的View
@property (nonatomic, strong)UIView *cameraShowView;


@end

@implementation GetPhotoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    //拍照 摄像头不可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
      //  imagePicker.allowsEditing = YES; // 是否展示编辑裁剪页面
        WeakSelf(self);
        [self presentViewController:imagePicker animated:NO completion:^{
            weakself.navigationController.view.alpha = 1;
            
        }];
        
        return;
    }
    
    [self initialSession];
    
    [self initCameraShowView];
    
    [self initButton];


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpCameraLayer];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.session) {
        [self.session startRunning];
    }
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
    
}
#pragma mark - init
- (void)initialSession
{
    
    self.session = [[AVCaptureSession alloc] init];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
        
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
}

- (void)initCameraShowView
{
    self.cameraShowView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.cameraShowView];
}

- (void)initButton{

    
    self.toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.toggleButton.frame = CGRectMake(Screen_Width - 100, Screen_Height - 60, 100, 30);
    self.toggleButton.backgroundColor = [UIColor clearColor];
    [self.toggleButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleButton];
    
    
    UIButton *tabekePhoneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [tabekePhoneBtn setImage:[UIImage imageNamed:@"takepic"] forState:UIControlStateNormal];
    tabekePhoneBtn.frame =CGRectMake((Screen_Width-60)/2,Screen_Height - 80,60, 60);
    [self.view addSubview:tabekePhoneBtn];
    [tabekePhoneBtn addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* cancelPhotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelPhotoBtn.frame = CGRectMake(10, Screen_Height - 60, 100, 30);
    [cancelPhotoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancelPhotoBtn];
    cancelPhotoBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [cancelPhotoBtn addTarget:self action:@selector(clickcancelPhotoButton) forControlEvents:UIControlEventTouchUpInside];

}
-(void)clickcancelPhotoButton{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候，剪裁超出父视图范围的子视图部分，当取值为NO时，不剪裁子视图。
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [viewLayer addSublayer:self.previewLayer];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.navigationController.navigationBarHidden = NO;

    NSLog(@"image picker delegate == %@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType  == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        
        EditPhotoViewController* editVC = [[EditPhotoViewController alloc] init];
        editVC.image = image;
        [picker pushViewController:editVC animated:NO];
    }else{
     
        [picker dismissViewControllerAnimated:YES completion:^{
            
              [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKTOEDITIMAGE" object:self userInfo:@{@"image":image}];
        }];
        
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];

    self.navigationController.view.alpha = 0;
    WeakSelf(self);
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [imagePicker removeFromParentViewController];
        [weakself.navigationController.view removeFromSuperview];
    }];

}
#pragma mark - 摄像头切换
- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

// 这是获取前后摄像头对象的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}
#pragma mark -  这是拍照按钮的方法
- (void)shutterCamera
{
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        NSLog(@"image size = %@", NSStringFromCGSize(image.size));
        
        EditPhotoViewController *editPhotoVc = [[EditPhotoViewController alloc] init];
        
        editPhotoVc.image  = image;
        
        [self.navigationController pushViewController:editPhotoVc animated:YES];
        
    }];
}

// 这是切换镜头的按钮方法
- (void)toggleCamera
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        } else if (position == AVCaptureDevicePositionFront) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        } else {
            return;
        }
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                self.videoInput = newVideoInput;
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
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
