//
//  LDLoadMoreControlView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "LDLoadMoreControlView.h"
#import "LDLoadMoreView.h"
#import "UIScrollView+ContentExtension.h"

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
//KVO监测的scrollView属性
static NSString * const LDOffsetKeyPath      = @"contentOffset";
static NSString * const LDContentSizeKeyPath = @"contentSize";

//KVO监测的ViewModel属性
static NSString *  const  LDLoadMoreStateKeyPath = @"loadMoreState";

const CGFloat LDLoadMoreHeight   = 49.0f;//LoadMore的高度

@interface  LDLoadMoreControlView ()

@property (nonatomic,strong) LDLoadMoreView * loadMoreView;
@property (nonatomic,weak) UIScrollView * observerView;

@end

@implementation LDLoadMoreControlView

- (instancetype) init{
    
    self = [super init];
    if (self) {
        _loadMoreView = [LDLoadMoreView new];
        _loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_loadMoreView];
        _loadMoreView.userInteractionEnabled = NO;
        [self initViewModelKVO];
        [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


//被点击
- (void) clicked:(id) sender {
    if((self.loadMoreState==LDLoadMoreStateIdle || self.loadMoreState==LDLoadMoreStateError)){
        //发出UIControlEventValueChanged事件,触发对应的 selector（外部设置）
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self setLoadMoreState:LDLoadMoreStateLoading];
    }
}

//当子view添加到父view上或者从父view上移除，调用此方法
- (void) willMoveToSuperview:(UIScrollView *)newSuperview {
    //移除父view观察者
    [self.superview removeObserver:self forKeyPath:LDOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:LDContentSizeKeyPath];
    //添加到父view上
    if(newSuperview) {
        NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"父View 必须是ScrollView 或者其子类");
        //对新的父view进行观察
        [newSuperview addObserver:self forKeyPath:LDOffsetKeyPath
                          options:NSKeyValueObservingOptionNew context:nil];
        
        [newSuperview addObserver:self forKeyPath:LDContentSizeKeyPath
                          options:NSKeyValueObservingOptionNew context:nil];
        self.observerView = newSuperview;
        self.observerView.clipsToBounds = YES;
        //添加到scrollview时，scrollview的contentsize此时为0
        self.observerView.ld_contentInsertBottom += LDLoadMoreHeight;
    }
    //从父view上移除
    else{
        self.observerView.ld_contentInsertBottom -= LDLoadMoreHeight;
    }
    [super willMoveToSuperview:newSuperview];
}

//重写setter，设置scrollView的contentInset.bottom
- (void) setHidden:(BOOL)hidden {
    //设置完 bottom会直接跳转到 contentsize kvo方法中
    if(!hidden&&super.hidden){
        [super setHidden:hidden];
        self.observerView.ld_contentInsertBottom += LDLoadMoreHeight;
    }
    else if(hidden&&!super.hidden){
        [super setHidden:hidden];
        self.observerView.ld_contentInsertBottom -= LDLoadMoreHeight;
    }
}

#pragma mark - private

- (void)initViewModelKVO {
    
    [self addObserver:self forKeyPath:LDLoadMoreStateKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setViewBy:(LDLoadMoreState) loadMoreState{
    switch (loadMoreState) {
        case LDLoadMoreStateNone:
            self.hidden = YES;
            [self.loadMoreView.indicatorView stopAnimating];
            [self.loadMoreView.indicatorView setImage:nil];
            [self.loadMoreView.errorImageView setImage:nil];
            [self.loadMoreView.smileImageview setImage:nil];
            self.loadMoreView.labelMore.text = nil;
            break;
        case LDLoadMoreStateNoMore:
            self.hidden = NO;
            [self.loadMoreView.indicatorView stopAnimating];
            [self.loadMoreView.indicatorView setImage:nil];
            [self.loadMoreView.errorImageView setImage:nil];
            [self.loadMoreView.smileImageview setImage:[self.loadMoreView smileImage]];
            self.loadMoreView.labelMore.text = @"已经到底啦~";
            break;
        case LDLoadMoreStateError:
            self.hidden = NO;
            [self.loadMoreView.indicatorView stopAnimating];
            [self.loadMoreView.indicatorView setImage:nil];
            [self.loadMoreView.errorImageView setImage:[self.loadMoreView errorImage]];
            [self.loadMoreView.smileImageview setImage:nil];
            self.loadMoreView.labelMore.text = @"加载失败，请点击重试";
            break;
        case LDLoadMoreStateIdle:
            self.hidden = NO;
            [self.loadMoreView.indicatorView stopAnimating];
            [self.loadMoreView.indicatorView setImage:nil];
            [self.loadMoreView.smileImageview setImage:nil];
            [self.loadMoreView.errorImageView setImage:nil];
            self.loadMoreView.labelMore.text = @"上拉加载更多";
            break;
        case LDLoadMoreStateLoading:
            self.hidden = NO;
            [self.loadMoreView.indicatorView setImage:[self.loadMoreView indicatorImage]];
            [self.loadMoreView.indicatorView startAnimating];
            [self.loadMoreView.smileImageview setImage:nil];
            [self.loadMoreView.errorImageView setImage:nil];
            self.loadMoreView.labelMore.text = @"正在努力加载..";
            break;
        default:
            break;
    }
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //监测scrollView的contentOffset变化
    if([keyPath isEqualToString:LDOffsetKeyPath]) {
        if(!(self.isHidden||self.alpha < 0.01)&&(self.loadMoreState==LDLoadMoreStateIdle)) {
            //scrollView的contentsize的高度不为0，并且滑出LoadMore时，触发Action
            if(self.observerView.contentSize.height != 0 && self.observerView.contentOffset.y + self.observerView.bounds.size.height - self.observerView.contentSize.height > 0) {
                //发出UIControlEventTouchUpInside事件,触发对应的 selector（clicked:）
                [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        return ;
    }
    //监测scrollView的contentSize变化, 调整self的frame
    if([keyPath isEqualToString:LDContentSizeKeyPath]) {
        CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
        CGFloat height = (fequal(contentSize.height,0.0f)) ? 0.0f :LDLoadMoreHeight;
        self.frame = CGRectMake(0, contentSize.height, contentSize.width,height);
        return;
    }
    //监测ViewModel的LDLoadMoreState,设置显示
    if([keyPath isEqualToString:LDLoadMoreStateKeyPath]) {
        LDLoadMoreState  loadMoreState = [(NSNumber *)[change objectForKey:@"new"] integerValue];
        [self setViewBy:loadMoreState];
        return ;
    }
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:LDLoadMoreStateKeyPath];
}
@end
