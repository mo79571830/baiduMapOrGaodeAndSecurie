//
//  BezierView.h
//  linebezierAnimition
//
//  Created by 王祺祺 on 2016/11/17.
//  Copyright © 2016年 wangqiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQBezierView : UIView
@property(nonatomic,strong)NSArray * pointArray;//点的array
//array中的点的横坐标和纵坐标 数组中点的横坐标要<(ePoint.x -staPoint.x) 纵坐标<(ePoint.y - staPoint.y)
@property(nonatomic,assign)CGPoint staPoint;//开始的点
@property(nonatomic,assign)CGPoint ePoint;//结束的点
@end
