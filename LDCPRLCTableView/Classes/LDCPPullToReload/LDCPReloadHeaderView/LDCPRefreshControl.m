//
//  LDCPRefreshControl.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDCPRefreshControl.h"
#import "UIScrollView+ContentExtension.h"

//KVO监测的属性
static NSString * const LDCPContentOffsetKeyPath      = @"contentOffset";
static NSString * const LDCPContentSizeKeyPath = @"contentSize";
//手势
static NSString * const LDCPPanStateKeyPath    = @"state";

static const CGFloat LDCPRefreshHeight   = 60.0f;

@interface LDCPRefreshControl ()

@property (nonatomic,strong) UIPanGestureRecognizer * panGestureRecognizer;


@end

@implementation LDCPRefreshControl

//只给出固定高度60，位置和宽度根据父view的观察值去计算
- (instancetype) init{
    return [self initWithFrame:CGRectMake(0, 0, 0, LDCPRefreshHeight)];
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        [self setRefreshStatus:kPullStatusReleaseToReload];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.isHidden||self.alpha < 0.01){
        return;
    }
    
    if(self.refreshStatus != kPullStatusLoading){
        if([keyPath isEqualToString:LDCPPanStateKeyPath]){
            UIPanGestureRecognizer * panGestureRecognizer = object;
            if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
                if(-self.observerView.contentOffset.y > self.bounds.size.height){
                    [self setRefreshStatus:kPullStatusLoading];
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
        }
        else if([keyPath isEqualToString:LDCPContentOffsetKeyPath]){
            CGFloat offset = [[change objectForKey:@"new"]    CGPointValue].y;
            if(- offset > self.bounds.size.height&&self.refreshStatus != kPullStatusReleaseToReload){
                [self setRefreshStatus:kPullStatusReleaseToReload];
            }
            else if(-offset < self.bounds.size.height){
                if(self.refreshStatus != kPullStatusPullDownToReload){
                    self.refreshStatus = kPullStatusPullDownToReload;
                }
            }
            //只要下拉即将漏出header，则调用该方法
            if (offset<0) {
                [self setIsPullDown:YES];
            }
        }
    }
    //设置自己的宽度与父view的contentSize.width相等
    if([keyPath isEqualToString:LDCPContentSizeKeyPath]){
        CGSize contentSize = [[change objectForKey:@"new"] CGSizeValue];
        CGRect rect = self.frame;
        rect.size.width = contentSize.width;
        self.frame = rect;
    }

}

- (void) willMoveToSuperview:(UIScrollView *)newSuperview{
    
    [self.superview removeObserver:self forKeyPath:LDCPContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:LDCPContentSizeKeyPath];
    [self.panGestureRecognizer removeObserver:self forKeyPath:LDCPPanStateKeyPath context:nil];
    self.panGestureRecognizer = nil;
    
    if(newSuperview){
        NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"父View 必须是ScrollView 或者其子类");
        
        [newSuperview addObserver:self forKeyPath:LDCPContentOffsetKeyPath
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        [newSuperview addObserver:self forKeyPath:LDCPContentSizeKeyPath
                          options:NSKeyValueObservingOptionNew context:nil];
        
        [newSuperview.panGestureRecognizer addObserver:self forKeyPath:LDCPPanStateKeyPath
                                               options:NSKeyValueObservingOptionNew context:nil];
        self.panGestureRecognizer = newSuperview.panGestureRecognizer;
        self.observerView = newSuperview;
        
        self.frame = CGRectMake(0, -self.bounds.size.height,self.bounds.size.width, LDCPRefreshHeight);
    }
    [super willMoveToSuperview:newSuperview];
}

- (void) setRefreshStatus:(UIPullToReloadStatus)refreshStatus{
    _refreshStatus = refreshStatus;
    if(refreshStatus == kPullStatusLoading){
        self.observerView.ldcp_contentInsertTop = self.bounds.size.height;
    }
    else{
        self.observerView.ldcp_contentInsertTop = 0;
    }
}

@end
