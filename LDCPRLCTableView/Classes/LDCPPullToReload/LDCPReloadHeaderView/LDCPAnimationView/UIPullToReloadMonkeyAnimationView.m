//
//  UIPullToReloadPiggyBankAnimationView.m
//  LDCPPullToReload
//
//  Created by SongLi on 1/4/15.
//  Copyright (c) 2015 SongLi. All rights reserved.
//

#import "UIPullToReloadMonkeyAnimationView.h"

@interface UIPullToReloadMonkeyAnimationView ()
@property (nonatomic, strong) UIImageView *monkeyView;
@property (nonatomic, strong) NSArray *monkeys;
@property (nonatomic, assign) BOOL isLoadingAnimating;
@end


@implementation UIPullToReloadMonkeyAnimationView

+ (CGSize)size
{
    return CGSizeMake(62.5, 35);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGSize size = [[self class] size];
    
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), size.width, size.height)];
    if (self) {
        UIImage *shadowImage = [UIImage imageNamed:@"monkey_0"];
        self.monkeyView = [[UIImageView alloc] initWithImage:shadowImage];
        self.monkeyView.contentMode = UIViewContentModeCenter;
        self.monkeyView.frame = CGRectMake(0, 0, size.width, size.height);
        [self addSubview:self.monkeyView];
        
        self.monkeys = [self initialMonkeys];
        
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
    return;
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
    
    self.monkeyView.animationImages = self.monkeys;
    [self.monkeyView startAnimating];
}

- (void)stopLoadingAnimation
{
    self.isLoadingAnimating = NO;
    
    [self.monkeyView stopAnimating];
    self.monkeyView.animationImages = nil;
}

- (void)draggingOffset:(CGPoint)point
{
    if (point.y == 0) {
        return;
    }
    
    CGFloat scale = MIN(1, fabs(point.y/50));
    self.monkeyView.transform = CGAffineTransformMakeScale(scale, scale);
}

#pragma mark Private Method

- (NSArray *)initialMonkeys
{
    NSMutableArray *ma = [NSMutableArray array];
    
    for (int i = 1; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"monkey_%d", i]];
        [ma addObject:image];
    }
    
    return [NSArray arrayWithArray:ma];
}

@end
