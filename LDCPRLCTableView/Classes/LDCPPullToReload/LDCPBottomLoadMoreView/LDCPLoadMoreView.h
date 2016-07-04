//
//  LDCPLoadMoreView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import <UIKit/UIKit.h>

@interface LDCPLoadMoreView : UIView

@property (nonatomic,strong) UILabel                 * labelMore;
@property (nonatomic,strong) UIActivityIndicatorView * activityView;

@end

//====================================================================================

/**
 *  LDCPRefreshView 对应的viewModel ，负责数据的处理
 */

typedef NS_ENUM(NSInteger, LDCPLoadMoreState){
    LDCPLoadMoreStateNone,
    LDCPLoadMoreStateLoading,
    LDCPLoadMoreStateError,
    LDCPLoadMoreStateNoMore,
    LDCPLoadMoreStateIdle,
};

@interface LDCPLoadMoreViewModel : NSObject

/**
 *  设置 loadState 以改变 状态文本和loading 状态
 */
@property (nonatomic,assign) LDCPLoadMoreState loadMoreState;

@property (nonatomic,strong,readonly) NSString * stateText;
@property (nonatomic,assign,readonly) BOOL activityLoading;

@end
