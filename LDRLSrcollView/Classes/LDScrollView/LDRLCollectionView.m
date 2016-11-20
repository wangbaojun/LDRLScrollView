//
//  LDCPRLCollectionView.m
//  Pods
//
//  Created by ITxiansheng on 16/7/1.
//
//

#import "LDRLCollectionView.h"

typedef void(^LDNoneParameterBlock)();

@interface LDRLCollectionView ()


@property (nonatomic,copy) LDNoneParameterBlock refrshBlock;
@property (nonatomic,copy) LDNoneParameterBlock loadMoreBlock;

@end

@implementation LDRLCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout   {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        self.alwaysBounceVertical = YES;
        _refreshView = [[LDRefreshControlView alloc] init];
        _loadMoreView = [[LDLoadMoreControlView alloc] init];
        self.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf4/255.0 alpha:1.0];
        [self addSubview:_refreshView];
        [self addSubview:_loadMoreView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return [self initWithFrame:frame collectionViewLayout:layout];
}

- (void) beginRefreshAnimated:(BOOL)animated{
    
    [self.refreshView beginRefreshAnimated:animated];
}

- (void) endRefreshAnimated:(BOOL)animated{
    
    [self.refreshView endRefreshAnimated:animated];
}

- (void) setLoadMoreState:(LDLoadMoreState ) loadMoreState{
    
    [self.loadMoreView setLoadMoreState:loadMoreState];
}

- (LDLoadMoreState) getLoadMoreState{
    return  self.loadMoreView.loadMoreState;
}

- (void) setHideLoadMoreView:(BOOL)shouldLoadMoreViewHidden{
    
    self.loadMoreView.hidden = shouldLoadMoreViewHidden;
}

- (BOOL) hideLoadMoreView{
    
    return self.loadMoreView.hidden;
}

- (void) setPullRefreshBlock:(void (^)())pullRefreshBlock{
    
    _refrshBlock = pullRefreshBlock;
    [self.refreshView addTarget:self action:@selector(pullRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void) pullRefresh:(id)sender{
    
    if(self.refrshBlock){
        self.refrshBlock();
    }
}

- (void) setLoadMoreBlock:(void (^)())loadMoreBlock{
    
    _loadMoreBlock = loadMoreBlock;
    [self.loadMoreView addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventValueChanged];
}

- (void) loadMore:(id)sender{
    
    if(self.loadMoreBlock){
        self.loadMoreBlock();
    }
}
@end
