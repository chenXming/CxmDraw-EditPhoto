//
//  ViewController.m
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/7/26.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "ViewController.h"
#import "GetPhotoViewController.h"


@interface ViewController ()
{

    UIImageView *_imageView;

}

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title  = @"画图";
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self initData];
    [self makeMainUI];
    
    
}
-(void)initData{

}
-(void)makeMainUI{

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,Screen_Width , Screen_Height - 64)];
    _imageView.backgroundColor = [UIColor whiteColor];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStyleDone target:self action:@selector(RightItemClick)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)RightItemClick{

    NSLog(@"<><><><>");

    GetPhotoViewController *getPhotoVc = [[GetPhotoViewController alloc] init];
    
    [self.navigationController pushViewController:getPhotoVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
