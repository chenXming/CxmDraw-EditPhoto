//
//  EditPhotoViewController.h
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/7/26.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditPhotoViewControllerDelegate <NSObject>

-(void)backEditPhoto:(UIImage*)editImage;

@end

@interface EditPhotoViewController : UIViewController


@property (nonatomic,strong) UIImage* image;

@end
