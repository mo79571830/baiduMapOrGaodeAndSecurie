//
//  ScriptCaculation.h
//  ZTFiyInspection
//
//  Created by 王祺祺 on 2017/4/24.
//  Copyright © 2017年 中天和悦（北京）科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ScriptCaculation : NSObject

/**
 以两个新的基准点为参考，复制原有脚本并返回新的脚本
 
 @param originalScript 原脚本，即模板脚本
 @param pointA 基准点A
 @param indexA 基准点A对应脚本的航点序号
 @param pointB 基准点B
 @param indexB 基准点B对应脚本的航点序号
 @return 新脚本
 */
- (NSArray *)copyScript:(NSArray *)originalScript
         withBasePointA:(NSDictionary *)pointA
                 indexA:(NSInteger)indexA
         withBasePointB:(NSDictionary *)pointB
                 indexB:(NSInteger)indexB;

/**
 给定行数、列数和三个基准点生成飞行脚本
 
 @param row 脚本包含的行数
 @param col 脚本包含的列数
 @param basePoints 包含至少三个基准点，按顺序依次是:定位基准点，方位角基准点，高度基准点
 @return 按给定信息生成的脚本
 */
- (NSArray *)createScriptWithRows:(NSInteger)row
                             cols:(NSInteger)col
                       basePoints:(NSArray *)basePoints;

/**
 计算A、B两点连线的方向角
 
 @param pointA A点信息（字典类型）
 @param pointB B点信息（字典类型）
 @return 方向角（0-359.9）
 */
- (CLLocationDirection)getDirectionFromPointA:(NSDictionary *)pointA andPointB:(NSDictionary *)pointB;

/**
 计算A、B两点之间的距离
 
 @param pointA A点信息（字典类型）
 @param pointB B点信息（字典类型）
 @return 两点之间的距离，double类型（米）
 */
- (CLLocationDistance)getDistanceBetweenPointA:(NSDictionary *)pointA andPointB:(NSDictionary *)pointB;


@end
