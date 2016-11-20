//
//  LDCPRefreshView.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import <UIKit/UIKit.h>


@interface LDRefreshView : UIView

@property (nonatomic, strong) UIImageView  *catImgView;


- (void)startRollOverAnimation ;
- (void)stopRollOverAnimation ;

- (void)startLoadingAnimation ;
- (void)stopLoadingAnimation ;


@end

