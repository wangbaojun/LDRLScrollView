//
//  LDRJTableView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDRLTableView.h"

typedef void(^LDNoneParameterBlock)();

@interface LDRLTableView ()


@property (nonatomic,copy) LDNoneParameterBlock refrshBlock;
@property (nonatomic,copy) LDNoneParameterBlock loadMoreBlock;

@end

@implementation LDRLTableView

- (instancetype ) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if(self){
        _refreshView = [[LDRefreshControlView alloc] init];
        _loadMoreView = [[LDLoadMoreControlView alloc] init];
        [self addSubview:_refreshView];
        [self addSubview:_loadMoreView];
        self.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf4/255.0 alpha:1.0];
    }
    return self;
}

- (void) beginRefreshAnimated:(BOOL)animated {
    
    [self.refreshView beginRefreshAnimated:animated];
}

- (void) endRefreshAnimated:(BOOL)animated {
    
    [self.refreshView endRefreshAnimated:animated];
}

- (void) setLoadMoreState:(LDLoadMoreState ) loadMoreState {
    
    [self.loadMoreView setLoadMoreState:loadMoreState];
}

- (LDLoadMoreState) getLoadMoreState{
    
    return  self.loadMoreView.loadMoreState;
}
- (void) setHideLoadMoreView:(BOOL)shouldLoadMoreViewHidden {
    
    self.loadMoreView.hidden = shouldLoadMoreViewHidden;
}

- (BOOL) hideLoadMoreView {
    
    return self.loadMoreView.hidden;
}

- (void) setPullRefreshBlock:(void (^)())pullRefreshBlock {
    
    _refrshBlock = pullRefreshBlock;
    [self.refreshView addTarget:self action:@selector(pullRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void) pullRefresh:(id)sender {
    
    if(self.refrshBlock){
        self.refrshBlock();
    }
}

- (void) setLoadMoreBlock:(void (^)())loadMoreBlock {
    
    _loadMoreBlock = loadMoreBlock;
    [self.loadMoreView addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventValueChanged];
}

- (void) loadMore:(id)sender {
    
    if(self.loadMoreBlock){
        self.loadMoreBlock();
    }
}

@end
