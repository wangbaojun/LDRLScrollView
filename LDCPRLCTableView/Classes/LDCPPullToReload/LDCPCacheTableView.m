//
//  LDCPCacheTableView.m
//  Pods
//
//  Created by ITxiansheng on 16/7/1.
//
//

#import "LDCPCacheTableView.h"

@interface QWHCellHeightCache : NSObject
// 2 dimensions array, sections-rows-height
@property (nonatomic, strong) NSMutableArray *sections;

@end

// Tag a absent height cache value which will be set to a real value.
static CGFloat const QWHCellHeightCacheAbsentValue = -1;

@implementation QWHCellHeightCache

- (void)buildHeightCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) {
        return;
    }
    
    if (!self.sections) {
        self.sections = @[].mutableCopy;
    }
    
    // Build every section array or row array which is smaller than given index path.
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        
        NSAssert(indexPath.section >= 0, @"Expect a positive section rather than '%@'.", @(indexPath.section));
        
        for (NSInteger section = 0; section <= indexPath.section; ++section) {
            if (section >= self.sections.count) {
                self.sections[section] = @[].mutableCopy;
            }
        }
        NSMutableArray *rows = self.sections[indexPath.section];
        for (NSInteger row = 0; row <= indexPath.row; ++row) {
            if (row >= rows.count) {
                rows[row] = @(QWHCellHeightCacheAbsentValue);
            }
        }
    }];
}

- (BOOL)hasCachedHeightAtIndexPath:(NSIndexPath *)indexPath
{
    [self buildHeightCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *cachedNumber = self.sections[indexPath.section][indexPath.row];
    return ![cachedNumber isEqualToNumber:@(QWHCellHeightCacheAbsentValue)];
}

- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath
{
    [self buildHeightCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.sections[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)cachedHeightAtIndexPath:(NSIndexPath *)indexPath
{
    [self buildHeightCachesAtIndexPathsIfNeeded:@[indexPath]];
#if CGFLOAT_IS_DOUBLE
    return [self.sections[indexPath.section][indexPath.row] doubleValue];
#else
    return [self.sections[indexPath.section][indexPath.row] floatValue];
#endif
}

@end


@interface LDCPCacheTableView ()

@property (nonatomic, strong) QWHCellHeightCache * cellHeightCache;

@end
@implementation LDCPCacheTableView
- (void)fd_debugLog:(NSString *)message
{
    if (!self.debugLogEnabled) {
        return;
    }
    NSLog(@"** FDTemplateLayoutCell ** %@", message);
}

- (void)fd_precacheIfNeeded
{
    if (!self.precacheEnabled) {
        return;
    }
    
    // Delegate could use "rowHeight" rather than implements this method.
    if (![self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return;
    }
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    // This is a idle mode of RunLoop, when UIScrollView scrolls, it jumps into "UITrackingRunLoopMode"
    // and won't perform any cache task to keep a smooth scroll.
    CFStringRef runLoopMode = kCFRunLoopDefaultMode;
    
    // Collect all index paths to be precached.
    NSMutableArray *mutableIndexPathsToBePrecached = self.fd_allIndexPathsToBePrecached.mutableCopy;
    
    // Setup a observer to get a perfect moment for precaching tasks.
    // We use a "kCFRunLoopBeforeWaiting" state to keep RunLoop has done everything and about to sleep
    // (mach_msg_trap), when all tasks finish, it will remove itself.
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler
    (kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
        // Remove observer when all precache tasks are done.
        if (mutableIndexPathsToBePrecached.count == 0) {
            CFRunLoopRemoveObserver(runLoop, observer, runLoopMode);
            CFRelease(observer);
            return;
        }
        // Pop first index path record as this RunLoop iteration's task.
        NSIndexPath *indexPath = mutableIndexPathsToBePrecached.firstObject;
        [mutableIndexPathsToBePrecached removeObject:indexPath];
        
        // This method creates a "source 0" task in "idle" mode of RunLoop, and will be
        // performed in a future RunLoop iteration only when user is not scrolling.
        [self performSelector:@selector(fd_precacheIndexPathIfNeeded:)
                     onThread:[NSThread mainThread]
                   withObject:indexPath
                waitUntilDone:NO
                        modes:@[NSDefaultRunLoopMode]];
    });
    
    CFRunLoopAddObserver(runLoop, observer, runLoopMode);
}

- (void)fd_precacheIndexPathIfNeeded:(NSIndexPath *)indexPath
{
    // A cached indexPath
    if ([self.cellHeightCache hasCachedHeightAtIndexPath:indexPath]) {
        return;
    }
    
    // This RunLoop source may have been invalid at this point when data source
    // changes during precache's dispatching.
    if (indexPath.section >= [self numberOfSections] ||
        indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return;
    }
    
    CGFloat height = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    [self.cellHeightCache cacheHeight:height byIndexPath:indexPath];
    [self fd_debugLog:[NSString stringWithFormat:
                       @"finished precache - [%@:%@] %@",
                       @(indexPath.section),
                       @(indexPath.row),
                       @(height)]];
}

- (NSArray *)fd_allIndexPathsToBePrecached
{
    NSMutableArray *allIndexPaths = @[].mutableCopy;
    for (NSInteger section = 0; section < [self numberOfSections]; ++section) {
        for (NSInteger row = 0; row < [self numberOfRowsInSection:section]; ++row) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            if (![self.cellHeightCache hasCachedHeightAtIndexPath:indexPath]) {
                [allIndexPaths addObject:indexPath];
            }
        }
    }
    return allIndexPaths.copy;
}

- (BOOL) hasCachedHeightAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellHeightCache hasCachedHeightAtIndexPath:indexPath];
}
- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath{
    [self.cellHeightCache cacheHeight:height byIndexPath:indexPath];
}

- (CGFloat)cachedHeightAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellHeightCache cachedHeightAtIndexPath:indexPath];
}

- (QWHCellHeightCache *) cellHeightCache{
    if(!_cellHeightCache){
        _cellHeightCache = [[QWHCellHeightCache alloc] init];
    }
    return _cellHeightCache;
}

- (void)reloadData
{
    [self.cellHeightCache.sections removeAllObjects];
    [super reloadData]; // Primary call
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self.cellHeightCache.sections insertObject:@[].mutableCopy atIndex:idx];
    }];
    
    [super insertSections:sections withRowAnimation:animation]; // Primary call
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self.cellHeightCache.sections removeObjectAtIndex:idx];
    }];
    [super deleteSections:sections withRowAnimation:animation]; // Primary call
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    
    [sections enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
        if (idx < self.cellHeightCache.sections.count) {
            NSMutableArray *rows = self.cellHeightCache.sections[idx];
            for (NSInteger row = 0; row < rows.count; ++row) {
                rows[row] = @(QWHCellHeightCacheAbsentValue);
            }
        }
    }];
    
    [self reloadSections:sections withRowAnimation:animation]; // Primary call
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    NSInteger sectionCount = self.cellHeightCache.sections.count;
    if (section < sectionCount && newSection < sectionCount) {
        [self.cellHeightCache.sections exchangeObjectAtIndex:section withObjectAtIndex:newSection];
    }
    [super moveSection:section toSection:newSection]; // Primary call
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.cellHeightCache buildHeightCachesAtIndexPathsIfNeeded:indexPaths];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSMutableArray *rows = self.cellHeightCache.sections[indexPath.section];
        [rows insertObject:@(QWHCellHeightCacheAbsentValue) atIndex:indexPath.row];
    }];
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation]; // Primary call
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.cellHeightCache buildHeightCachesAtIndexPathsIfNeeded:indexPaths];
    
    NSMutableDictionary *mutableIndexSetsToRemove = @{}.mutableCopy;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        
        NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
        if (!mutableIndexSet) {
            mutableIndexSetsToRemove[@(indexPath.section)] = [NSMutableIndexSet indexSet];
        }
        
        [mutableIndexSet addIndex:indexPath.row];
    }];
    
    [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
        NSMutableArray *rows = self.cellHeightCache.sections[key.integerValue];
        [rows removeObjectsAtIndexes:indexSet];
    }];
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation]; // Primary call
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.cellHeightCache buildHeightCachesAtIndexPathsIfNeeded:indexPaths];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSMutableArray *rows = self.cellHeightCache.sections[indexPath.section];
        rows[indexPath.row] = @(QWHCellHeightCacheAbsentValue);
    }];
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation]; // Primary call
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.cellHeightCache buildHeightCachesAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
    
    NSMutableArray *sourceRows = self.cellHeightCache.sections[sourceIndexPath.section];
    NSMutableArray *destinationRows = self.cellHeightCache.sections[destinationIndexPath.section];
    
    NSNumber *sourceValue = sourceRows[sourceIndexPath.row];
    NSNumber *destinationValue = destinationRows[destinationIndexPath.row];
    
    sourceRows[sourceIndexPath.row] = destinationValue;
    destinationRows[destinationIndexPath.row] = sourceValue;
    [super moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath]; // Primary call
}

@end

