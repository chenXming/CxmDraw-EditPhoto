//
//  ClipView.m
//  CameraDemo
//
//  Created by CXM  on 07/07/17.
//  Copyright (c) 2017 CXM All rights reserved.
//

#import "ClipView.h"


@implementation ClipView
{
    CAShapeLayer *fillLayer;
    UIView* holeView;
    
    CGFloat holeWidth;
    CGFloat holeHeight;
    CGFloat leftSpace;
    
    CGFloat cornerImageWidth;
    CGFloat cornerImageHeight;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}
- (void)initData{
    leftSpace = 8;
    
    holeHeight = 200;
    holeWidth = self.frame.size.width - leftSpace * 2;
    
    CGFloat currentX = leftSpace;
    CGFloat currentY = (self.frame.size.height - holeHeight) / 2;
    
    self.holeRect = CGRectMake(currentX, currentY, holeWidth, holeHeight);
}
- (void)layoutSubviews{
    //画出有透明区域的背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    UIBezierPath *holePath = [UIBezierPath bezierPathWithRect:self.holeRect];
    [path appendPath:holePath];
    [path setUsesEvenOddFillRule:YES];
    
    fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer addSublayer:fillLayer];
    
    //添加区域来响应手势
    CGRect toParentRect = [self convertRect:self.holeRect toView:self.parentView];
    
    holeView = [[UIView alloc] initWithFrame:toParentRect];
    [holeView setBackgroundColor:[UIColor clearColor]];
    [holeView setUserInteractionEnabled:YES];
    [self.parentView addSubview:holeView];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [holeView addGestureRecognizer:panGesture];
    
    //添加边角
    UIImage* leftTopImage = [UIImage imageNamed:@"left_top"];
    UIImage* rightTopImage = [UIImage imageNamed:@"right_top"];
    UIImage* leftBottomImage = [UIImage imageNamed:@"left_bottom"];
    UIImage* rightBottomImage = [UIImage imageNamed:@"right_bottom"];
    
    cornerImageWidth = leftTopImage.size.width;
    cornerImageHeight = leftTopImage.size.height;
    
    UIImageView* leftTopImageView = [[UIImageView alloc] initWithImage:leftTopImage];
    UIImageView* rightTopImageView = [[UIImageView alloc] initWithImage:rightTopImage];
    UIImageView* leftBottomImageView = [[UIImageView alloc] initWithImage:leftBottomImage];
    UIImageView* rightBottomImageView = [[UIImageView alloc] initWithImage:rightBottomImage];
    leftTopImageView.tag = 100;
    rightTopImageView.tag = 101;
    leftBottomImageView.tag = 102;
    rightBottomImageView.tag = 103;
    
    [leftTopImageView setUserInteractionEnabled:YES];
    [rightTopImageView setUserInteractionEnabled:YES];
    [leftBottomImageView setUserInteractionEnabled:YES];
    [rightBottomImageView setUserInteractionEnabled:YES];
    
    [holeView addSubview:leftBottomImageView];
    [holeView addSubview:leftTopImageView];
    [holeView addSubview:rightBottomImageView];
    [holeView addSubview:rightTopImageView];
    
    [leftTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
    }];
    
    [rightTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
    }];
    
    [leftBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    [rightBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    
    UIPanGestureRecognizer* leftTopPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCornerGesture:)];
    UIPanGestureRecognizer* rightBottomPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCornerGesture:)];
    UIPanGestureRecognizer* leftBottomPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCornerGesture:)];
    UIPanGestureRecognizer* rightTopPanGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCornerGesture:)];
    
    [leftTopImageView addGestureRecognizer:leftTopPanGesture];
    [rightBottomImageView addGestureRecognizer:rightBottomPanGesture];
    [leftBottomImageView addGestureRecognizer:leftBottomPanGesture];
    [rightTopImageView addGestureRecognizer:rightTopPanGesture];
}
#pragma mark- gesture
- (void)panGesture:(UIPanGestureRecognizer *)gesture{
    //获取手势点坐标
    CGPoint translation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint toPoint = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
        //最左侧
        CGFloat maxLeft = holeWidth / 2;
        //最右侧
        CGFloat maxRight = holeWidth/2 + leftSpace*2;
        //最上
        CGFloat maxTop = holeHeight / 2;
        //最下
        CGFloat maxBottom = self.frame.size.height - holeHeight / 2;
        
        if (toPoint.x < maxLeft) {
            toPoint.x = maxLeft;
        }
        
        if (toPoint.x > maxRight) {
            toPoint.x = maxRight;
        }
        
        if (toPoint.y < maxTop) {
            toPoint.y = maxTop;
        }
        
        if (toPoint.y > maxBottom) {
            toPoint.y = maxBottom;
        }
        
        gesture.view.center = toPoint;
    
        [gesture setTranslation:CGPointZero inView:gesture.view];
        
        [self changeHoleViewRect:[self convertRect:gesture.view.frame fromView:self.parentView]];
        
        self.holeRect = gesture.view.frame;
    }
}
- (void)panCornerGesture:(UIPanGestureRecognizer *)gesture{
    //获取手势坐标
    CGPoint translation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint toPoint = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
        
        gesture.view.center = toPoint;
        
        CGPoint toPointInSelfViewPoint = [self.parentView convertPoint:toPoint fromView:holeView];
        
        CGRect currentHoleRect = self.holeRect;
        
        
        [gesture setTranslation:CGPointZero inView:gesture.view];

        if (gesture.view.tag == 100) {
            //left top
            currentHoleRect.origin.x = toPointInSelfViewPoint.x - cornerImageWidth / 2;
            currentHoleRect.origin.y = toPointInSelfViewPoint.y - cornerImageHeight / 2;
            currentHoleRect.size.width = self.holeRect.size.width - (currentHoleRect.origin.x - self.holeRect.origin.x);
            currentHoleRect.size.height = self.holeRect.size.height - (currentHoleRect.origin.y - self.holeRect.origin.y);
        }else if (gesture.view.tag == 101){
            //right top
            currentHoleRect.origin.y = toPointInSelfViewPoint.y - cornerImageHeight / 2;
            currentHoleRect.size.height = self.holeRect.size.height - (currentHoleRect.origin.y - self.holeRect.origin.y);
            currentHoleRect.size.width = (toPointInSelfViewPoint.x + cornerImageWidth / 2 - currentHoleRect.origin.x);
        }else if (gesture.view.tag == 102){
            //left bottom
            currentHoleRect.origin.x = toPointInSelfViewPoint.x - cornerImageWidth / 2;
            currentHoleRect.size.width = self.holeRect.size.width - (currentHoleRect.origin.x - self.holeRect.origin.x);
            currentHoleRect.size.height =  (toPointInSelfViewPoint.y + cornerImageHeight / 2 - currentHoleRect.origin.y);
        }else if (gesture.view.tag == 103){
            //right bottom
            currentHoleRect.size.width = (toPointInSelfViewPoint.x + cornerImageWidth / 2 - currentHoleRect.origin.x);
            currentHoleRect.size.height =  (toPointInSelfViewPoint.y + cornerImageHeight / 2 - currentHoleRect.origin.y);
        }

        [self changeHoleViewRect:[self convertRect:currentHoleRect fromView:self.parentView]];
        
        holeView.frame = currentHoleRect;
        
        self.holeRect = currentHoleRect;
        //更新全局数据
        holeWidth = currentHoleRect.size.width;
        holeHeight = currentHoleRect.size.height;
        leftSpace = (self.bounds.size.width - holeWidth) / 2;
        
    }
}
#pragma mark-
- (void)changeHoleViewRect:(CGRect)toRect{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    UIBezierPath *holePath = [UIBezierPath bezierPathWithRect:toRect];
    
    [path appendPath:holePath];
    fillLayer.path = path.CGPath;
    
    [fillLayer didChangeValueForKey:@"path"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}
*/

@end
