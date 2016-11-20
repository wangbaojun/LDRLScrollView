//
//  UIPullToReloadAnimationDelegate.h
//  LDCPPullToReload
//
//  Created by SongLi on 1/5/15.
//  Copyright (c) 2015 SongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIPullToReloadAnimationDelegate <NSObject>

@required

/**
 *  是否正在刷新动画
 */
@property (nonatomic, assign, readonly) BOOL isLoadingAnimating;

/**
 *  固定的view大小
 */
+ (CGSize)size;

/**
 *  最小动画时间
 */
- (NSTimeInterval)minAnimationDuration;

/**
 *  由"下拉刷新"变为"释放立即刷新"时的动画
 */
- (void)startTriggerAnimation;

/**
 *  由"释放立即刷新"变为"下拉刷新"时的动画
 */
- (void)resignTriggerAnimation;

/**
 *  "正在刷新"时的动画
 */
- (void)startLoadingAnimation;

/**
 *  停止"正在刷新"动画
 */
- (void)stopLoadingAnimation;

@optional

/*!
 *  @brief 设置Scrollview的偏移值
 *
 *  @param point 偏移
 */
- (void)draggingOffset:(CGPoint)point;

@end
