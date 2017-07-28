//
//  ViewController.m
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/7/26.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "ViewController.h"
#import "GetPhotoViewController.h"

@interface ViewController (){


}

@property (nonatomic,strong) UIImageView *imageView;

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewWithEditImage:) name:@"BACKTOEDITIMAGE" object:nil];
    
}
-(void)makeMainUI{

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,Screen_Width , Screen_Height - 64)];
    self.imageView.backgroundColor = [UIColor whiteColor];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.imageView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStyleDone target:self action:@selector(RightItemClick)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
}
-(void)RightItemClick{

    NSLog(@"<><><><>");

    GetPhotoViewController *getPhotoVc = [[GetPhotoViewController alloc] init];
    
    [self.navigationController pushViewController:getPhotoVc animated:YES];
    
}

-(void)changeViewWithEditImage:(NSNotification*)notify{

    NSDictionary *dic = notify.userInfo;
    self.imageView.image = [dic objectForKey:@"image"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
