//
//  WQRadarView.h
//  WQRadarChart
//
//  Created by 王祺祺 on 2016/11/21.
//  Copyright © 2016年 wangqiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQRadarView : UIView
{
    NSMutableArray * pointArray;
    CAShapeLayer * shapeLayer;
}
//雷达view的大小最好是长宽相同，这样才会美观直观，此代码也是采用正方形的方式写的，并且是以x方向的长度为基础
//各个角需要显示的名字
@property(nonatomic,strong)NSArray * nameArray;
@property(nonatomic,strong)UIColor * radarFillColor;//填充颜色 默认绿色半透明
@property(nonatomic,strong)UIColor * backBoardColor;//背景线条颜色 默认group灰
@property(nonatomic,assign)NSInteger maxCount;//最大值 默认100
@property(nonatomic,strong)NSArray * countArray;//每一个类别所对应的大小数组，顺序要和nameArray对应

@end
