 //
//  LDCPRefreshView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDCPRefreshView.h"
#import "Masonry.h"
#import "UIPullToReloadDefaultAnimationView.h"
#import "UIPullToReloadPiggyBankAnimationView.h"
#import "UIPullToReloadMonkeyAnimationView.h"

#define TEXT_COLOR [UIColor colorWithRed:0x4e/255.0f green:0x42/255.0f blue:0x34/255.0f alpha:1.0f]
#define BORDER_COLOR [UIColor colorWithRed:0x79/255.0f green:0x67/255.0f blue:0x2e/255.0f alpha:1]
#define BACKGROUND_COLOR [UIColor clearColor];


@implementation LDCPRefreshView

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

- (void)initSubviews{
    self.backgroundColor = BACKGROUND_COLOR;
    [self.backgroundImageView addSubview:self.lastUpdatedLabel];
    [self.backgroundImageView  addSubview:self.statusLabel];
    [self.backgroundImageView addSubview:self.animationView];
    [self addSubview:self.backgroundImageView];
}

- (void)layoutViews{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_bottom).offset(-48);
    }];
    [self.lastUpdatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_bottom).offset(-30);
    }];

    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@35);
        make.height.equalTo(@50);
        make.centerX.equalTo(self).offset(-70);
        make.centerY.equalTo(self.mas_bottom).offset(-30);
    }];
}

#pragma mark -getter

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}

- (UILabel *)lastUpdatedLabel{
    if (!_lastUpdatedLabel) {
        _lastUpdatedLabel = [UILabel new];
        _lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
        _lastUpdatedLabel.textColor = TEXT_COLOR;
        _lastUpdatedLabel.backgroundColor = self.backgroundColor;
        _lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lastUpdatedLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLabel.textColor = TEXT_COLOR;
        _statusLabel.backgroundColor = self.backgroundColor;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UIView *)animationView{
    if (!_animationView) {
        _animationView = [[UIPullToReloadPiggyBankAnimationView alloc] init];
    }
    return _animationView;
}

@end

//================================================================================

@implementation LDCPRefreshViewModel

- (void)setReloadStatus:(UIPullToReloadStatus)newStatus
{
    if (self.reloadStatus == newStatus) return;
    switch (newStatus) {
        case kPullStatusReleaseToReload:
            self.stateText = @"释放立即刷新";
            break;
        case kPullStatusLoading:
            self.stateText = @"正在刷新";
            break;
        case kPullStatusPullDownToReload:
            self.stateText = @"下拉刷新";
            //记录刷新成功的时间
            self.lastCompletedDate = [NSDate date];
            break;
        default:
            break;
    }
    _reloadStatus = newStatus;
}

- (void)setLastUpdatedDate:(NSDate *)lastDate
{
    if (lastDate) {
        int seconds = (int)[[NSDate date] timeIntervalSinceDate:lastDate];
        if (seconds<60) {
            self.lastUpdatedDateText = @"最新刷新时间:刚刚";
        }else if(seconds < 3600){
            self.lastUpdatedDateText = [NSString stringWithFormat:@"最新刷新于:%d分钟前",seconds/60];
        }else if(seconds < 3600*24){
            self.lastUpdatedDateText = [NSString stringWithFormat:@"最新刷新于:%d小时前",seconds/3600];
        }else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM月dd日"];
            self.lastUpdatedDateText = [NSString stringWithFormat:@"最新刷新于:%@",[dateFormatter stringFromDate:lastDate]];
        }
    } else {
        self.lastUpdatedDateText = @"上次刷新时间:从未";
    }
}


@end