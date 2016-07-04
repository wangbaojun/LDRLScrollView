//
//  LDCPRefreshControl.h
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import <UIKit/UIKit.h>
#import "LDCPRefreshView.h"


/**
 *  Refresh Control 处理 ScrollView 对应的世界，改变Refresh 状态
 */

@interface LDCPRefreshControl : UIControl

@property (nonatomic,assign) UIPullToReloadStatus refreshStatus;
@property (nonatomic,weak) UIScrollView * observerView;

//子类去实现
- (void)setIsPullDown:(BOOL)isPullDown;
@end
