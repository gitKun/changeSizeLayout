//
//  DRCustomUnit.m
//  CollectionViewRefreshDemo
//
//  Created by 李亚坤 on 2019/10/20.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "DRCustomUnit.h"

@implementation DRCustomUnit


/*
 `translationInView:`     手指在视图上移动的位置（x,y）向下和向右为正,向上和向左为负.
 `locationInView:`        手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置.
 `velocityInView:`        手指在视图上移动的速度（x,y), 正负也是代表方向, 值得一提的是在绝对值上 |x| > |y| 水平移动, |y| > |x| 竖直移动.
 */
// FIXME: 放到工具类中
+ (DRPanGestureDirection)gestureDirectionFromCommitTranslation:(CGPoint)translation ignoreDirectionLength:(CGFloat)ignore {
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    // 设置滑动有效距离
    if (MAX(absX, absY) < ignore) return DRPanGestureDirectionNone;
    
    if (absX > absY ) {
        if (translation.x<0) {
            //向左滑动
            return DRPanGestureDirectionLeft;
        }else{
            //向右滑动
            return DRPanGestureDirectionRight;
        }
        
    } else if (absY > absX) {
        if (translation.y<0) {
            //向上滑动
            return DRPanGestureDirectionUp;
        }else{
            //向下滑动
            return DRPanGestureDirectionDown;
        }
    }
    return DRPanGestureDirectionNone;
}

@end
