//
//  LDCPLoadMoreControlView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "LDCPLoadMoreControlView.h"
#import "LDCPLoadMoreView.h"
#import "ReactiveCocoa.h"
@interface  LDCPLoadMoreControlView ()
@property (nonatomic,strong) LDCPLoadMoreView      * loadMoreView;
@property (nonatomic,strong) LDCPLoadMoreViewModel * loadMoreViewModel;

@end
@implementation LDCPLoadMoreControlView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _loadMoreView = [[LDCPLoadMoreView alloc] initWithFrame:frame];
        _loadMoreView.userInteractionEnabled = NO;
        _loadMoreViewModel = [[LDCPLoadMoreViewModel alloc] init];
        
        @weakify(self)
        RAC(self.loadMoreView.labelMore, text) = RACObserve(self.loadMoreViewModel, stateText);
        [RACObserve(self.loadMoreViewModel, activityLoading) subscribeNext:^(NSNumber * x) {
            @strongify(self)
            BOOL loading = [x boolValue];
            if(loading){
                [self.loadMoreView.activityView startAnimating];
            }
            else{
                [self.loadMoreView.activityView stopAnimating];
            }
        }];
        [self setLoadMoreState:LDCPLoadMoreStateIdle];
        [self addSubview:_loadMoreView];
    }
    return self;
}

- (void) setLoadMoreState:(LDCPLoadMoreState ) refreshState{
    [self.loadMoreViewModel setLoadMoreState:refreshState];
}

- (LDCPLoadMoreState) loadMoreState{
    return self.loadMoreViewModel.loadMoreState;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.loadMoreView.frame = self.bounds;
}
@end
