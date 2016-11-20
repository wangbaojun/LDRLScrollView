//
//  LDCPCircleActivityIndicatorView.m
//  Pods
//
//  Created by ITxiansheng on 16/7/20.
//
//

#import "LDCircleActivityIndicatorView.h"

@implementation LDLoadMoreImageView

- (UIEdgeInsets)alignmentRectInsets{
    
    return UIEdgeInsetsMake(0, 0, 0, -8);
}

- (CGSize)intrinsicContentSize
{
    if (self.image)
    {
        return [super intrinsicContentSize];
    }
    
    return CGSizeZero;
}

@end

@implementation LDCircleActivityIndicatorView

#pragma mark - Init Methods

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (void)sharedSetup{
    
    _hidesWhenStopped = YES;
    [self setImage:[self indicatorImage]];
}

#pragma mark - Public Methods

- (void)setAnimating:(BOOL)animating {
    
    _isAnimating = animating;
    if (_isAnimating) {
        [self startAnimating];
    }
    else {
        [self stopAnimating];
    }
}

- (BOOL)isAnimating {
    
    CAAnimation *spinAnimation = [self.layer animationForKey:@"spinAnimation"];
    return (_isAnimating || spinAnimation);
}

- (void)startAnimating {
    
    _isAnimating = YES;
    [self spin];
    [self setHidden:NO];
}

- (void)stopAnimating {
    
    _isAnimating = NO;
    [self.layer removeAnimationForKey:@"spinAnimation"];
    if (_hidesWhenStopped) {
        [self setHidden:YES];
    }
}

- (void)spin {
    
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:2 * M_PI];
    spinAnimation.duration = 1.0f;
    spinAnimation.repeatCount = INT_MAX;
    [self.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

- (UIImage *)indicatorImage
{
    return [UIImage imageNamed:@"loading"];
}

@end
