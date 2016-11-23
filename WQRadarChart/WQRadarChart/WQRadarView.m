//
//  WQRadarView.m
//  WQRadarChart
//
//  Created by 王祺祺 on 2016/11/21.
//  Copyright © 2016年 wangqiqi. All rights reserved.
//

#import "WQRadarView.h"

@implementation WQRadarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        

    }
         return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//画后面的多边形
- (void)drawRect:(CGRect)rect {
    
    //连成外边形
    UIBezierPath * pentagonLine = [UIBezierPath bezierPath];
    //连成内边形
    UIBezierPath * inpentagonLine = [UIBezierPath bezierPath];
    //画内线
    for (int i=0;i <self.nameArray.count;i ++)
    {
        double xpoint = self.center.x + cos(i * 2 *M_PI/self.nameArray.count)*(self.center.x-20);
        double ypoint = self.center.y - sin(i * 2 *M_PI/self.nameArray.count) * (self.center.x-20);
        //画内线
        UIBezierPath * wqBezierPath = [UIBezierPath bezierPath];
        if(!self.backBoardColor)
        {
            [[UIColor groupTableViewBackgroundColor] set];
        }
        else
        {
            [self.backBoardColor set];
        }
        
        [wqBezierPath moveToPoint:self.center];
        CGPoint point= CGPointZero;
        point = CGPointMake(xpoint,ypoint);
        [wqBezierPath addLineToPoint:point];
        [wqBezierPath stroke];
        
        if(i==0)
        {
            [pentagonLine moveToPoint:point];
            [inpentagonLine moveToPoint:CGPointMake(self.center.x + cos(i * 2 *M_PI/self.nameArray.count)*(self.center.x-20)/2, self.center.y - sin(i * 2 *M_PI/self.nameArray.count) * (self.center.x-20)/2)];
        }
        else
        {
            [pentagonLine addLineToPoint:point];
            [inpentagonLine addLineToPoint:CGPointMake(self.center.x + cos(i * 2 *M_PI/self.nameArray.count)*(self.center.x-20)/2, self.center.y - sin(i * 2 *M_PI/self.nameArray.count) * (self.center.x-20)/2)];
        }
        [self createLabelWithName:self.nameArray[i] withPoint:point withAngle:i * 2 *M_PI/self.nameArray.count];
    }
    [inpentagonLine closePath];
    [inpentagonLine stroke];
    [pentagonLine closePath];
    [pentagonLine stroke];
   [self createRadarWithCount];
    
  
}

/**
 创建雷达图
 */
-(void)createRadarWithCount
{
    [[UIColor clearColor] set];
    if(!self.maxCount)
    {
        self.maxCount = 100;
    }
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 2.0;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.path = [self bezierWithArray:self.countArray].CGPath;
    
    CABasicAnimation * baseAnaimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnaimation.fromValue = @(0.0);
    baseAnaimation.toValue = @(1.0);
    baseAnaimation.duration = 2;
    baseAnaimation.repeatCount=0;
    baseAnaimation.autoreverses=NO;
    baseAnaimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [shapeLayer addAnimation:baseAnaimation forKey:@"toMax"];
    [self performSelector:@selector(changeFillColor) withObject:nil afterDelay:2];
    [self.layer addSublayer:shapeLayer];
}

/**
 画曲线

 @param scoreArray 数值的数组
 @return 曲线
 */
-(UIBezierPath *)bezierWithArray:(NSArray *)scoreArray
{
    UIBezierPath * radarPath = [UIBezierPath bezierPath];
     float lengthScale = self.maxCount/(self.center.x-20);
    for(int i=0;i < self.countArray.count;i ++)
    {
        
        float countLength = [self.countArray[i] floatValue]/lengthScale;
        if(i==0)
        {
            [radarPath moveToPoint:CGPointMake(self.center.x + cos(i * 2 *M_PI/self.countArray.count) * countLength, self.center.y - sin(i * 2 *M_PI/self.countArray.count) * countLength)];
        }
        else
        {
            [radarPath addLineToPoint:CGPointMake(self.center.x + cos(i * 2 *M_PI/self.countArray.count) * countLength, self.center.y - sin(i * 2 *M_PI/self.countArray.count) * countLength)];
        }
    }
    [radarPath closePath];
    [radarPath stroke];
    return radarPath;
}
/**
 添加label

 @param labelName label的名字
 @param point label添加到那个点
 @param angle 角度
 */
-(void)createLabelWithName:(NSString *)labelName withPoint:(CGPoint)point withAngle:(double)angle
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(point.x - 13, point.y- 13, 25, 25)];
    
    label.text = labelName;
    label.font = [UIFont systemFontOfSize:12];
    [self addSubview:label];
}

/**
 添加内部颜色
 */
-(void)changeFillColor
{
    if(!self.radarFillColor)
    {
        shapeLayer.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.1].CGColor;
        return;
    }
    shapeLayer.fillColor = self.radarFillColor.CGColor;
    
}
@end
