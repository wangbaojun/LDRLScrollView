//
//  LDCPLoadMoreControl.h
//  Pods
//
//  Created by ITxiansheng on 16/6/21.
//
//

#import <UIKit/UIKit.h>
#import "LDCPLoadMoreView.h"

@interface LDCPLoadMoreControl : UIControl
/**
 *  加载更多状态，通过设置状态，改变view的展示
 *  如果需要自定义加载更多view，继承这个类，然后重写 setLoadMoreState 方法 参考 LDCPLoadMoreControlView 类
 */
@property (nonatomic,assign) LDCPLoadMoreState loadMoreState;
@end

