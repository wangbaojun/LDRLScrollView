//
//  LDCPRJTableView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import <UIKit/UIKit.h>
#import "LDCacheTableView.h"
#import "LDRefreshControlView.h"
#import "LDLoadMoreControlView.h"

@interface LDRLTableView : LDCacheTableView

@property (nonatomic,strong) LDRefreshControlView  *refreshView;
@property (nonatomic,strong) LDLoadMoreControlView *loadMoreView;

/**
*
*  @brief 控制是否隐藏 加载更多view  默认是隐藏的
*
*/
@property (nonatomic,assign) BOOL hideLoadMoreView;

/**
 *  设置上拉刷新block
 *
 *  @param pullRefreshBlock 下拉刷新block
 */
- (void) setPullRefreshBlock:(void(^)()) pullRefreshBlock;

/**
 *  设置加载更多block
 *
 *  @param loadMoreBlock 加载更多block
 */
- (void) setLoadMoreBlock:(void(^)()) loadMoreBlock;

/**
 *
 *  @brief 代码控制开始下拉刷新，并且可以指定刷新的过程中是否有动画
 *
 *  @param animated 是否展示动画
 */
- (void) beginRefreshAnimated:(BOOL)animated;

/**
 *
 *  @brief 代码控制结束下拉刷新，并且可以指定结束刷新的过程中是否有动画
 *
 *  @param animated 是否展示动画
 */
- (void) endRefreshAnimated:(BOOL)animated;

/**
 *
 *  @brief 设置 LoadMore view 的状态，不同的状态对应不同的展示
 *
 *  @param loadMoreState 要展示的状态
 */
- (void) setLoadMoreState:(LDLoadMoreState) loadMoreState;

/**
 获得LoadMore现在的状态
 
 @return LoadMore现在的状态
 */
- (LDLoadMoreState) getLoadMoreState;

@end
