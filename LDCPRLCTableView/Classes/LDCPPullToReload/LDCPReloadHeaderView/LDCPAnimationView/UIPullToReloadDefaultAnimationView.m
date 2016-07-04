//
//  UIPullToReloadDefaultAnimationView.m
//  Pods
//
//  Created by SongLi on 1/5/15.
//
//

#import "UIPullToReloadDefaultAnimationView.h"

@interface UIPullToReloadDefaultAnimationView ()
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) BOOL isLoadingAnimating;
@end


@implementation UIPullToReloadDefaultAnimationView

+ (CGSize)size
{
    return CGSizeMake(23, 36);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGSize size = [[self class] size];
    
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), size.width, size.height)];
    if (self) {
        self.arrowImage = [[UIImageView alloc] initWithFrame:self.bounds];
        self.arrowImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        self.arrowImage.image = [UIImage imageNamed:@"pulltorefresh"];
        [self addSubview:self.arrowImage];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        self.activityView.center = CGPointMake(size.width / 2.0f, size.height / 2.0f);
        self.activityView.hidesWhenStopped = YES;
        [self addSubview:self.activityView];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPullToReloadImage:(UIImage *)image
{
    self.arrowImage.image = image;
}

- (void)setReloadActivityStyle:(UIActivityIndicatorViewStyle)style
{
    if (self.activityView.activityIndicatorViewStyle == style) {
        return;
    }
    
    if (self.activityView) {
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    self.activityView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);
    self.activityView.hidesWhenStopped = YES;
    [self addSubview:self.activityView];
}

- (NSTimeInterval)minAnimationDuration
{
    return 0.2f;
}


#pragma mark Animation Actions

- (void)startTriggerAnimation
{
    if (self.isLoadingAnimating) {
        return;
    }
    
    BOOL previousFlip = !CGAffineTransformIsIdentity(self.arrowImage.transform);
    if (previousFlip == NO) {
        return;
    }
    
    [UIView animateWithDuration:0.18f animations:^{
        self.arrowImage.transform = CGAffineTransformIdentity;
    }];
}

- (void)resignTriggerAnimation
{
    if (self.isLoadingAnimating) {
        return;
    }
    
    BOOL previousFlip = !CGAffineTransformIsIdentity(self.arrowImage.transform);
    if (previousFlip == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.18f animations:^{
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)startLoadingAnimation
{
    if (self.isLoadingAnimating) {
        return;
    }
    self.isLoadingAnimating = YES;
    
    if (!self.arrowImage.hidden) {
        [self.activityView startAnimating];
        self.arrowImage.hidden = YES;
    }
}

- (void)stopLoadingAnimation
{
    self.isLoadingAnimating = NO;
    
    if (self.arrowImage.hidden) {
        [self.activityView stopAnimating];
        self.arrowImage.hidden = NO;
    }
}


#pragma mark Private Method



@end
