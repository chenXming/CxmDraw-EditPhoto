//
//  PIDrawerView.m
//  PIImageDoodler
//
//  Created by Pavan Itagi on 07/03/14.
//  Copyright (c) 2014 Pavan Itagi. All rights reserved.
//

#import "PIDrawerView.h"

#define POINT(X)	[[pointArr objectAtIndex:X] CGPointValue]

@interface PIDrawerView ()
{
    CGPoint previousPoint;
    CGPoint currentPoint;
    NSMutableArray *_pointArr;// 保存点
    
}

@end

@implementation PIDrawerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self awakeFromNib];
        
        _allPoints=[[NSMutableArray alloc] initWithCapacity:0];
        self.currentLine = 0;
    }
    return self;
}
- (void)awakeFromNib
{
    [self initialize];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //沙盒路径
    self.path = [documentPaths objectAtIndex:0];
    
    //存储绘图的图片
    NSString *fileName = [[[NSString alloc] initWithFormat:@"%@",@"painPicture"]stringByAppendingString:@".png"];
    self.path = [self.path stringByAppendingPathComponent:fileName];
   
}

- (void)drawRect:(CGRect)rect
{
    
    [self.viewImage drawInRect:self.bounds];
}

#pragma mark - setter methods
- (void)setDrawingMode:(DrawingMode)drawingMode
{
    _drawingMode = drawingMode;
}

#pragma mark - Private methods
- (void)initialize
{
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
    
    _drawingMode = DrawingModeNone;
    
    _selectedColor = [UIColor blackColor];
}

- (void)eraseLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}


- (void)drawLineNew
{
 
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.lineWidht);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)handleTouches
{
    if (self.drawingMode == DrawingModeNone) {
        // do nothing
    }
    else if (self.drawingMode == DrawingModePaint) {
        [self drawLineNew];
    }
    else
    {
        [self eraseLine];
    }
}
-(void)clearView{
  
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.bounds);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
}

-(void)getPreviousPic{
    
    [self clearView];
    
    _currentLine--;
    
    if(_currentLine<0){
    
        NSLog(@"没有了");
        _currentLine = 0;
        [self.my_delegate prvLastOne];
    
    }else{
      
        for (NSInteger x=0; x<_currentLine; x++) {
            
            NSArray *pointArr=[_allPoints objectAtIndex:x];
            
            for (NSInteger i=0;i<pointArr.count-1; i++) {
                
                CGPoint point0=POINT(i);
                CGPoint point1=POINT(i+1);
                
                UIGraphicsBeginImageContext(self.bounds.size);
                [self.viewImage drawInRect:self.bounds];
                
                CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
                CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.lineWidht);
                CGContextBeginPath(UIGraphicsGetCurrentContext());
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point0.x, point0.y);
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point1.x, point1.y);
                
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                previousPoint = currentPoint;
                
                [self setNeedsDisplay];
            }
        }
    }
    
    
   // NSLog(@"_pointArr==============%@",[_allPoints objectAtIndex:_currentLine]);
    

}
-(void)getNextPic{
    
     _currentLine++;
    
    if(_currentLine >_allPoints.count){
    
        NSLog(@"没有了");
        _currentLine = _allPoints.count;
        [self.my_delegate nextlastOne];
        
    }else{
        
        NSArray *pointArr=[_allPoints objectAtIndex:_currentLine-1];
            for (NSInteger i=0;i<pointArr.count-1; i++) {
                
                CGPoint point0=POINT(i);
                CGPoint point1=POINT(i+1);
                
                UIGraphicsBeginImageContext(self.bounds.size);
                [self.viewImage drawInRect:self.bounds];
                
                CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
                CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.lineWidht);
                CGContextBeginPath(UIGraphicsGetCurrentContext());
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point0.x, point0.y);
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point1.x, point1.y);
                
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                previousPoint = currentPoint;
                
                [self setNeedsDisplay];
            }
        
    }
    
  //  NSLog(@"_allPoint==========%@",_allPoints);
    
}
#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.my_delegate startDrawPic];
    
    _pointArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;
    [_pointArr addObject:[NSValue valueWithCGPoint:previousPoint]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    [_pointArr addObject:[NSValue valueWithCGPoint:currentPoint]];
    [self handleTouches];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    [_pointArr addObject:[NSValue valueWithCGPoint:currentPoint]];
    [_allPoints addObject:_pointArr];
    _currentLine = _allPoints.count;
    [self handleTouches];
}

@end
