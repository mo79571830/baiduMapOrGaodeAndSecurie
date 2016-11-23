//
//  ViewController.m
//  WQRadarChart
//
//  Created by 王祺祺 on 2016/11/21.
//  Copyright © 2016年 wangqiqi. All rights reserved.
//

#import "ViewController.h"
#import "WQRadarView.h"
#import "WQBezierView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WQRadarView *ew = [[WQRadarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height/2, self.view.frame.size.height/2)];
    ew.nameArray = @[@"速度",@"伤害",@"抗性",@"辅助",@"法术",@"物理"];
    ew.countArray = @[@(50),@(60),@(80),@(80),@(40),@(90)];
    
    WQBezierView * bezVc = [[WQBezierView alloc]initWithFrame:CGRectMake(10 , self.view.frame.size.height/2,self.view.frame.size.height/2, self.view.frame.size.height/2)];
    bezVc.backgroundColor = [UIColor whiteColor];
    bezVc.staPoint = CGPointMake(0, 0);
    bezVc.ePoint =CGPointMake(100, 100);
    bezVc.pointArray = @[@"1,1",@"20,20",@"20,30",@"30,40",@"40,50",@"40,60",@"50,70",@"60,60",@"70,70",@"70,40",@"80,50",@"85,70",@"90,90",@"100,100"];
    [self.view addSubview:bezVc];

    
    [self.view addSubview:ew];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
