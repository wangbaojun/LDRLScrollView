//
//  LDCPLoadMoreView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import <UIKit/UIKit.h>
#import "LDCircleActivityIndicatorView.h"

@interface LDLoadMoreView : UIView

@property (nonatomic,strong)  UILabel                 *labelMore;// 加载状态Label
@property (nonatomic, strong) LDLoadMoreImageView	         *smileImageview; // 笑脸
@property (nonatomic, strong) LDLoadMoreImageView	         *errorImageView; // 叉号
@property (nonatomic, strong) LDCircleActivityIndicatorView *indicatorView;  // 加载


- (UIImage *)smileImage;
- (UIImage *)errorImage;
- (UIImage *)indicatorImage;

@end

