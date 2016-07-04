//
//  UIScrollView+ContentExtension.m
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import "UIScrollView+ContentExtension.h"

@implementation UIScrollView (ContentExtension)

- (CGFloat) ldcp_contentInsertBottom {
    return self.contentInset.bottom;
}

- (void) setLdcp_contentInsertBottom:(CGFloat)ldcp_contentInsertBottom{
    UIEdgeInsets inserts = self.contentInset;
    inserts.bottom = ldcp_contentInsertBottom;
    self.contentInset = inserts;
}

- (void) setLdcp_contentInsertTop:(CGFloat)ldcp_contentInsertTop{
    UIEdgeInsets inserts = self.contentInset;
    inserts.top = ldcp_contentInsertTop;
    self.contentInset = inserts;
}

- (CGFloat) ldcp_contentInsertTop{
    return self.contentInset.top;
}

- (CGFloat) ldcp_contentOffsetTop{
    return self.contentOffset.y;
}

- (void) setLdcp_contentOffsetTop:(CGFloat)ldcp_contentOffsetTop{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = ldcp_contentOffsetTop;
    self.contentOffset = contentOffset;
}

- (BOOL)outOfBoundsVertical{
    return (self.contentSize.height - self.bounds.size.height > 0);
}

@end
