//
//  UIPullToReloadTableViewController.m
//  pullToReloadTableViewTest

/*
 
 Created by Water Lou | http://www.waterworld.com.hk
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */

#import "UIPullToReloadTableViewController.h"

@implementation UIPullToReloadTableViewController

@synthesize pullToReloadHeaderView;

#pragma mark - View Lifecycle

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        tableViewStyle = style;
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tView
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.tableView = tView;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        tableViewStyle = UITableViewStylePlain;
    }
    return  self;
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0xf9 / 255.0f green:0xf8 / 255.0f blue:0xf0 / 255.0f alpha:1.0f];
    if (!self.tableView) {
        CGRect rect = self.view.bounds;
        if (self.hasToolbar) {
            rect.size.height -= 44;
        }
        self.tableView = [[UITableView alloc] initWithFrame:rect style:tableViewStyle];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    } else {
        [self.view addSubview:self.tableView];
    }
  
    if (!pullToReloadHeaderView) {
        pullToReloadHeaderView = [[UIPullToReloadHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        [self.tableView addSubview:pullToReloadHeaderView];
    }
}

- (void)viewDidUnload
{
	[super viewDidUnload];
    pullToReloadHeaderView = nil;
}

#pragma mark UITableViewDelegate
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
    if ([pullToReloadHeaderView status] != kPullStatusLoading) {
        checkForRefresh = YES;  //  only check offset when dragging
    }
} 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToReloadHeaderView setDragOffset:scrollView.contentOffset];
    
    if ([pullToReloadHeaderView status] == kPullStatusLoading) {
        return;
    }
	
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
        [pullToReloadHeaderView startReloading:self.tableView animated:YES];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self performSelector:@selector(pullDownToReloadAction) withObject:nil afterDelay:0.1f];
        } else {
            [self pullDownToReloadAction];
        }
	}
	checkForRefresh = NO;
}

#pragma mark actions
- (void)autoPullDownToRefresh
{
    [self scrollViewWillBeginDragging:self.tableView];
    [self.tableView setContentOffset:CGPointMake(0,-kPullDownToReloadToggleHeight-20) animated:NO];
    [self scrollViewDidScroll:self.tableView];
    [self scrollViewDidEndDragging:self.tableView willDecelerate:YES];
}

- (void)pullDownToReloadAction
{
	NSLog(@"TODO: Overload this");
}


@end

