 //
//  LDCPRefreshView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDRefreshView.h"
#import "UIPullToReloadPiggyBankAnimationView.h"

@interface LDRefreshView ()

@property (nonatomic, strong) UIView * containerView;

@end
@implementation LDRefreshView

- (instancetype) init {
    
    return  [self initWithFrame:CGRectZero];
}

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        [self initSubviews];
        [self layoutViews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.statusLabel];
    [self.containerView addSubview:self.animationView];
    [self.backgroundImageView addSubview:self.containerView];
    [self addSubview:self.backgroundImageView];
}

- (void)layoutViews {
    
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_backgroundImageView,_containerView,_statusLabel,_animationView);
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:nil views:viewDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:nil views:viewDic]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[_animationView(35)]-10-[_statusLabel]|" options:0 metrics:nil views:viewDic]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_animationView(50)]|" options:0 metrics:nil views:viewDic]];
    
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10.0]];
    
}

#pragma mark -getter

- (UIImageView *)backgroundImageView {
    
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backgroundImageView;
}

- (UILabel *)statusLabel {
    
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLabel.textColor = [UIColor colorWithRed:0x4e/255.0f green:0x42/255.0f blue:0x34/255.0f alpha:1.0f];
        _statusLabel.backgroundColor = self.backgroundColor;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _statusLabel;
}

- (UIView *)animationView {
    
    if (!_animationView) {
        _animationView = [[UIPullToReloadPiggyBankAnimationView alloc] init];
        _animationView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _animationView;
}

- (UIView *)containerView {
    
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

@end