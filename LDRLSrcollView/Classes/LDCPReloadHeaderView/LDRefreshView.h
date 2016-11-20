//
//  LDCPRefreshView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import <UIKit/UIKit.h>
#import "UIPullToReloadAnimationDelegate.h"


@interface LDRefreshView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong)  UILabel *statusLabel;

@property (nonatomic, strong) UIView <UIPullToReloadAnimationDelegate> *animationView;

@end

