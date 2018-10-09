//
//  QueryHistoryViewController.m
//  BabyBluetoothAppDemo
//
//  Created by suger on 2018/10/8.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

#import "QueryHistoryViewController.h"
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>
#import "QueryRecordInfo.h"
#import "QueryResultDetailViewController.h"

@interface QueryHistoryViewController ()<UITabBarDelegate,UITableViewDataSource>
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property(nonatomic, strong) NSArray <QueryRecordInfo *>*data;
    @end

@implementation QueryHistoryViewController
    
    - (void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];
        
        self.data = [WHCSqlite query:QueryRecordInfo.class];
        [self.tableView reloadData];
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    self.tableView.tableFooterView = [[UIView alloc]init];
    // Do any additional setup after loading the view from its nib.
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.data.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    QueryRecordInfo *info = [self.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = info.qId;
    cell.detailTextLabel.text = info.productName;

    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QueryRecordInfo *info = [self.data objectAtIndex:indexPath.row];
    QueryResultDetailViewController *detail = [[QueryResultDetailViewController alloc]init];
    detail.info = info;
    detail.title = @"查看详情";
    [ self.navigationController pushViewController:detail animated:YES ];
}
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    @end
