//
//  UIPullToReloadHeaderView.m
//

/*
 
 Created by Water Lou | http://www.waterworld.com.hk
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "UIPullToReloadHeaderView.h"
#import "UIPullToReloadAnimationDelegate.h"
#import "UIPullToReloadDefaultAnimationView.h"
#import "UIPullToReloadPiggyBankAnimationView.h"
#import "UIPullToReloadMonkeyAnimationView.h"

#define TEXT_COLOR [UIColor colorWithRed:0x4e/255.0f green:0x42/255.0f blue:0x34/255.0f alpha:1.0f]
#define BORDER_COLOR [UIColor colorWithRed:0x79/255.0f green:0x67/255.0f blue:0x2e/255.0f alpha:1]
#define BACKGROUND_COLOR [UIColor clearColor];


static NSString *userDefaultLoadingHintText;
static LDCPPullReloadAnimationType userDefaultAnimationType;


@interface UIPullToReloadHeaderView()
@property (nonatomic, strong) UIView <UIPullToReloadAnimationDelegate> *animationView;
@property (nonatomic, strong) NSDate *startReloadDate;
@end

#pragma mark -

@implementation UIPullToReloadHeaderView

@synthesize lastUpdatedDate;
@dynamic status;
@synthesize showBorder;

+ (void)setDefaultLoadingHintText:(NSString *)loadingHintText
{
    userDefaultLoadingHintText = [loadingHintText copy];
}

+ (void)setDefaultLoadingAnimationType:(LDCPPullReloadAnimationType)animationType
{
    userDefaultAnimationType = animationType;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        showBorder = NO;
        
		self.backgroundColor = BACKGROUND_COLOR;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:backgroundImageView];
		
		lastUpdatedLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, frame.size.height - 30.0f, CGRectGetWidth(frame), 20.0f)];
		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		lastUpdatedLabel.textColor = TEXT_COLOR;
		lastUpdatedLabel.backgroundColor = self.backgroundColor;
		lastUpdatedLabel.opaque = YES;
		lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [backgroundImageView addSubview:lastUpdatedLabel];
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, CGRectGetWidth(frame), 20.0f)];
		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = TEXT_COLOR;
		statusLabel.backgroundColor = self.backgroundColor;
		statusLabel.opaque = YES;
		statusLabel.textAlignment = NSTextAlignmentCenter;
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		statusLabel.text = @"下拉刷新";
        [backgroundImageView addSubview:statusLabel];
        
        _animationType = -1;
        if (userDefaultAnimationType == 0) {
            self.animationType = LDCPPullReloadAnimationDefault; // 放在backgroundImageView之后
        } else {
            self.animationType = userDefaultAnimationType;
        }
        self.loadingHintText = userDefaultLoadingHintText;
        
        status = -1;
        [self setStatus:kPullStatusPullDownToReload animated:YES];
        
        self.startReloadDate = [NSDate date];
    }
    return self;
}

#pragma mark - accessor

- (void)setTextColor:(UIColor *)color
{
    lastUpdatedLabel.textColor = color;
    statusLabel.textColor = color;
}

- (void)setBackgroundImage:(UIImage *)image
{
    [backgroundImageView setImage:image];
}

- (void)setAnimationType:(LDCPPullReloadAnimationType)animationType
{
    if (_animationType == animationType) {
        return;
    }
    
    if (self.animationView) {
        [self.animationView removeFromSuperview];
        self.animationView = nil;
    }
    
    switch (animationType) {
        case LDCPPullReloadAnimationArrowWhite:
        {
            UIPullToReloadDefaultAnimationView *animationView = [[UIPullToReloadDefaultAnimationView alloc] init];
            self.animationView = animationView;
        }
            break;
        case LDCPPullReloadAnimationArrowBlue:
        {
            UIPullToReloadDefaultAnimationView *animationView = [[UIPullToReloadDefaultAnimationView alloc] init];
            [animationView setPullToReloadImage:[UIImage imageNamed:@"pulltorefresh_blue"]];
            [animationView setReloadActivityStyle:UIActivityIndicatorViewStyleWhite];
            self.animationView = animationView;
        }
            break;
        case LDCPPullReloadAnimationArrowGreen:
        {
            UIPullToReloadDefaultAnimationView *animationView = [[UIPullToReloadDefaultAnimationView alloc] init];
            [animationView setPullToReloadImage:[UIImage imageNamed:@"pulltorefresh_green"]];
            [animationView setReloadActivityStyle:UIActivityIndicatorViewStyleWhite];
            self.animationView = animationView;
        }
            break;
        case LDCPPullReloadAnimationPiggyBank:
        {
            UIPullToReloadPiggyBankAnimationView *animationView = [[UIPullToReloadPiggyBankAnimationView alloc] init];
            self.animationView = animationView;
        }
            break;
        case LDCPPullReloadAnimationMonkey:
        {
            UIPullToReloadMonkeyAnimationView *animationView = [[UIPullToReloadMonkeyAnimationView alloc] init];
            self.animationView = animationView;
        }
            break;
        default:
        {
            UIPullToReloadDefaultAnimationView *animationView = [[UIPullToReloadDefaultAnimationView alloc] init];
            self.animationView = animationView;
        }
            break;
    }
    
    CGSize animationViewSize = [[self.animationView class] size];
    self.animationView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f - 55.0f - animationViewSize.width / 2.0f, CGRectGetHeight(self.bounds) - 30);
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [backgroundImageView addSubview:self.animationView];
    
    status = -1;
    [self setStatus:kPullStatusPullDownToReload animated:YES];
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
    if (showBorder) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawPath(context,  kCGPathFillStroke);
        [BORDER_COLOR setStroke];
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - 1);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
        CGContextStrokePath(context);
    }
}

- (void)setLastUpdatedDate:(NSDate *)lastDate
{
	if (lastDate) {
        int seconds = (int)[[NSDate date] timeIntervalSinceDate:lastDate];
        if (seconds<60) {
            lastUpdatedLabel.text = @"最新刷新时间:刚刚";
        }else if(seconds < 3600){
            lastUpdatedLabel.text = [NSString stringWithFormat:@"最新刷新于:%d分钟前",seconds/60];
        }else if(seconds < 3600*24){
            lastUpdatedLabel.text = [NSString stringWithFormat:@"最新刷新于:%d小时前",seconds/3600];
        }else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM月dd日"];
            lastUpdatedLabel.text = [NSString stringWithFormat:@"最新刷新于:%@",[dateFormatter stringFromDate:lastDate]];
        }
	} else {
		lastUpdatedLabel.text = @"上次刷新时间:从未";
	}
}

- (void)setStatus:(UIPullToReloadStatus)newStatus animated:(BOOL)animated
{
	if (status == newStatus) return;
	switch (newStatus) {
		case kPullStatusReleaseToReload:
			statusLabel.text = @"释放立即刷新";
            [self.animationView startTriggerAnimation];
			break;
		case kPullStatusPullDownToReload:
            statusLabel.text = @"下拉刷新";
            [self.animationView stopLoadingAnimation];
            [self.animationView resignTriggerAnimation];
			break;
		case kPullStatusLoading:
            if (self.loadingHintText) {
                statusLabel.text = self.loadingHintText;
            } else {
                statusLabel.text = @"正在刷新";
            }
            [self.animationView startLoadingAnimation];
			break;
		default:
			break;
	}
	status = newStatus;
}

- (UIPullToReloadStatus)status
{
	return status;
}

#pragma mark Loading, and finish loading

/* begin loading, set edge offset so that the loading will be shown */
- (void)startReloading:(UITableView *)tableView animated:(BOOL)animated
{
    self.startReloadDate = [NSDate date];
    
    [self setStatus:kPullStatusLoading animated:animated];
    CGPoint contentOffset = tableView.contentOffset;
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            tableView.contentInset = UIEdgeInsetsMake(kPullDownToReloadToggleHeight - 5, 0.0f, 0.0f, 0.0f);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                tableView.contentOffset = contentOffset;
            }
        }];
    } else {
        tableView.contentInset = UIEdgeInsetsMake(kPullDownToReloadToggleHeight - 5, 0.0f, 0.0f, 0.0f);
    }
}

- (void)finishReloading:(UITableView *)tableView animated:(BOOL)animated
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [self.animationView minAnimationDuration] - [nowDate timeIntervalSinceDate:self.startReloadDate];
    if (time > 0 && animated) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf setStatus:kPullStatusPullDownToReload animated:animated];
        });
    } else {
        [self setStatus:kPullStatusPullDownToReload animated:animated];
    }
    
    if (animated) {
        [UIView animateWithDuration:0.2f
                              delay:MAX(0, time)
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             tableView.contentInset = UIEdgeInsetsZero;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        tableView.contentInset = UIEdgeInsetsZero;
    }
}

/* begin loading, set edge offset so that the loading will be shown */
- (void)startReloadingScrollView:(UIScrollView *)scrollView animated:(BOOL)animated
{
    self.startReloadDate = [NSDate date];
    
    [self setStatus:kPullStatusLoading animated:animated];
    CGPoint contentOffset = scrollView.contentOffset;
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(kPullDownToReloadToggleHeight - 5, 0.0f, 0.0f, 0.0f);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                scrollView.contentOffset = contentOffset;
            }
        }];
    } else {
        scrollView.contentInset = UIEdgeInsetsMake(kPullDownToReloadToggleHeight - 5, 0.0f, 0.0f, 0.0f);
    }
}

- (void)finishReloadingScrollView:(UIScrollView *)scrollView animated:(BOOL)animated
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [self.animationView minAnimationDuration] - [nowDate timeIntervalSinceDate:self.startReloadDate];
    if (time > 0) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf setStatus:kPullStatusPullDownToReload animated:animated];
        });
    } else {
        [self setStatus:kPullStatusPullDownToReload animated:animated];
    }
    
    if (animated) {
        [UIView animateWithDuration:0.2f
                              delay:MAX(0, time)
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             scrollView.contentInset = UIEdgeInsetsZero;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        scrollView.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark -

- (void)setDragOffset:(CGPoint)point
{
    if ([self.animationView respondsToSelector:@selector(draggingOffset:)]) {
        [self.animationView draggingOffset:point];
    }
}

@end
