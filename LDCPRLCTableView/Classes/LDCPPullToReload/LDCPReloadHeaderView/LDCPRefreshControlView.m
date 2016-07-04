//
//  LDCPRefreshControlView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDCPRefreshControlView.h"
#import "LDCPRefreshView.h"
#import "ReactiveCocoa.h"
#import "UIScrollView+ContentExtension.h"

@interface LDCPRefreshControlView ()

@property (nonatomic,strong) LDCPRefreshView * refreshView;
@property (nonatomic,strong) LDCPRefreshViewModel * refreshViewModel;

@end

@implementation LDCPRefreshControlView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _refreshView = [[LDCPRefreshView alloc] initWithFrame:frame];
        _refreshViewModel = [[LDCPRefreshViewModel alloc] init];
        
        self.refreshStatus = kPullStatusPullDownToReload;
        @weakify(self)
        RAC(self.refreshView.statusLabel, text) = RACObserve(self.refreshViewModel, stateText);
        RAC(self.refreshView.lastUpdatedLabel, text) = RACObserve(self.refreshViewModel, lastUpdatedDateText);
        [RACObserve(self.refreshViewModel, isPullDown) subscribeNext:^(id x) {
            BOOL isPullDown = [x boolValue];
            if (isPullDown) {
                //如果监测到用户下拉即将出现header，则重新计算刷新时间 并 重新显示
                [self.refreshViewModel setLastUpdatedDate:self.refreshViewModel.lastCompletedDate];
            }
        }];

        [RACObserve(self.refreshViewModel, reloadStatus) subscribeNext:^(id x) {
            @strongify(self);
            UIPullToReloadStatus status = [x integerValue];
            switch (status) {
                case kPullStatusReleaseToReload:
                    [self.refreshView.animationView startTriggerAnimation];
                    break;
                case kPullStatusPullDownToReload:
                    [self.refreshView.animationView stopLoadingAnimation];
                    [self.refreshView.animationView startTriggerAnimation];
                    break;
                case kPullStatusLoading:
                    [self.refreshView.animationView startLoadingAnimation];
                    break;
                default:
                    break;
            }}];
        [self addSubview:_refreshView];
    }
    return self;
}

- (void) setRefreshStatus:(UIPullToReloadStatus)refreshStatu{
    [super setRefreshStatus:refreshStatu];
    [self.refreshViewModel setReloadStatus:refreshStatu];
}

- (void)setIsPullDown:(BOOL)isPullDown{
    self.refreshViewModel.isPullDown = isPullDown;
}
- (void) layoutSubviews{
    self.refreshView.frame = self.bounds;
}

- (void) beginRefreshAnimated:(BOOL)animated{

    if (animated) {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.4
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^ {
                             self.observerView.ldcp_contentOffsetTop = -self.refreshView.bounds.size.height;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else{
        self.observerView.ldcp_contentOffsetTop = -self.refreshView.bounds.size.height;
    }
    [self setRefreshStatus:kPullStatusLoading];
}

- (void) endRefreshAnimated:(BOOL)animated{
    if(self.refreshViewModel.reloadStatus == kPullStatusPullDownToReload){
        return;
    }
    if (animated) {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.4
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^ {
                             self.observerView.ldcp_contentOffsetTop = 0;

                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.observerView.ldcp_contentOffsetTop = 0;
    }
    [self setRefreshStatus:kPullStatusPullDownToReload];

}
@end
