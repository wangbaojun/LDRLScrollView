//
//  LDViewController.m
//  LDRLSrcollView
//
//  Created by bjwangbaojun on 11/20/2016.
//  Copyright (c) 2016 bjwangbaojun. All rights reserved.
//

#import "LDViewController.h"
#import "LDLoadMoreControlView.h"
#import "LDRLTableView.h"

@interface LDViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) LDRLTableView *tableView;
@property (strong, nonatomic)  UIImageView *loacalDataImageView;
@property (strong, nonatomic)  UIImageView *urlDataImageView;

@end

@implementation LDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _tableView = [[LDRLTableView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView setLoadMoreState:LDLoadMoreStateIdle];
    __weak typeof(self) weakSelf = self;
    [self.tableView setLoadMoreBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"loadMore了");
        [strongSelf performSelector:@selector(setLoadMoreError) withObject:nil afterDelay:5];
        [strongSelf performSelector:@selector(setLoadNoMore) withObject:nil afterDelay:7];
        [strongSelf performSelector:@selector(setLoadMoreNoHiden) withObject:nil afterDelay:9];
        [strongSelf performSelector:@selector(setLoadMoreIdle) withObject:nil afterDelay:11];
        [strongSelf performSelector:@selector(setLoadMoreNone) withObject:nil afterDelay:13];
        [strongSelf performSelector:@selector(setLoadMoreIdle) withObject:nil afterDelay:15];
        
    }];
    
    [self.tableView setPullRefreshBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf performSelector:@selector(endFresh) withObject:nil afterDelay:5];
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
    return 15;
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
- (void)setLoadNoMore{
    [self.tableView setLoadMoreState:LDLoadMoreStateNoMore];
}

- (void)setLoadMoreError{
    [self.tableView setLoadMoreState:LDLoadMoreStateError];
}

- (void)setLoadMoreIdle{
    [self.tableView setLoadMoreState:LDLoadMoreStateIdle];
}

- (void)setLoadMoreNone{
    [self.tableView setLoadMoreState:LDLoadMoreStateNone];
    
}

- (void)endFresh{
    [self.tableView endRefreshAnimated:YES];
}
@end
