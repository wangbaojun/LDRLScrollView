//
//  LDRefreshControlView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDRefreshControlView.h"
#import "LDRefreshView.h"
#import "UIScrollView+ContentExtension.h"

//KVO监测的scrollview属性
static NSString * const LDContentOffsetKeyPath      = @"contentOffset";
static NSString * const LDContentSizeKeyPath = @"contentSize";
//KVO监测的手势
static NSString * const LDPanStateKeyPath    = @"state";
//KVO监测的viewModel属性
static NSString * const  refreshStatusKeyPath = @"refreshStatus";

static const CGFloat LDRefreshHeight   = 60.0f;//高度
static NSDate *animationBeginDate ;//动画开始时间
static const NSTimeInterval miniAnimationTime = 0.0f;//秒

@interface LDRefreshControlView ()

@property (nonatomic,strong) LDRefreshView *refreshView;
@property (nonatomic,weak) UIScrollView *observerView;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation LDRefreshControlView

@synthesize refreshStatus = _refreshStatus;

//只给出固定高度60，位置和宽度根据父view的观察值去计算
- (instancetype) init {
    self = [super init];
    if(self){
        self.clipsToBounds = YES;
        _refreshView = [[LDRefreshView alloc] init];
        _refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_refreshView];
        [self initViewModelKVO];
        self.refreshStatus = LDRefreshPullDownToReload;
    }
    return self;
}

#pragma mark - private
- (void) willMoveToSuperview:(UIScrollView *)newSuperview {
    
    [self.superview removeObserver:self forKeyPath:LDContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:LDContentSizeKeyPath];
    [self.panGestureRecognizer removeObserver:self forKeyPath:LDPanStateKeyPath context:nil];
    self.panGestureRecognizer = nil;
    
    if(newSuperview){
        NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"父View 必须是ScrollView 或者其子类");
        [newSuperview addObserver:self forKeyPath:LDContentOffsetKeyPath
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        [newSuperview addObserver:self forKeyPath:LDContentSizeKeyPath
                          options:NSKeyValueObservingOptionNew context:nil];
        
        [newSuperview.panGestureRecognizer addObserver:self forKeyPath:LDPanStateKeyPath
                                               options:NSKeyValueObservingOptionNew context:nil];
        self.panGestureRecognizer = newSuperview.panGestureRecognizer;
        self.observerView = newSuperview;
        self.observerView.clipsToBounds =YES;
        self.frame = CGRectMake(0, -self.bounds.size.height,self.bounds.size.width, LDRefreshHeight);
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)initViewModelKVO {
    [self addObserver:self forKeyPath:refreshStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void) setRefreshStatus:(LDRefreshStatus)refreshStatus {
    
    if(refreshStatus == LDRefreshLoading) {
        self.observerView.ld_contentInsertTop = self.bounds.size.height;
    }
    else {
        self.observerView.ld_contentInsertTop = 0;
    }
      _refreshStatus= refreshStatus;
}

- (void) beginRefreshAnimated:(BOOL)animated {
    
    if (animated) {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.4
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^ {
                             self.observerView.ld_contentOffsetTop = -self.refreshView.bounds.size.height;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else {
        self.observerView.ld_contentOffsetTop = -self.refreshView.bounds.size.height;
    }
    [self setRefreshStatus:LDRefreshLoading];
}

- (void)endRefreshAnimated:(BOOL)animated {
    
    if(self.refreshStatus == LDRefreshPullDownToReload){
        return;
    }
    NSTimeInterval time = miniAnimationTime - [[NSDate date]timeIntervalSinceDate:animationBeginDate];
    __weak typeof(self) weakSelf = self;
    if (time-0.0f>DBL_EPSILON) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf finishAnimated:animated];
        });
    } else {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf finishAnimated:animated];
    }
}

- (void)finishAnimated:(BOOL)animated {
    
    if (animated) {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^ {
                             self.observerView.ld_contentOffsetTop = 0;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.observerView.ld_contentOffsetTop = 0;
    }
    [self setRefreshStatus:LDRefreshFinished];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.isHidden||self.alpha < 0.01) {
        return;
    }
    
    if(self.refreshStatus != LDRefreshLoading) {
        //pan手势end
        if([keyPath isEqualToString:LDPanStateKeyPath]) {
            UIPanGestureRecognizer * panGestureRecognizer = object;
            if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
                if(-self.observerView.contentOffset.y > self.bounds.size.height){
                    [self setRefreshStatus:LDRefreshLoading];
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
        }
        //Y轴偏移量变化
        else if([keyPath isEqualToString:LDContentOffsetKeyPath]) {
            CGFloat offset = [[change objectForKey:@"new"]    CGPointValue].y;
            //如果全漏出继续下拉，且现在的状态不是正在刷新状态
            if(- offset > self.bounds.size.height&&self.refreshStatus != LDRefreshReleaseToReload){
                [self setRefreshStatus:LDRefreshReleaseToReload];
            }
            //如果没有全拉出
            else if(-offset < self.bounds.size.height) {
                if(self.refreshStatus != LDRefreshPullDownToReload){
                    self.refreshStatus = LDRefreshPullDownToReload;
                }
            }
        }
    }
    //设置frame
    if([keyPath isEqualToString:LDContentSizeKeyPath]) {
        CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
        self.frame = CGRectMake(0, -LDRefreshHeight, contentSize.width,LDRefreshHeight);
    }
    //刷新状态改变，影响小猪动画及提示词
    if([keyPath isEqualToString:refreshStatusKeyPath]) {
        LDRefreshStatus status = [[change objectForKey:@"new"] integerValue];
        switch (status) {
            case LDRefreshReleaseToReload:
                [self.refreshView.animationView startTriggerAnimation];
                self.refreshView.statusLabel.text = @"松手刷新";
                break;
            case LDRefreshPullDownToReload:
                [self.refreshView.animationView stopLoadingAnimation];
                self.refreshView.statusLabel.text = @"下拉刷新";
                break;
            case LDRefreshLoading:
                [self.refreshView.animationView startLoadingAnimation];
                animationBeginDate = [NSDate date];
                self.refreshView.statusLabel.text = @"好运加载中";
                break;
            case LDRefreshFinished:
                [self.refreshView.animationView stopLoadingAnimation];
                break;
            default:
                break;
        }
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:refreshStatusKeyPath];
}

@end
