//
//  UIPullToReloadVerticalCollectionViewController.m
//  Pods
//
//  Created by 金秋实 on 12/10/15.
//
//

#import "UIPullToReloadVerticalCollectionViewController.h"

@interface UIPullToReloadVerticalCollectionViewController ()

@property (nonatomic, assign) BOOL checkForRefresh;

@end

@implementation UIPullToReloadVerticalCollectionViewController

- (instancetype)init
{
    return [self initWithCollectionView:nil];;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.collectionView = collectionView;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionView = nil;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.collectionView = nil;
    }
    return self;
}

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.pullToReloadHeaderView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0xf9 / 255.0f green:0xf8 / 255.0f blue:0xf0 / 255.0f alpha:1.0];
    if (!self.collectionView) {
        CGRect rect = self.view.bounds;
        if (self.hasToolBar) {
            rect.size.height -=44;
        }
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.alwaysBounceVertical = YES;
        [self.view addSubview:self.collectionView];
    } else {
        [self.view addSubview:self.collectionView];
    }
    
    if (!_pullToReloadHeaderView) {
        _pullToReloadHeaderView = [[UIPullToReloadHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        [self.collectionView addSubview:_pullToReloadHeaderView];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //OverWrite This
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //OverWrite This
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Should never Reach Here!
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    [cell.contentView.superview setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_pullToReloadHeaderView status] != kPullStatusLoading) {
        self.checkForRefresh = YES;  //  only check offset when dragging
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.pullToReloadHeaderView status] == kPullStatusLoading) {
        return;
    }
    
    if (self.checkForRefresh) {
        if (scrollView.contentOffset.y > -kPullDownToReloadToggleHeight && scrollView.contentOffset.y < 0.0f) {
            [self.pullToReloadHeaderView setStatus:kPullStatusPullDownToReload animated:YES];
        } else if (scrollView.contentOffset.y < -kPullDownToReloadToggleHeight) {
            [self.pullToReloadHeaderView setStatus:kPullStatusReleaseToReload animated:YES];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.pullToReloadHeaderView status] == kPullStatusLoading) return;
    
    if ([self.pullToReloadHeaderView status] == kPullStatusReleaseToReload) {
        [self.pullToReloadHeaderView startReloadingScrollView:self.collectionView animated:YES];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self performSelector:@selector(pullDownToReloadAction) withObject:nil afterDelay:0.1f];
        } else {
            [self pullDownToReloadAction];
        }
    }
    self.checkForRefresh = NO;
}

#pragma mark Actions

- (void)autoPullDownToRefresh
{
    [self scrollViewWillBeginDragging:self.collectionView];
    [self.collectionView setContentOffset:CGPointMake(0,-kPullDownToReloadToggleHeight-20) animated:NO];
    [self scrollViewDidScroll:self.collectionView];
    [self scrollViewDidEndDragging:self.collectionView willDecelerate:YES];
}

- (void)pullDownToReloadAction
{
    NSLog(@"TODO: Overload this");
}

@end
