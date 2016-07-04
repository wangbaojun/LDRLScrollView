//
//  LDCPLineView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "LDCPLineView.h"
#import "Masonry.h"
@implementation  LDCPLineView

- (UIView *) addBottomLine{
    return [self addBottomLineWith:[UIScreen mainScreen].bounds.size.width lineColor:[UIColor colorWithRed:0xec / 255.0f green:0xec / 255.0f blue:0xeb / 255.0f alpha:1.0]];
}


- (UIView *)addBottomLineWith:(CGFloat)lineWidth{
    return [self addBottomLineWith:lineWidth lineColor:[UIColor colorWithRed:0xec / 255.0f green:0xec / 255.0f blue:0xeb / 255.0f alpha:1.0]];
}

- (UIView *)addBottomLineWith:(CGFloat)lineWidth lineColor:(UIColor *)lineColor{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1.0/[UIScreen mainScreen].scale));
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(lineWidth);
    }];
    return lineView;
}
@end
