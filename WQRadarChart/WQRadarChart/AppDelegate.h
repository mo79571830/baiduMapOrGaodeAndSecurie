//
//  AppDelegate.h
//  WQRadarChart
//
//  Created by 王祺祺 on 2016/11/21.
//  Copyright © 2016年 wangqiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

