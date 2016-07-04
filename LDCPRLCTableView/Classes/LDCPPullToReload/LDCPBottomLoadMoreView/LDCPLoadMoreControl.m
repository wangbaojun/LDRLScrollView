//
//  LDCPLoadMoreControl.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "LDCPLoadMoreControl.h"
#import "UIScrollView+ContentExtension.h"
//KVO监测的属性
static NSString * const LDCPOffsetKeyPath      = @"contentOffset";
static NSString * const LDCPContentSizeKeyPath = @"contentSize";
//手势
static NSString * const LDCPPanStateKeyPath    = @"state";
const CGFloat LDCPLoadMoreHeight   = 44.0f;

@interface LDCPLoadMoreControl ()

@property (nonatomic,weak) UIScrollView * observerView;
@property (nonatomic,strong) UIPanGestureRecognizer * panGestureRecognizer;

@end

@implementation LDCPLoadMoreControl

- (instancetype) init{
    //只给出固定高度44，位置和宽度根据父view的观察值去计算
    return [self initWithFrame:CGRectMake(0, 0, 0, LDCPLoadMoreHeight)];
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self setLoadMoreState:LDCPLoadMoreStateIdle];
    }
    return self;
}

//被点击
- (void) clicked:(id) sender{
    if(self.loadMoreState != LDCPLoadMoreStateLoading){
        //发出事件
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self setLoadMoreState:LDCPLoadMoreStateLoading];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.isHidden||self.alpha < 0.01){
        return;
    }

    if(self.loadMoreState != LDCPLoadMoreStateLoading){
        if([keyPath isEqualToString:LDCPPanStateKeyPath]){
            UIPanGestureRecognizer * panGestureRecognizer = object;
            if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
                //用户滑动手势停止时，监测是否满足 上拉加载 更多的条件
                if(self.observerView.contentOffset.y + self.observerView.bounds.size.height - self.observerView.contentSize.height > 0){
                    //发出事件
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                    [self setLoadMoreState:LDCPLoadMoreStateLoading];
                }
            }
        }
    }
    //监测父view contentSize变化 调整 self的frame
    if([keyPath isEqualToString:LDCPContentSizeKeyPath]){
        CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
        self.frame = CGRectMake(0, contentSize.height, contentSize.width,LDCPLoadMoreHeight);
    }
}
//当子view添加到父view上或者从父view上移除，调用此方法
- (void) willMoveToSuperview:(UIScrollView *)newSuperview{
    //移除父view观察者
    [self.superview removeObserver:self forKeyPath:LDCPOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:LDCPContentSizeKeyPath];
    //移除父view手势
    [self.panGestureRecognizer removeObserver:self forKeyPath:LDCPPanStateKeyPath context:nil];
    self.panGestureRecognizer = nil;
    //添加到父view上
    if(newSuperview){
        NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"父View 必须是ScrollView 或者其子类");
        //对新的父view进行观察
        [newSuperview addObserver:self forKeyPath:LDCPOffsetKeyPath
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        [newSuperview addObserver:self forKeyPath:LDCPContentSizeKeyPath
                          options:NSKeyValueObservingOptionNew context:nil];
        //对新父view添加手势
        self.panGestureRecognizer = newSuperview.panGestureRecognizer;
        [newSuperview.panGestureRecognizer addObserver:self forKeyPath:LDCPPanStateKeyPath
                                               options:NSKeyValueObservingOptionNew context:nil];
        self.observerView = newSuperview;

        self.observerView.ldcp_contentInsertBottom += self.bounds.size.height;
    }
    //从父view上移除
    else{
        self.observerView.ldcp_contentInsertBottom  -= self.bounds.size.height;
    }
    [super willMoveToSuperview:newSuperview];
}
/**
 *  @author ITxiansheng, 16-06-29 11:06:22
 *
 *  @brief 设置是否在父view上展示自己，通过调整父view的bottom来实现
 *
 *  @param hidden 是否展示的标志
 */
- (void) setHidden:(BOOL)hidden{
    if(self.hidden&&!hidden){
        self.observerView.ldcp_contentInsertBottom += self.bounds.size.height;
    }
    else if(!self.hidden&&hidden){
        self.observerView.ldcp_contentInsertBottom -= self.bounds.size.height;
    }
    [super setHidden:hidden];
}

- (void) layoutSubviews{
    [super layoutSubviews];
    //根据父view的contentsize竖直方向 是否高于 可见区域 来设定 是否显示自己
    [self setHidden:![self.observerView outOfBoundsVertical]];
}
@end
