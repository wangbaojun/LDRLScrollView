//
//  LDCPRefreshControlView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//


//下拉状态
typedef NS_ENUM(NSInteger, LDRefreshStatus){
    LDRefreshNone = -1,
    LDRefreshPullDowning = 0,//小圈逐渐变圆
    LDRefreshRollOver	= 1,//小猫翻滚
    LDRefreshLoading = 2 ,//小猫摇晃
    LDRefreshFinished = 3 //加载完毕
} ;

@interface LDRefreshControlView : UIControl

@property (nonatomic,assign) LDRefreshStatus refreshStatus;

/**
 *
 *  @brief 手动执行刷新的操作，可以指定在header下拉的过程中
      是否产生动画效果
 *
 *  @param animated 是否产生动画
 */
- (void) beginRefreshAnimated:(BOOL)animated;

/**
 *
 *  @brief 手动执行结束刷新,可以指定在header结束的时候是否产生动画
 *
 *  @param animated 是否产生动画
 */
- (void) endRefreshAnimated:(BOOL)animated;

- (instancetype) init NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
