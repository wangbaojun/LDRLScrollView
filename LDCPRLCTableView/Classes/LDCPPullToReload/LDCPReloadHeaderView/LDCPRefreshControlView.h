//
//  LDCPRefreshControlView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDCPRefreshControl.h"

@interface LDCPRefreshControlView : LDCPRefreshControl

/**
 *  @author ITxiansheng, 16-06-30 17:06:53
 *
 *  @brief 手动执行刷新的操作，可以指定在header下拉的过程中
      是否产生动画效果
 *
 *  @param animated 是否产生动画
 */
- (void) beginRefreshAnimated:(BOOL)animated;

/**
 *  @author ITxiansheng, 16-06-30 17:06:14
 *
 *  @brief 手动执行结束刷新,可以指定在header结束的时候是否产生动画
 *
 *  @param animated 是否产生动画
 */
- (void) endRefreshAnimated:(BOOL)animated;

@end
