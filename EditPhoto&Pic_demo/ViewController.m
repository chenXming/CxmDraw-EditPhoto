//
//  ViewController.m
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/7/26.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "ViewController.h"
#import "GetPhotoViewController.h"
#import "CXMDrawerView.h"
#import "GrayScale.h"

@interface ViewController ()<CXMDrawDelegate>
{
    
    UIImageView *_picImageView;
    UIView *_upView;
    UIView *_downView;
    UIButton *_origBtn;
    UISlider *_slider;
    UIButton *eraserBtn;
    UIButton *masBtn;
    UIButton *prvBtn;
    UIButton *nextBtn;
    UIImageView *sliderView;
    UIImage *_sourseImage;
    UIImage *_grayImage;
    CXMDrawerView *_cxmDrawView;
    UIImage *_rignalImage;
    UILabel *_alertLabel;
    
    
}

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title  = @"画图";
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self initData];
    [self makeMainUI];
    
    [self makeMainView];
    [self makePIDrawView];

}
-(void)initData{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewWithEditImage:) name:@"BACKTOEDITIMAGE" object:nil];
    
}
-(void)makePIDrawView{
    
    _cxmDrawView=[[CXMDrawerView alloc] initWithFrame:CGRectMake(0,0,Screen_Width,_picImageView.frame.size.height)];
    _cxmDrawView.backgroundColor=[UIColor clearColor];
    _cxmDrawView.selectedColor=[UIColor whiteColor];
    _cxmDrawView.drawingMode=DrawingModePaint;
    _cxmDrawView.lineWidht=6;
    _cxmDrawView.my_delegate=self;
    _picImageView.userInteractionEnabled=YES;
    _picImageView.contentMode =  UIViewContentModeScaleAspectFit;
    [_picImageView addSubview:_cxmDrawView];
    
    _alertLabel=[[UILabel alloc] initWithFrame:CGRectMake(Screen_Width/2-60,100,120,25)];
    _alertLabel.backgroundColor=[UIColor blackColor];
    _alertLabel.text=@"最后一步，没有了";
    _alertLabel.textAlignment=NSTextAlignmentCenter;
    _alertLabel.font=[UIFont systemFontOfSize:14];
    _alertLabel.textColor=[UIColor whiteColor];
    [_downView addSubview:_alertLabel];
    
}

-(void)makeMainView{

    _upView=[[UIView alloc] initWithFrame:CGRectMake(0,64,Screen_Width,60)];
    _upView.backgroundColor=[UIColor lightGrayColor];
    
    [self.view addSubview:_upView];
    
    _downView=[[UIView alloc] initWithFrame:CGRectMake(0,Screen_Height-100,Screen_Width,100)];
    _downView.backgroundColor=[UIColor grayColor];
    
    [self.view addSubview:_downView];
    
    
    UIImage *origImage=[UIImage imageNamed:@"user_original_picture_normal"];
    _origBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _origBtn.frame=CGRectMake(40,10,33, 33);
    [_origBtn setImage:origImage forState:UIControlStateNormal];
    [_origBtn addTarget:self action:@selector(origBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:_origBtn];
    
    UILabel *origLabel=[[UILabel alloc] initWithFrame:CGRectMake(30,40,60,20)];
    origLabel.text=@"使用原图";
    origLabel.font=[UIFont systemFontOfSize:13];
    origLabel.textColor=[UIColor whiteColor];
    [_upView addSubview:origLabel];
    
    _slider=[[UISlider alloc] initWithFrame:CGRectMake(90,15,Screen_Width-130,20)];
    _slider.tintColor=[UIColor blueColor];
    _slider.continuous=YES;
    _slider.maximumValue=0.5f;
    _slider.minimumValue=-0.5f;
    [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [_upView addSubview:_slider];
    
    UIImageView *setView=[[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width-80,33,20,20)];
    setView.image=[UIImage imageNamed:@"ic_moasic_toast"];
    [_upView addSubview:setView];
    
    UILabel *setLabel=[[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-60,33,40,25)];
    setLabel.text=@"调整";
    setLabel.textColor=[UIColor whiteColor];
    setLabel.font=[UIFont systemFontOfSize:13];
    [_upView addSubview:setLabel];
    
    NSArray *imagArr=@[@"moasic_1",@"moasic_2",@"moasic_3",@"moasic_4",@"moasic_5"];
    for (NSInteger i=0;i<5 ; i++) {
        
        UIImageView *pointView=[[UIImageView alloc] initWithFrame:CGRectMake(20+i*30,20,20,20)];
        pointView.image=[UIImage imageNamed:imagArr[i]];
        [_downView addSubview:pointView];
        pointView.tag = 9000+i;
        pointView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesDown:)];
        
        [pointView addGestureRecognizer:tapGes];
    }
    for (NSInteger i=0; i<4; i++) {
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(40+i*30,30,10,1)];
        lineView.backgroundColor=[UIColor blackColor];
        [_downView addSubview:lineView];
    }
    
    sliderView=[[UIImageView alloc] initWithFrame:CGRectMake(50,20,20,20)];
    sliderView.image=[UIImage imageNamed:@"moasic_selected"];
    [_downView addSubview:sliderView];
    
    
    masBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    masBtn.frame=CGRectMake(200,10,33, 33);
    [masBtn setImage:[UIImage imageNamed:@"moasic_pressed"] forState:UIControlStateNormal];
    [masBtn addTarget:self action:@selector(masBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:masBtn];
    
    eraserBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    eraserBtn.frame=CGRectMake(240,10,33, 33);
    [eraserBtn setImage:[UIImage imageNamed:@"eraser_normal"] forState:UIControlStateNormal];
    [eraserBtn addTarget:self action:@selector(eraserBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:eraserBtn];
    
    UILabel *masLabel=[[UILabel alloc] initWithFrame:CGRectMake(190,35,40,30)];
    masLabel.text=@"马赛克";
    masLabel.textColor=[UIColor whiteColor];
    masLabel.font=[UIFont systemFontOfSize:13];
    [_downView addSubview:masLabel];
    
    UILabel *eraLabel=[[UILabel alloc] initWithFrame:CGRectMake(235,35,40,30)];
    eraLabel.text=@"橡皮擦";
    eraLabel.textColor=[UIColor whiteColor];
    eraLabel.font=[UIFont systemFontOfSize:13];
    [_downView addSubview:eraLabel];
    
    
    UIButton *clearBrn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [clearBrn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBrn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    clearBrn.titleLabel.font = [UIFont systemFontOfSize:17];
    clearBrn.frame = CGRectMake(Screen_Width - 60, 20, 50, 30);
    [clearBrn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:clearBrn];
    
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(30,Screen_Height-40,40,30);
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(Screen_Width-70,Screen_Height-40,40,30);
    [sureBtn setTintColor:[UIColor whiteColor]];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    
    prvBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    prvBtn.frame=CGRectMake(Screen_Width/2-45,Screen_Height-40,45,40);
    [prvBtn setTintColor:[UIColor whiteColor]];
    [prvBtn setImage:[UIImage imageNamed:@"moasic_last_normal"] forState:UIControlStateNormal];
    [prvBtn addTarget:self action:@selector(prvBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prvBtn];
    
    nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame=CGRectMake(Screen_Width/2,Screen_Height-40,45,40);
    [nextBtn setTintColor:[UIColor whiteColor]];
    [nextBtn setImage:[UIImage imageNamed:@"moasic_next_normal"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];


}
-(void)makeMainUI{

    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,Screen_Width , Screen_Height - 64)];
    _picImageView.backgroundColor = [UIColor cyanColor];
    [_picImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_picImageView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStyleDone target:self action:@selector(RightItemClick)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)RightItemClick{

    NSLog(@"<><><><>");

    GetPhotoViewController *getPhotoVc = [[GetPhotoViewController alloc] init];
    
    [self.navigationController pushViewController:getPhotoVc animated:YES];
    
}

-(void)startDrawPic{
    [prvBtn setImage:[UIImage imageNamed:@"moasic_last_pressed"] forState:UIControlStateNormal];
    
}

#pragma mark - 手势方法
-(void)tapGesDown:(UITapGestureRecognizer*)tapGes{
    
    NSLog(@"tapGes>tag=======%ld",(long)tapGes.view.tag);
    
    sliderView.frame=CGRectMake(20+(tapGes.view.tag-9000)*30,20,20,20);
    if(tapGes.view.tag==9000){
        _cxmDrawView.lineWidht=3;
    }else if(tapGes.view.tag==9001){
        _cxmDrawView.lineWidht=6;
    }else if(tapGes.view.tag==9002){
        _cxmDrawView.lineWidht=9;
    }else if(tapGes.view.tag==9003){
        _cxmDrawView.lineWidht=12;
    }else if(tapGes.view.tag==9004){
        _cxmDrawView.lineWidht=15;
    }
    
    
}
#pragma mark - 通知方法
-(void)changeViewWithEditImage:(NSNotification*)notify{

    NSDictionary *dic = notify.userInfo;
    _picImageView.image = [dic objectForKey:@"image"];
    _rignalImage = [dic objectForKey:@"image"];
    _grayImage =[_rignalImage convertToGrayscale];

}
#pragma mark - 点击事件
-(void)origBtnDown:(UIButton*)btn{
    
    if([btn.imageView.image isEqual:[UIImage imageNamed:@"user_original_picture_normal"]]){
        [btn setImage:[UIImage imageNamed:@"user_original_picture_pressed"] forState:UIControlStateNormal];
        _picImageView.image=_rignalImage;
        
    }else{
        
        [btn setImage:[UIImage imageNamed:@"user_original_picture_normal"] forState:UIControlStateNormal];
        _picImageView.image=_grayImage;
    }
}
-(void)prvBtnDown:(UIButton*)btn{
    NSLog(@"pre");
    
    [_cxmDrawView getPreviousPic];
    if(_cxmDrawView.allPoints.count>0){
        
        [nextBtn setImage:[UIImage imageNamed:@"moasic_next_pressed"] forState:UIControlStateNormal];
    }
    
}
-(void)nextBtnDown:(UIButton*)btn{
    NSLog(@"next");
    
    [_cxmDrawView getNextPic];
    if(_cxmDrawView.allPoints.count>0){
        
        [prvBtn setImage:[UIImage imageNamed:@"moasic_last_pressed"] forState:UIControlStateNormal];
    }
    
}
-(void)backBtnDown{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sureBtnDown{
    
    NSLog(@"确定");
    
    [self saveContextImage];
    
}
#pragma mark - 保存图片
- (void)saveContextImage{
    // 截屏
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(_picImageView.bounds.size, NO, 0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染图层
    [_picImageView.layer renderInContext:ctx];
    
    // 获取上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    
    // 保存画板的内容放入相册
    // image:写入的图片
    // completionTarget图片保存监听者
    // 注意：以后写入相册方法中，想要监听图片有没有保存完成，保存完成的方法不能随意乱写
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
// 监听保存完成，必须实现这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存图片成功");
}

-(void)masBtnDown:(UIButton*)btn{
    
    NSLog(@"mas====");
    _cxmDrawView.drawingMode = DrawingModePaint;
    if([btn.imageView.image isEqual:[UIImage imageNamed:@"moasic_normal"]]){
        [btn setImage:[UIImage imageNamed:@"moasic_pressed"] forState:UIControlStateNormal];
        [eraserBtn setImage:[UIImage imageNamed:@"eraser_normal"] forState:UIControlStateNormal];
        
    }else{
        [btn setImage:[UIImage imageNamed:@"moasic_normal"] forState:UIControlStateNormal];
    }
}
-(void)eraserBtnDown:(UIButton*)btn{
    
    _cxmDrawView.drawingMode = DrawingModeErase;

    if([btn.imageView.image isEqual:[UIImage imageNamed:@"eraser_normal"]]){
        [btn setImage:[UIImage imageNamed:@"eraser_pressed"] forState:UIControlStateNormal];
        [masBtn setImage:[UIImage imageNamed:@"moasic_normal"] forState:UIControlStateNormal];
    }else{
        
        [btn setImage:[UIImage imageNamed:@"eraser_normal"] forState:UIControlStateNormal];
    }
}
-(void)clearBtnClick:(UIButton*)btn{

    NSLog(@"clear>>>>>>");
    [_cxmDrawView.allPoints removeAllObjects];
    _cxmDrawView.currentLine=0;
    _cxmDrawView.drawingMode = DrawingModeNone;
    [_cxmDrawView clearView];

}
-(void)sliderChange:(UISlider*)slider{
    
    NSLog(@"slider=====%f",slider.value);
    
    UIImage *changeImage =[self colorControlWithImage:_grayImage brightness:slider.value contrast:1.0 saturation:1.0];
    _picImageView.image = changeImage;
}

#pragma mark - PIDrawDelegate
-(void)prvLastOne{
    
    [prvBtn setImage:[UIImage imageNamed:@"moasic_last_normal"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5f animations:^{
        _alertLabel.frame=CGRectMake(Screen_Width/2-60,20,120,25);
    }];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changAlertView) userInfo:self repeats:NO];
    
}
-(void)nextlastOne{
    
    [nextBtn setImage:[UIImage imageNamed:@"moasic_next_normal"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5f animations:^{
        _alertLabel.frame=CGRectMake(Screen_Width/2-60,20,120,25);
    }];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changAlertView) userInfo:self repeats:NO];
}
-(void)changAlertView{
    [UIView animateWithDuration:0.5f animations:^{
        _alertLabel.frame=CGRectMake(Screen_Width/2-60,100,120,25);
    }];
}

- (UIImage *)colorControlWithImage:(UIImage *)image brightness:(CGFloat)bright contrast:(CGFloat)contrast saturation:(CGFloat)saturation
{
    if (!image) return nil;
    
    CIImage *input = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:input forKey:kCIInputImageKey];
    [filter setValue:@(bright) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    
    return [UIImage imageWithCIImage:[filter outputImage]];
    // return [self imageWithCoreImage:[filter outputImage]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
