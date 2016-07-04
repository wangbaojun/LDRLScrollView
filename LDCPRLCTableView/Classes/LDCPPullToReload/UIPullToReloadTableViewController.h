//
//  UIPullToReloadTableViewController.h
//

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

#import <UIKit/UIKit.h>
#import "UIPullToReloadHeaderView.h"

@interface UIPullToReloadTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
	UIPullToReloadHeaderView *pullToReloadHeaderView;	
    UITableViewStyle tableViewStyle;
	BOOL checkForRefresh;
}

@property(nonatomic,strong) UIPullToReloadHeaderView *pullToReloadHeaderView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) BOOL hasToolbar;

- (instancetype)initWithTableView:(UITableView *)tView
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
NS_DESIGNATED_INITIALIZER
#endif
;

- (instancetype)initWithStyle:(UITableViewStyle)style
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
NS_DESIGNATED_INITIALIZER
#endif
;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
NS_DESIGNATED_INITIALIZER
#endif
;

- (void)pullDownToReloadAction;
- (void)autoPullDownToRefresh;

@end