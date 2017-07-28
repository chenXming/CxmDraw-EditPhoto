//
//  TKImageView.h
//  TKImageDemo
//
//  Created by yinyu on 16/7/10.
//  Copyright © 2016年 yinyu. All rights reserved.
//https://github.com/3tinkers/TKImageView 参数说明

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TKCropAreaCornerStyle) {
    TKCropAreaCornerStyleRightAngle,
    TKCropAreaCornerStyleCircle
};
@interface TKImageView : UIView

@property (strong, nonatomic) UIImage *toCropImage;//需要进行裁剪的图片对象
@property (assign, nonatomic) BOOL needScaleCrop;//是否支持缩放裁剪
@property (assign, nonatomic) BOOL showMidLines;//是否显示中间线
@property (assign, nonatomic) BOOL showCrossLines;// 是否显示中间十字交叉线
@property (assign, nonatomic) CGFloat cropAspectRatio;//裁剪区域的宽高比
@property (strong, nonatomic) UIColor *cropAreaBorderLineColor;
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;
@property (assign, nonatomic) CGFloat minSpace;
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;
@property (strong, nonatomic) UIColor *maskColor;
@property (assign, nonatomic) BOOL cornerBorderInImage;
@property (assign, nonatomic) CGFloat initialScaleFactor;
- (UIImage *)currentCroppedImage;
@end
