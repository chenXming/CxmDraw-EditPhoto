//
//  PIDrawerView.h
//  PIImageDoodler
//
//  Created by Pavan Itagi on 07/03/14.
//  Copyright (c) 2014 Pavan Itagi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, DrawingMode) {
    DrawingModeNone = 0,
    DrawingModePaint,
    DrawingModeErase,
};
@protocol PIDrawDelegate <NSObject>

-(void)prvLastOne;

-(void)nextlastOne;

-(void)startDrawPic;

@end
@interface PIDrawerView : UIView
@property (nonatomic, assign) id <PIDrawDelegate> my_delegate;
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
