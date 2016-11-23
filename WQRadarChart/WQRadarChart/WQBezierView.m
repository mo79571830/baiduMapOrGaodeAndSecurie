//
//  BezierView.m
//  linebezierAnimition
//
//  Created by 王祺祺 on 2016/11/17.
//  Copyright © 2016年 wangqiqi. All rights reserved.
//

#import "WQBezierView.h"

@implementation WQBezierView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.frame = frame;
    }
    return self;
}
//创建表格
-(void)drawRect:(CGRect)rect
{
    for(int i =0;i <= self.pointArray.count;i ++)
    {
        [[UIColor groupTableViewBackgroundColor] set];
        UIBezierPath * verticalbezierPath = [UIBezierPath bezierPath];
        [verticalbezierPath moveToPoint:CGPointMake(i * self.frame.size.width/self.pointArray.count, 0)];
        [verticalbezierPath addLineToPoint:CGPointMake(i * self.frame.size.width/self.pointArray.count, self.frame.size.height)];
        verticalbezierPath.lineWidth = 2.0;
        [verticalbezierPath stroke];
        UIBezierPath * horizonbezierPath = [UIBezierPath bezierPath];
        [horizonbezierPath moveToPoint:CGPointMake(0, i * self.frame.size.height/self.pointArray.count)];
        [horizonbezierPath addLineToPoint:CGPointMake(self.frame.size.width, i*self.frame.size.height/self.pointArray.count)];
        horizonbezierPath.lineWidth = 1.0;
        [horizonbezierPath stroke];
        
    }
    
    [self createLineanimation];
}
//画折线图动画
-(void)createLineanimation
{
    //比例
    CGFloat xScale = (self.ePoint.x - self.staPoint.x)/self.frame.size.width;
    CGFloat yScale = (self.ePoint.y - self.staPoint.y)/self.frame.size.height;
    
    UIBezierPath * bezier = [UIBezierPath bezierPath];
   
//    [[UIColor greenColor] set];
    for(int i =0;i <self.pointArray.count;i ++)
    {
        NSString * onlyStr = self.pointArray[i];
        NSArray * array = [onlyStr componentsSeparatedByString:@","];
        if(i==0)
        {
            [bezier moveToPoint:CGPointMake((CGFloat)([array[0] integerValue]/xScale), (CGFloat)(self.frame.size.height-[array[1] integerValue]/yScale))];
        }
        else
        {
            [bezier addLineToPoint:CGPointMake((CGFloat)([array[0] integerValue]/xScale), (CGFloat)(self.frame.size.height-[array[1] integerValue]/yScale))];
        }
        
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    shapeLayer.path = bezier.CGPath;
    
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = nil;
    shapeLayer.lineJoin = kCALineCapRound;
    [self.layer addSublayer:shapeLayer];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    [shapeLayer addAnimation:animation forKey:@"path"];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, 20, 20)];
    label.text = @"0,0";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch * touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSLog(@"触摸了%f  %f",point.x,point.y);
    CALayer * layre = [self.layer sublayers][0];
    UIView * view = [self subviews][0];
    [view removeFromSuperview];
    [layre removeFromSuperlayer];
    [self createLineanimation];
}
@end
