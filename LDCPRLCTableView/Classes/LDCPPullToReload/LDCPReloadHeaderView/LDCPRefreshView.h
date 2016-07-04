//
//  LDCPRefreshView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import <UIKit/UIKit.h>
#import "UIPullToReloadAnimationDelegate.h"


@interface LDCPRefreshView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong)  UILabel *lastUpdatedLabel;

@property (nonatomic, strong)  UILabel *statusLabel;

@property (nonatomic, strong) UIView <UIPullToReloadAnimationDelegate> *animationView;

@end

//========================================================================================

//下拉状态
typedef NS_ENUM(NSInteger, UIPullToReloadStatus){
    kPullStatusNone = -1,
    kPullStatusReleaseToReload = 0,//释放立即刷新
    kPullStatusPullDownToReload	= 1,//下拉刷新
    kPullStatusLoading = 2 //正在刷新
} ;

@interface LDCPRefreshViewModel : NSObject

@property (nonatomic, assign) UIPullToReloadStatus reloadStatus;

@property (nonatomic, strong) NSString *stateText;/** 加载中提示语 */

@property (nonatomic, strong) NSString *lastUpdatedDateText;

@property (nonatomic, assign) BOOL isPullDown;

@property (nonatomic,strong) NSDate *lastCompletedDate;

- (void)setLastUpdatedDate:(NSDate *)lastDate;

@end