//
//  UIScrollView+ContentExtension.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ContentExtension)
@property (nonatomic,assign) CGFloat ldcp_contentInsertBottom;
@property (nonatomic,assign) CGFloat ldcp_contentInsertTop;
@property (nonatomic,assign) CGFloat ldcp_contentOffsetTop;

/**
 *  @author ITxiansheng, 16-06-29 13:06:05
 *
 *  @brief 是否超出用户可见范围
 *
 *  @return YES or NO
 */
- (BOOL)outOfBoundsVertical;

@end
