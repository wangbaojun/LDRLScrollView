//
//  UIPullToReloadHeaderView.h
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

#import <UIKit/UIKit.h>

typedef enum {
	kPullStatusReleaseToReload = 0,
	kPullStatusPullDownToReload	= 1,
	kPullStatusLoading = 2
} UIPullToReloadStatus;

typedef NS_ENUM(NSInteger, LDCPPullReloadAnimationType)
{
    LDCPPullReloadAnimationArrowWhite = 1,
    LDCPPullReloadAnimationArrowBlue  = 2,
    LDCPPullReloadAnimationArrowGreen = 3,
    LDCPPullReloadAnimationPiggyBank  = 4,
    LDCPPullReloadAnimationMonkey     = 5,
    
    LDCPPullReloadAnimationDefault = LDCPPullReloadAnimationArrowWhite
};

#define kPullDownToReloadToggleHeight 65.0f

@interface UIPullToReloadHeaderView : UIView
{
@private
	UIPullToReloadStatus status;
	
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	NSDate *lastUpdatedDate;
    UIImageView *backgroundImageView;
}

@property (nonatomic) NSDate *lastUpdatedDate;
@property (nonatomic, readonly) UIPullToReloadStatus status;
@property (nonatomic) BOOL showBorder;
/** 动画样式 */
@property (nonatomic, assign) LDCPPullReloadAnimationType animationType;
/** 加载中提示语 */
@property (nonatomic, strong) NSString *loadingHintText;

/**
 *  设置所有UIPullToReloadHeaderView默认加载中提示语，对于特殊的实例
 *  调用instance setLoadingHintText:方法进行设置
 *  @warning 不指定任何提示语时加载中显示"正在刷新"
 */
+ (void)setDefaultLoadingHintText:(NSString *)loadingHintText;

/**
 *  设置所有UIPullToReloadHeaderView默认动画，对于特殊的实例调用
 *  instance setAnimationType:方法进行设置
 *  @warning 不指定任何动画时默认白色箭头动画
 */
+ (void)setDefaultLoadingAnimationType:(LDCPPullReloadAnimationType)animationType;

- (void)setStatus:(UIPullToReloadStatus)status animated:(BOOL)animated;
- (void)setBackgroundImage:(UIImage*)image;
- (void)setTextColor:(UIColor*)color;

- (void)startReloading:(UITableView *)tableView animated:(BOOL)animated;	// call when start loading
- (void)finishReloading:(UITableView *)tableView animated:(BOOL)animated;	// call when finish loading
- (void)startReloadingScrollView:(UIScrollView *)scrollView animated:(BOOL)animated;
- (void)finishReloadingScrollView:(UIScrollView *)scrollView animated:(BOOL)animated;

- (void)setDragOffset:(CGPoint)point;

@end
