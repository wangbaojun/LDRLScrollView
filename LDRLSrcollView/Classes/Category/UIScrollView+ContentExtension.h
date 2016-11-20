//
//  UIScrollView+ContentExtension.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ContentExtension)

//========== getter与setter ===========
@property (nonatomic,assign) CGFloat ld_contentInsertBottom;//scrollView的contentInset.bottom
@property (nonatomic,assign) CGFloat ld_contentInsertTop;//scrollView的contentInset.top
@property (nonatomic,assign) CGFloat ld_contentOffsetTop;//scrollView的contentOffset.y

@end
