//
//  UIPullToReloadTableView.m
//  NeteaseLottery
//
//  Created by xuguoxing on 12-6-8.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "UIPullToReloadTableView.h"

@implementation UIPullToReloadTableView
{
    BOOL checkForRefresh;
}
@synthesize pullToReloadHeaderView;

/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.pullToReloadHeaderView = [[[UIPullToReloadHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.bounds.size.height+35.0,
                                                                                             self.bounds.size.width, self.bounds.size.height)]autorelease];
        [self addSubview:pullToReloadHeaderView];
    }
    return self;
}
*/
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.pullToReloadHeaderView = [[UIPullToReloadHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:pullToReloadHeaderView];
    }
    return self;
}

#pragma tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Should Never Reach Here!
    UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
    [emptyCell.contentView.superview setBackgroundColor:[UIColor clearColor]];
    [emptyCell.contentView setBackgroundColor:[UIColor clearColor]];
    return emptyCell;
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
    checkForRefresh = YES;  //  only check offset when dragging
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToReloadHeaderView setDragOffset:scrollView.contentOffset];
    
    if ([pullToReloadHeaderView status] == kPullStatusLoading) return;

    if (checkForRefresh) {
        if (scrollView.contentOffset.y > -kPullDownToReloadToggleHeight && scrollView.contentOffset.y < 0.0f) {
            [pullToReloadHeaderView setStatus:kPullStatusPullDownToReload animated:YES];
        } else if (scrollView.contentOffset.y < -kPullDownToReloadToggleHeight) {
            [pullToReloadHeaderView setStatus:kPullStatusReleaseToReload animated:YES];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
    if ([pullToReloadHeaderView status] == kPullStatusReleaseToReload) {
        [pullToReloadHeaderView startReloading:self animated:YES];
        [self pullDownToReloadAction];
    }
    checkForRefresh = NO;
}

- (void)autoPullDownToRefresh
{
    [self scrollViewWillBeginDragging:self];
    [self setContentOffset:CGPointMake(0, -kPullDownToReloadToggleHeight - 20) animated:NO];
    [self scrollViewDidScroll:self];
    [self scrollViewDidEndDragging:self willDecelerate:YES];
}

#pragma mark actions

- (void)pullDownToReloadAction
{
    NSLog(@"TODO: Overload this");
}


@end
