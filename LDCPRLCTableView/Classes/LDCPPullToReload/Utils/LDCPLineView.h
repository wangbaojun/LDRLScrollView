//
//  LDCPLineView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import <UIKit/UIKit.h>

@interface LDCPLineView:UIView

/**
 *  @author ITxiansheng, 16-06-21 16:06:15
 *
 *  @brief 添加一像素高的分割线  分割线的宽度和父view相等 颜色默认
 *
 *  @return 分割线
 */
- (UIView *) addBottomLine;
/**
 *  @author ITxiansheng, 16-06-21 16:06:25
 *
 *  @brief 添加指定长度的一像素高的分割线  颜色默认
 *
 *  @param lineWidth 分割线的宽度
 *
 *  @return 分割线
 */
- (UIView *)addBottomLineWith:(CGFloat)lineWidth;

/**
 *  @author ITxiansheng, 16-06-21 16:06:44
 *
 *  @brief 添加指定长度 指定颜色 一像素高的分割线
 *
 *  @param lineWidth 分割线宽度
 *  @param lineColor 分割线颜色
 *
 *  @return 分割线
 */
- (UIView *)addBottomLineWith:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;
@end
