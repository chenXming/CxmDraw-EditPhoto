//
//  ClipView.h
//  CameraDemo
//
//  Created by xujiangtao on 15/11/11.
//  Copyright © 2015年 xujiangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClipView : UIView
@property (nonatomic,assign) CGRect holeRect;
@property (nonatomic,retain) UIView* parentView;
@end
