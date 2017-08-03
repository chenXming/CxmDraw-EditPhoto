//
//  CXMDrawerView.h
//  EditPhoto&Pic_demo
//
//  Created by 陈小明 on 2017/8/3.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawingMode) {
    DrawingModeNone = 0,
    DrawingModePaint,
    DrawingModeErase,
};
@protocol CXMDrawDelegate <NSObject>

-(void)prvLastOne;

-(void)nextlastOne;

-(void)startDrawPic;

@end


@interface CXMDrawerView : UIView

@property (nonatomic, assign) id <CXMDrawDelegate> my_delegate;
@property (nonatomic, readwrite) DrawingMode drawingMode;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, strong) UIImage * viewImage;
@property (nonatomic, assign) NSInteger currentLine;// 循环次数
@property (nonatomic, assign) NSInteger lineWidht;
@property (nonatomic, strong) NSMutableArray *allPoints;// 点的信息
-(void)clearView;
-(void)getPreviousPic;
-(void)getNextPic;

@end
