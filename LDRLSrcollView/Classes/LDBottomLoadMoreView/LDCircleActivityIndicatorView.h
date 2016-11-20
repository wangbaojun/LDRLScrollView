//
//  LDCPCircleActivityIndicatorView.h
//  Pods
//
//  Created by ITxiansheng on 16/7/20.
//
//

#import <UIKit/UIKit.h>

@interface LDLoadMoreImageView : UIImageView

@end

@interface LDCircleActivityIndicatorView : LDLoadMoreImageView

@property (nonatomic, assign, getter = isAnimating) BOOL isAnimating; //动画是否在进行
@property (nonatomic, assign) BOOL hidesWhenStopped; //停止动画的时候是否隐藏
//开始动画
- (void)startAnimating;
//停止动画
- (void)stopAnimating;

- (UIImage *)indicatorImage;

@end
