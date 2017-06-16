//
//  ScriptCaculation.m
//  ZTFiyInspection
//
//  Created by 王祺祺 on 2017/4/24.
//  Copyright © 2017年 中天和悦（北京）科技有限公司. All rights reserved.
//

#import "ScriptCaculation.h"
#import <MAMapKit/MAMapKit.h>
#import "ZTRecordModel.h"
@implementation ScriptCaculation

NSString *const longitudeKey = @"longitude";
NSString *const latitudeKey = @"latitude";
NSString *const altitudeKey = @"altitude";

#pragma mark - 自动生成脚本
- (NSArray *)createScriptWithRows:(NSInteger)row cols:(NSInteger)col basePoints:(NSArray *)basePoints
{
    NSMutableArray * script = [NSMutableArray arrayWithCapacity:row * col];//总点数组
    if (row <= 0 || col <= 0 || basePoints == nil || [basePoints count] == 0) {
        return script;
    }
    
    NSDictionary *basePoint = [basePoints objectAtIndex:0];
    NSDictionary *anglePoint = [basePoints objectAtIndex:1];
    NSDictionary *heightPoint = [basePoints objectAtIndex:2];
    
    //各行列高度、经度、纬度平均间隔
    double uHeight = ([heightPoint[altitudeKey] doubleValue] - [basePoint[altitudeKey] doubleValue]) / (row - 1);//高度
    double uLongitude = ([anglePoint[longitudeKey] doubleValue] - [basePoint[longitudeKey] doubleValue]) / (col - 1);//经度段
    double uLatitude = ([anglePoint[latitudeKey] doubleValue] - [basePoint[latitudeKey] doubleValue]) / (col - 1);//纬度段
    
    for (int i=0; i < (row * col); i++) {
        NSMutableDictionary *point = [NSMutableDictionary dictionary];
        
        //各点高度
        double height = (i / col) * uHeight + [basePoint[altitudeKey] doubleValue];
        [point setValue:[NSNumber numberWithDouble:height] forKey:altitudeKey];
        
        //各点纬度
        double latitude = (i % col) * uLatitude + [basePoint[latitudeKey] doubleValue];
        [point setValue:[NSNumber numberWithDouble:latitude] forKey:latitudeKey];
        
        //各点经度
        double longitude = (i % col) * uLongitude + [basePoint[longitudeKey] doubleValue];
        [point setValue:[NSNumber numberWithDouble:longitude] forKey:longitudeKey];
        
        [script addObject:point];
    }
    
    return script;
}

#pragma mark - 复制脚本
- (NSArray *)copyScript:(NSArray *)originalScript withBasePointA:(NSDictionary *)pointA indexA:(NSInteger)indexA withBasePointB:(NSDictionary *)pointB indexB:(NSInteger)indexB
{
    NSMutableArray *newScript = [NSMutableArray arrayWithCapacity:[originalScript count]];
    if (originalScript == nil || [originalScript count] == 0) {
        return newScript;
    }
    
    NSDictionary *oldPA = originalScript[indexA];
    NSDictionary *oldPB = originalScript[indexB];
    
    //基准点高度差
    double altitudeX = [[pointA valueForKey:altitudeKey] doubleValue] - [[oldPA valueForKey:altitudeKey] doubleValue];
    
    //原脚本AB连线方位角
    CLLocationDirection oldDirection = [self getDirectionFromPointA:oldPA andPointB:oldPB];
    //新AB基准点连线方位角
    CLLocationDirection newDirection = [self getDirectionFromPointA:pointA andPointB:pointB];
    //角度差
    CLLocationDirection directionDifference = newDirection - oldDirection;
    
    //基准点pointA的经纬度坐标
    CLLocationCoordinate2D coordinatePointA = CLLocationCoordinate2DMake([pointA[latitudeKey] doubleValue], [pointA[longitudeKey] doubleValue]);
    
    //根据基准点修改脚本中所有点的经纬度和高度
    for (int i=0; i<[originalScript count]; i++) {
        NSMutableDictionary *scriptPoint = [NSMutableDictionary dictionaryWithDictionary:originalScript[i]];
        
        if (i == indexA) {
            [scriptPoint setValue:pointA[altitudeKey] forKey:altitudeKey];
            [scriptPoint setValue:pointA[latitudeKey] forKey:latitudeKey];
            [scriptPoint setValue:pointA[longitudeKey] forKey:longitudeKey];
            
            [newScript addObject:scriptPoint];
        }
        else {
            double altitude = altitudeX + [scriptPoint[altitudeKey] doubleValue];
            [scriptPoint setValue:[NSNumber numberWithDouble:altitude] forKey:altitudeKey];
            
            CLLocationDirection directionI = directionDifference + [self getDirectionFromPointA:oldPA andPointB:scriptPoint];
            CLLocationDistance distanceI = [self getDistanceBetweenPointA:oldPA andPointB:scriptPoint];
            
            //求新点坐标
            CLLocationCoordinate2D coordinate = [self coordinateWithBasePoint:coordinatePointA distance:distanceI direction:directionI];
            [scriptPoint setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:latitudeKey];
            [scriptPoint setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:longitudeKey];
            
            [newScript addObject:scriptPoint];
        }
    }
    
    return newScript;
}

/**
 根据新基准点、两点间的距离和方向角，计算新点的坐标
 
 @param basePoint 新基准点
 @param distance 与基准点的距离
 @param direction 两点的方向角
 @return 新点的地理坐标
 */
- (CLLocationCoordinate2D)coordinateWithBasePoint:(CLLocationCoordinate2D)basePoint distance:(CLLocationDistance)distance direction:(CLLocationDirection)direction
{
    //实际距离转为投影单位
    double pointsOfDistance = MAMapPointsPerMeterAtLatitude(basePoint.latitude) * distance;
    //角度转为弧度带入三角函数
    double x = sin(direction /180.0 * M_PI) * pointsOfDistance;
    double y = cos(direction / 180.0 * M_PI) * pointsOfDistance;
    //基准点转为投影点
    MAMapPoint mapPoint = MAMapPointForCoordinate(basePoint);
    
    MAMapPoint point;
    point.x = mapPoint.x + x;
    point.y = mapPoint.y - y;
    
    return MACoordinateForMapPoint(point);
}

/**
 计算A、B两点连线的方向角
 
 @param pointA A点信息（字典类型）
 @param pointB B点信息（字典类型）
 @return 方向角（0-359.9）
 */
- (CLLocationDirection)getDirectionFromPointA:(NSDictionary *)pointA andPointB:(NSDictionary *)pointB
{
    CLLocationCoordinate2D fromCoord = CLLocationCoordinate2DMake([pointA[latitudeKey] doubleValue], [pointA[longitudeKey] doubleValue]);
    CLLocationCoordinate2D toCoord = CLLocationCoordinate2DMake([pointB[latitudeKey] doubleValue], [pointB[longitudeKey] doubleValue]);
    return MAGetDirectionFromCoords(fromCoord, toCoord);
}


/**
 计算A、B两点之间的距离
 
 @param pointA A点信息（字典类型）
 @param pointB B点信息（字典类型）
 @return 两点之间的距离，double类型（米）
 */
- (CLLocationDistance)getDistanceBetweenPointA:(NSDictionary *)pointA andPointB:(NSDictionary *)pointB
{
    MAMapPoint pA = MAMapPointForCoordinate(CLLocationCoordinate2DMake([pointA[latitudeKey] doubleValue], [pointA[longitudeKey] doubleValue]));
    MAMapPoint pB = MAMapPointForCoordinate(CLLocationCoordinate2DMake([pointB[latitudeKey] doubleValue], [pointB[longitudeKey] doubleValue]));
    return MAMetersBetweenMapPoints(pA, pB);
}

@end
