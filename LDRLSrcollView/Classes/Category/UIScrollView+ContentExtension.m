//
//  UIScrollView+ContentExtension.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "UIScrollView+ContentExtension.h"

@implementation UIScrollView (ContentExtension)

- (CGFloat) ld_contentInsertBottom {
    
    return self.contentInset.bottom;
}

- (void) setLd_contentInsertBottom:(CGFloat)ld_contentInsertBottom {
    
    UIEdgeInsets inserts = self.contentInset;
    inserts.bottom = ld_contentInsertBottom;
    self.contentInset = inserts;
}

- (void) setLd_contentInsertTop:(CGFloat)ld_contentInsertTop {
    
    UIEdgeInsets inserts = self.contentInset;
    inserts.top = ld_contentInsertTop;
    self.contentInset = inserts;
}

- (CGFloat) ld_contentInsertTop {
    
    return self.contentInset.top;
}

- (CGFloat) ld_contentOffsetTop {
    
    return self.contentOffset.y;
}

- (void) setLd_contentOffsetTop:(CGFloat)ld_contentOffsetTop {
    
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = ld_contentOffsetTop;
    self.contentOffset = contentOffset;
}

@end
