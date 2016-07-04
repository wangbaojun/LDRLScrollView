//
//  UIPullToReloadDefaultAnimationView.h
//  Pods
//
//  Created by SongLi on 1/5/15.
//
//

#import <UIKit/UIKit.h>
#import "UIPullToReloadAnimationDelegate.h"

@interface UIPullToReloadDefaultAnimationView : UIView <UIPullToReloadAnimationDelegate>

- (void)setPullToReloadImage:(UIImage *)image;

- (void)setReloadActivityStyle:(UIActivityIndicatorViewStyle)style;

@end
