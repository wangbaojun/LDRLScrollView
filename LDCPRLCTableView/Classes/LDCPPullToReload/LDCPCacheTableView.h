//
//  LDCPCacheTableView.h
//  Pods
//
//  Created by ITxiansheng on 16/7/1.
//
//

#import <UIKit/UIKit.h>

@interface LDCPCacheTableView : UITableView

@property (nonatomic, assign) BOOL  precacheEnabled;
@property (nonatomic, assign) BOOL  debugLogEnabled;


/**
 *  indexPath 是否有缓存高度
 */
- (BOOL)hasCachedHeightAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  缓存高度 height 到 indexPath
 */
- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath;

/**
 *  在 indexPath 的缓存高度，无效换缓存返回 -1  使用前调用 hasCachedHeightAtIndexPath: 判断
 *
 */
- (CGFloat)cachedHeightAtIndexPath:(NSIndexPath *)indexPath;

@end

