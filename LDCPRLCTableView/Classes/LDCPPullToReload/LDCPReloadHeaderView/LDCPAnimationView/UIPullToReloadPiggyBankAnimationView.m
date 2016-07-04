//
//  UIPullToReloadPiggyBankAnimationView.m
//  LDCPPullToReload
//
//  Created by SongLi on 1/4/15.
//  Copyright (c) 2015 SongLi. All rights reserved.
//

#import "UIPullToReloadPiggyBankAnimationView.h"

@interface UIPullToReloadPiggyBankAnimationView ()
@property (nonatomic, strong) UIImageView *shadowView;
@property (nonatomic, strong) UIImageView *pigView;
@property (nonatomic, strong) UIView *coinView;
@property (nonatomic, strong) NSArray *coinArray;
@property (nonatomic, assign) BOOL isLoadingAnimating;
@end


@implementation UIPullToReloadPiggyBankAnimationView

+ (CGSize)size
{
    return CGSizeMake(35, 50);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGSize size = [[self class] size];
    
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), size.width, size.height)];
    if (self) {
        UIImage *shadowImage = [UIImage imageNamed:@"shadow"];
        CGFloat shadowHeight = shadowImage.size.height / shadowImage.size.width * size.width;
        self.shadowView = [[UIImageView alloc] initWithImage:shadowImage];
        self.shadowView.frame = CGRectMake(0, size.height - shadowHeight, size.width, shadowHeight);
        [self addSubview:self.shadowView];
        
        UIImage *pigImage = [UIImage imageNamed:@"pig"];
        CGFloat pigHeight = pigImage.size.height / pigImage.size.width * size.width;
        self.pigView = [[UIImageView alloc] initWithImage:pigImage];
        self.pigView.frame = CGRectMake(0, size.height - shadowHeight - pigHeight, size.width, pigHeight);
        [self addSubview:self.pigView];
        
        self.coinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self insertSubview:self.coinView belowSubview:self.pigView];
        
        self.coinArray = [self initialCoins];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (NSTimeInterval)minAnimationDuration
{
    return 0.0f;
}


#pragma mark Animation Actions

- (void)startTriggerAnimation
{
    if (self.isLoadingAnimating) {
        return;
    }
    
    CGFloat maxOffset = CGRectGetHeight(self.shadowView.bounds) / 2.0f;
    CGFloat maxScale = 0.2f;
    NSTimeInterval duration = 0.2f;
    
    // 上下弹跳动画
    CGFloat originY = CGRectGetMidY(self.pigView.frame);
    CAKeyframeAnimation *pigTriggerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    [pigTriggerAnimation setDuration:duration];
    [pigTriggerAnimation setRemovedOnCompletion:YES];
    [pigTriggerAnimation setFillMode:kCAFillModeBoth];
    [pigTriggerAnimation setCalculationMode:kCAAnimationCubicPaced];
    [pigTriggerAnimation setValues:@[@(originY), @(originY + maxOffset),
                               @(originY), @(originY - maxOffset * 0.80f),
                               @(originY), @(originY + maxOffset * 0.45f),
                               @(originY), @(originY - maxOffset * 0.30f),
                               @(originY)]];
    [self.pigView.layer addAnimation:pigTriggerAnimation forKey:@"PigTriggerAnimation"];
    
    // 缩放动画
    CAKeyframeAnimation *shadowTriggerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [shadowTriggerAnimation setDuration:duration];
    [shadowTriggerAnimation setRemovedOnCompletion:YES];
    [shadowTriggerAnimation setFillMode:kCAFillModeBoth];
    [shadowTriggerAnimation setCalculationMode:kCAAnimationCubicPaced];
    [shadowTriggerAnimation setValues:@[@(1.0f), @(1.0f + maxScale),
                                @(1.0f), @(1.0f - maxScale * 0.80f),
                                @(1.0f), @(1.0f + maxScale * 0.45f),
                                @(1.0f), @(1.0f - maxScale * 0.30f),
                                @(1.0f)]];
    [self.shadowView.layer addAnimation:shadowTriggerAnimation forKey:@"ShadowTriggerAnimation"];
}

- (void)resignTriggerAnimation
{
    return;
}

- (void)startLoadingAnimation
{
    if (self.isLoadingAnimating) {
        return;
    }
    self.isLoadingAnimating = YES;
    
    CGFloat minDelay = 0.11f; // 上一个金币开始掉落到下一个金币开始掉落的最小时间差
    CGFloat maxDelay = 0.16f; // 上一个金币开始掉落到下一个金币开始掉落的最大时间差
    CGFloat duration = 0.23f; // 金币下落过程时间
    CGFloat totalDelay = maxDelay * self.coinArray.count; // 每一轮最后一个金币的最大延时
    CGPoint targetPoint = CGPointMake(4.0f / 7.0f * CGRectGetWidth(self.bounds), 23.0f / 45.0f * CGRectGetHeight(self.bounds)); // 金币掉落最终位置
    targetPoint = [self.coinView convertPoint:targetPoint fromView:self];
    CAMediaTimingFunction *timingFunc = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    NSArray *randomArray = [self.coinArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *a = @(arc4random() % 1000);
        NSNumber *b = @(arc4random() % 1000);
        return [a compare:b];
    }];
    
    NSTimeInterval timeOffset = 0.0f;
    for (UIView *coin in randomArray) {
        NSTimeInterval delay = timeOffset + arc4random() % (int)((maxDelay - minDelay) * 10000) / 10000.0f + minDelay; // 随机掉落时延为 minDelay~maxDelay
        delay = (timeOffset < 0.00001) ? 0.05f : delay; // 第1个金币不至于太迟掉落
        NSTimeInterval overTime = MAX(0, delay + duration - totalDelay);
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnimation setDuration:duration];
        [positionAnimation setBeginTime:delay - overTime];
        [positionAnimation setAutoreverses:NO];
        [positionAnimation setRemovedOnCompletion:NO];
        [positionAnimation setFillMode:kCAFillModeBackwards];
        [positionAnimation setTimingFunction:timingFunc];
        [positionAnimation setFromValue:[NSValue valueWithCGPoint:coin.center]];
        [positionAnimation setToValue:[NSValue valueWithCGPoint:targetPoint]];
        
        CAAnimationGroup *coinLoadingAnimationGroup = [CAAnimationGroup animation];
        [coinLoadingAnimationGroup setDuration:totalDelay];
        [coinLoadingAnimationGroup setBeginTime:CACurrentMediaTime() + overTime];
        [coinLoadingAnimationGroup setRepeatCount:MAXFLOAT];
        [coinLoadingAnimationGroup setAutoreverses:NO];
        [coinLoadingAnimationGroup setRemovedOnCompletion:NO];
        [coinLoadingAnimationGroup setFillMode:kCAFillModeBackwards];
        [coinLoadingAnimationGroup setAnimations:@[positionAnimation]];
        [coin.layer addAnimation:coinLoadingAnimationGroup forKey:@"CoinLoadingAnimation"];
        
        [self.coinView addSubview:coin];
        
        timeOffset += maxDelay;
    }
    
    CGFloat maxOffset = 2.0f;
    CGFloat maxScale = 0.1f;
    duration = 0.35f;
    
    CATransform3D transformUp = CATransform3DMakeTranslation(0, - maxOffset, 0);
    CATransform3D transform1 = CATransform3DRotate(transformUp, M_PI * 10 / 180, 0, 0, 1);
    CATransform3D transform2 = transformUp;
    CATransform3D transform3 = CATransform3DRotate(transformUp, - M_PI * 12 / 180, 0, 0, 1);
    
    CAKeyframeAnimation *pigLoadingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [pigLoadingAnimation setDuration:duration];
    [pigLoadingAnimation setRepeatCount:MAXFLOAT];
    [pigLoadingAnimation setRemovedOnCompletion:NO];
    [pigLoadingAnimation setFillMode:kCAFillModeBoth];
    [pigLoadingAnimation setValues:@[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                     [NSValue valueWithCATransform3D:transform1],
                                     [NSValue valueWithCATransform3D:transform2],
                                     [NSValue valueWithCATransform3D:transform3],
                                     [NSValue valueWithCATransform3D:CATransform3DIdentity]
                                     ]];
    [pigLoadingAnimation setKeyTimes:@[@(0.00f), @(0.22f), @(0.50f), @(0.78f), @(1.00f)]];
    [self.pigView.layer addAnimation:pigLoadingAnimation forKey:@"PigLoadingAnimation"];
    
    CAKeyframeAnimation *shadowLoadingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [shadowLoadingAnimation setDuration:duration];
    [shadowLoadingAnimation setRepeatCount:MAXFLOAT];
    [shadowLoadingAnimation setRemovedOnCompletion:NO];
    [shadowLoadingAnimation setFillMode:kCAFillModeBoth];
    [shadowLoadingAnimation setValues:@[@(1.0f),
                                        @(1.0f - maxScale),
                                        @(1.0f - maxScale),
                                        @(1.0f - maxScale),
                                        @(1.0f)
                                     ]];
    [shadowLoadingAnimation setKeyTimes:@[@(0.00f), @(0.22f), @(0.50f), @(0.78f), @(1.00f)]];
    [self.shadowView.layer addAnimation:shadowLoadingAnimation forKey:@"ShadowLoadingAnimation"];
}

- (void)stopLoadingAnimation
{
    self.isLoadingAnimating = NO;
    
    for (UIView *coin in self.coinArray) {
        [coin.layer removeAnimationForKey:@"CoinLoadingAnimation"];
        [coin removeFromSuperview];
    }
    [self.pigView.layer removeAnimationForKey:@"PigLoadingAnimation"];
    [self.shadowView.layer removeAnimationForKey:@"ShadowLoadingAnimation"];
}


#pragma mark Private Method

- (NSArray *)initialCoins
{
    NSInteger coinColums = 3; // 列数
    NSInteger coinCount = 5; // 每列个数
    CGFloat leftInset = 13.0f; // 左留空
    CGFloat rightInset = 5.0f; // 右留空
    CGFloat columWidth = (CGRectGetWidth(self.coinView.bounds) - leftInset - rightInset) / coinColums;
    CGFloat maxOffset = columWidth / 4.0f; // 列左右偏移量
    CGSize coinSize = CGSizeMake(8.5f, 8.5f);
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < coinCount; i++) {
        for (int j = 0; j < coinColums; j++) {
            CGFloat offset = arc4random() % (int)(maxOffset * 200) / 100.0f - maxOffset; // -maxOffset ~ +maxOffset
            UIImageView *coin = [[UIImageView alloc] initWithImage:[self coinImage]];
            CGFloat x = leftInset + j * columWidth + (columWidth - coinSize.width) / 2.0f + offset;
            x = MAX(leftInset, x);
            x = MIN(leftInset + columWidth * coinColums - coinSize.width, x);
            CGFloat y = -coinSize.height;
            coin.frame = CGRectMake(x, y, coinSize.width, coinSize.height);
            [array addObject:coin];
        }
    }
    return [array copy];
}

- (UIImage *)coinImage
{
    return [UIImage imageNamed:@"coin"];
}

@end
