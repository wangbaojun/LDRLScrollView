//
//  LDCPLoadMoreView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "LDLoadMoreView.h"

@interface LDLoadMoreView ()

@property (nonatomic , strong)UIView *containerView;

@end

@implementation LDLoadMoreView

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
    
    self.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf4/255.0 alpha:1.0];
    self.clipsToBounds = YES;
    [self.containerView addSubview:self.smileImageview];
    [self.containerView addSubview:self.errorImageView];
    [self.containerView addSubview:self.indicatorView];
    [self.containerView addSubview:self.labelMore];
    [self addSubview:self.containerView];
}

- (void) layoutViews{
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_containerView,_smileImageview,_errorImageView,_indicatorView,_labelMore);
    
    //containerView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerView]|" options:0 metrics:nil views:viewDic]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    //smileImageview
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_smileImageview][_labelMore]|" options:0 metrics:nil views:viewDic]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.smileImageview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    //errorImageView
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_errorImageView][_labelMore]|" options:0 metrics:nil views:viewDic]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    //indicatorView
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_indicatorView][_labelMore]|" options:0 metrics:nil views:viewDic]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    //labelMore
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelMore attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
}

#pragma mark - view getter

- (LDCircleActivityIndicatorView *)indicatorView
{
    if(!_indicatorView){
        _indicatorView = [[LDCircleActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _indicatorView.hidden = YES;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicatorView;
}

- (UILabel *)labelMore
{
    if(!_labelMore) {
        _labelMore                      = [[UILabel alloc] init];
        _labelMore.font                 = [UIFont systemFontOfSize:12];
        _labelMore.textColor            = [UIColor colorWithRed:0x8e/255.0 green:0x8e/255.0 blue:0x8e/255.0 alpha:1.0];
        _labelMore.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labelMore;
}

- (LDLoadMoreImageView *)smileImageview
{
    if (!_smileImageview) {
        _smileImageview = [[LDLoadMoreImageView alloc]initWithImage:[self smileImage]];
        _smileImageview.contentMode = UIViewContentModeScaleAspectFit;
        _smileImageview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _smileImageview;
}

- (LDLoadMoreImageView *)errorImageView
{
    if (!_errorImageView) {
        _errorImageView = [[LDLoadMoreImageView alloc]initWithImage:[self errorImage]];
        _errorImageView.contentMode = UIViewContentModeScaleAspectFit;
        _errorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _errorImageView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

#pragma mark - public method
- (UIImage *)smileImage
{
    return [UIImage imageNamed:@"smile_Face"];
}

- (UIImage *)errorImage
{
    return [UIImage imageNamed:@"sad_Face"];
}

- (UIImage *)indicatorImage
{
    return [self.indicatorView indicatorImage];
}

@end
