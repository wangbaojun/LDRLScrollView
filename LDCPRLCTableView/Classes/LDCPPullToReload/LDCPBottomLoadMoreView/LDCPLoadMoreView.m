//
//  LDCPLoadMoreView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "LDCPLoadMoreView.h"
#import "Masonry.h"
#import "LDCPLineView.h"
const CGFloat LDCPCellMoreVMargin = 10;
const CGFloat LDCPActivityWidth   = 20;

@interface LDCPLoadMoreView ()

@property (nonatomic , strong)LDCPLineView *lineView;

@end

@implementation LDCPLoadMoreView

- (instancetype) init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubviews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - view private

- (void) initSubviews{
    [self addSubview:self.activityView];
    [self addSubview:self.labelMore];
    [self addSubview:self.lineView];
}

- (void) layoutViews{
    [self.labelMore mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self);
    }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.labelMore.mas_leading).offset(-LDCPCellMoreVMargin);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@1);
        make.bottom.equalTo(self).offset(-1);
    }];
}

#pragma mark - view getter

- (UIActivityIndicatorView *)activityView{
    if(!_activityView){
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, LDCPActivityWidth, LDCPActivityWidth)];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityView.hidesWhenStopped           = YES;
    }
    return _activityView;
}

- (LDCPLineView *)lineView{
    if(!_lineView){
        _lineView            = [[LDCPLineView alloc] init];
    }
    return _lineView;
}

- (UILabel *) labelMore{
    if(!_labelMore){
        _labelMore                      = [[UILabel alloc] init];
        _labelMore.font                 = [UIFont systemFontOfSize:16];
        _labelMore.textColor            = [UIColor colorWithRed:0x3f/255.0 green:0x3f/255.0 blue:0x3f/255.0 alpha:1.0];
        _labelMore.highlightedTextColor = [UIColor whiteColor];
    }
    return _labelMore;
}

@end

//====================================================================================

/**
 *  加载更多对应的ViewModel
 */

@interface LDCPLoadMoreViewModel ()

@property (nonatomic,strong,readwrite) NSString * stateText;
@property (nonatomic,assign,readwrite) BOOL activityLoading;

@end

@implementation LDCPLoadMoreViewModel

- (void) setLoadMoreState:(LDCPLoadMoreState)loadMoreState{
    _loadMoreState = loadMoreState;
    switch (loadMoreState) {
        case LDCPLoadMoreStateLoading:
            self.activityLoading = YES;
            self.stateText = @"努力加载中...";
            break;
        case LDCPLoadMoreStateIdle:
            self.activityLoading = NO;
            self.stateText = @"点击加载";
            break;
        case LDCPLoadMoreStateNoMore:
            self.activityLoading = NO;
            self.stateText = @"没有更多了";
            break;
        case LDCPLoadMoreStateError:
            self.activityLoading = NO;
            self.stateText = @"加载失败，请点击重试";
            break;
        default:
            break;
    }
}

@end
