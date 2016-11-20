//
//  LDLoadMoreControlView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//


/**
 *  LDLoadMoreView 对应的viewModel ，负责数据的处理
 */
typedef NS_ENUM(NSInteger, LDLoadMoreState){
    LDLoadMoreStateNone,//隐藏加载更多
    LDLoadMoreStateLoading,//正在加载更多
    LDLoadMoreStateError,//加载更多错误状态
    LDLoadMoreStateNoMore,//全部加载完毕
    LDLoadMoreStateIdle,//空闲状态
};
/**
 *  加载更多view
 */
@interface LDLoadMoreControlView : UIControl

/**
 *  加载更多状态，通过设置状态，改变view的展示
 */
@property (nonatomic,assign) LDLoadMoreState loadMoreState;

- (instancetype) init NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
