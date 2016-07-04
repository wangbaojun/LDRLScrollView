//
//  LDCPViewController.m
//  LDCPRLCTableView
//
//  Created by bjwangbaojun on 07/04/2016.
//  Copyright (c) 2016 bjwangbaojun. All rights reserved.
//

#import "LDCPViewController.h"
#import "LDCPLoadMoreControlView.h"
#import "LDCPRLTableView.h"

@interface LDCPViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) LDCPRLTableView *tableView;
@property (nonatomic) BOOL checkForRefresh;

@end

@implementation LDCPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView = [[LDCPRLTableView alloc]initWithFrame:CGRectMake(0,40,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-40) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView setLoadMoreBlock:^{
        NSLog(@"loadMore了");
        [weakSelf performSelector:@selector(setLoadMoreError) withObject:nil afterDelay:5];
        [weakSelf performSelector:@selector(setLoadMoreHiden) withObject:nil afterDelay:10];
        [weakSelf performSelector:@selector(setLoadMoreNoHiden) withObject:nil afterDelay:15];
        
    }];
    
    [self.tableView setPullRefreshBlock:^{
        [weakSelf performSelector:@selector(endFresh) withObject:nil afterDelay:5];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}



- (void)setLoadMoreHiden{
    self.tableView.hideLoadMoreView = YES;
}
- (void)setLoadMoreNoHiden{
    self.tableView.hideLoadMoreView = NO;
}
- (void)setLoadMoreError{
    [self.tableView setLoadMoreState:LDCPLoadMoreStateError];
}

- (void)setLoadMoreIdle{
    [self.tableView setLoadMoreState:LDCPLoadMoreStateIdle];
}

- (void)endFresh{
    [self.tableView endRefreshAnimated:YES];
}


@end
