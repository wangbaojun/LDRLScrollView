//
//  UIPullToReloadVerticalCollectionViewController.h
//  Pods
//
//  Created by 金秋实 on 12/10/15.
//
//

#import <UIKit/UIKit.h>
#import "UIPullToReloadHeaderView.h"

@interface UIPullToReloadVerticalCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIPullToReloadHeaderView *pullToReloadHeaderView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL hasToolBar;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
NS_DESIGNATED_INITIALIZER
#endif
;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
NS_DESIGNATED_INITIALIZER
#endif
;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
NS_DESIGNATED_INITIALIZER
#endif
;

/**
 * OverWrite This!
 */
- (void)pullDownToReloadAction;

- (void)autoPullDownToRefresh;

@end
