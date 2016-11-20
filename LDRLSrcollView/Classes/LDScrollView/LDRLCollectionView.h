//
//  LDCPRLCollectionView.h
//  Pods
//
//  Created by ITxiansheng on 16/7/1.
//
//

#import <UIKit/UIKit.h>
#import "LDRefreshControlView.h"
#import "LDLoadMoreControlView.h"

@interface LDRLCollectionView : UICollectionView

@property (nonatomic,strong) LDRefreshControlView  * refreshView;
@property (nonatomic,strong) LDLoadMoreControlView * loadMoreView;

/**
 *  @author ITxiansheng, 16-07-01 13:07:25
 *
 *  @brief 控制是否隐藏 加载更多view  默认是不隐藏的
 */
@property (nonatomic,assign) BOOL hideLoadMoreView;

/**
 *  设置上拉刷新回调
 *
 *  @param pullRefreshBlock 下拉刷新block
 */
- (void) setPullRefreshBlock:(void(^)()) pullRefreshBlock;

/**
 *  设置加载更多回调
 *
 *  @param loadMoreBlock 加载更多block
 */
- (void) setLoadMoreBlock:(void(^)()) loadMoreBlock;

/**
 *  @author ITxiansheng, 16-07-01 13:07:21
 *
 *  @brief 手动控制开始下拉刷新，并且可以指定刷新的过程中是否有动画
 *
 *  @param animated 是否展示动画
 */
- (void) beginRefreshAnimated:(BOOL)animated;


/**
 *  @author ITxiansheng, 16-07-01 13:07:02
 *
 *  @brief 手动控制结束下拉刷新，并且可以指定结束刷新的过程中是否有动画
 *
 *  @param animated 是否展示动画
 */
- (void) endRefreshAnimated:(BOOL)animated;


/**
 *  @author ITxiansheng, 16-07-01 13:07:45
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
