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

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

//KVO监测的scrollview属性
static NSString * const LDContentOffsetKeyPath = @"contentOffset";
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

#pragma mark - life style

//只给出固定高度60，位置和宽度根据父view的观察值去计算
- (instancetype) init {
    self = [super init];
    if(self){
        self.clipsToBounds = YES;
        _refreshView = [[LDRefreshView alloc] init];
        _refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_refreshView];
        [self initViewModelKVO];
        self.refreshStatus = LDRefreshFinished;
    }
    return self;
}

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
    }
    [super willMoveToSuperview:newSuperview];
}


- (void)dealloc{
    
    [self removeObserver:self forKeyPath:refreshStatusKeyPath];
}

#pragma mark - private

- (void)startLoadingAnimation{
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.refreshView startLoadingAnimation];
    });
}

- (void)initViewModelKVO {
    
    [self addObserver:self forKeyPath:refreshStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
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


#pragma mark - public

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
    
    if(self.refreshStatus == LDRefreshFinished){
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

- (void) setRefreshStatus:(LDRefreshStatus)refreshStatus {
    
    if(refreshStatus != LDRefreshLoading) {
        self.observerView.ld_contentInsertTop = 0;
    }
    _refreshStatus= refreshStatus;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.isHidden||self.alpha < 0.01) {
        return;
    }
    //监控手势停止
    if([keyPath isEqualToString:LDPanStateKeyPath]) {
        UIPanGestureRecognizer * panGestureRecognizer = object;
        if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
            if(self.refreshStatus == LDRefreshLoading && -self.observerView.contentOffset.y >=LDRefreshHeight){
                self.observerView.ld_contentInsertTop = LDRefreshHeight;
                self.frame = CGRectMake(0, -LDRefreshHeight, self.observerView.contentSize.width,LDRefreshHeight);
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }else{
                self.refreshStatus = LDRefreshFinished;
            }
        }
        return;
    }
    
    //Y轴偏移量变化
    if([keyPath isEqualToString:LDContentOffsetKeyPath]) {
        if(self.refreshStatus != LDRefreshLoading) {
            CGFloat offset = [[change objectForKey:@"new"]CGPointValue].y;
            //下拉过程中，逐渐拉大圆
            if(-offset < LDRefreshHeight-8.0f) {
                if(self.refreshStatus != LDRefreshPullDowning){
                    self.refreshStatus = LDRefreshPullDowning;
                }
                self.frame = CGRectMake(0, offset, self.observerView.contentSize.width,-offset);
            }
            //触发翻滚，接着触发摇晃
            else if (- offset >= LDRefreshHeight-8.0f){
                if(self.refreshStatus != LDRefreshRollOver){
                    self.refreshStatus = LDRefreshRollOver;
                    if (self.refreshStatus != LDRefreshLoading ) {
                        [self setRefreshStatus:LDRefreshLoading];
                    }
                }
            }
        }else {
            /*惯性滑动可能导致y轴偏移 大于 手势停止时的y轴偏移，引起小猫晃动。但是ld_contentOffsetTop此时还是0.这种情况下，再下拉列表时，设置状态为LDRefreshFinished
             */
            if (self.observerView.ld_contentOffsetTop == 0 && -self.observerView.contentOffset.y <=LDRefreshHeight){
                [self setRefreshStatus:LDRefreshFinished];
            }
        }
        return ;
    }
    //监控 scrollview size 变化
    if([keyPath isEqualToString:LDContentSizeKeyPath]) {
        CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
        self.frame = CGRectMake(0, -LDRefreshHeight, contentSize.width,LDRefreshHeight);
        return ;
    }
    
    if([keyPath isEqualToString:refreshStatusKeyPath]) {
        LDRefreshStatus status = [[change objectForKey:@"new"] integerValue];
        switch (status) {
            case LDRefreshPullDowning:
                [self.refreshView stopLoadingAnimation];
                break;
            case LDRefreshRollOver:
                [self.refreshView stopLoadingAnimation];
                [self.refreshView startRollOverAnimation];
                break;
            case LDRefreshLoading:
                [self startLoadingAnimation];
                animationBeginDate = [NSDate date];
                break;
            case LDRefreshFinished:
                [self.refreshView stopLoadingAnimation];
                break;
            default:
                break;
        }
        return;
    }
}


@end
