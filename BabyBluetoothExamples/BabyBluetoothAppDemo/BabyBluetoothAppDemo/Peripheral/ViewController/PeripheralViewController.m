//
//  PeripheralViewContriller.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/4.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "PeripheralViewController.h"
#import "SVProgressHUD.h"
#import "PeripheralConnMgr.h"
#import "YYKit.h"
#import "QueryHistoryViewController.h"

@interface PeripheralViewController ()
@property(nonatomic, weak) NSMutableArray< PeripheralConnectionInfo *> *connections;
@end

@implementation PeripheralViewController{
    
}
-(void)dealloc {
    BabyLog(@">>> PeripheralViewController dealloc ");
    //    [baby cancelAllPeripheralsConnection];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已链接设备";
    self.connections = PeripheralConnMgr.sharedInstance.count;
    
//    // 指定服务对象 id
//    NSString *const kTargetServiceUUID = @"FEEA";
//    // 指定特征对象 id
//    NSString *const kTargetCharacteristicUUID = @"2AA1";

    
    //开始扫描设备
    [SVProgressHUD showInfoWithStatus:@"准备连接设备"];
    //导航右侧菜单
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [navRightBtn setTitle:@"😸" forState:UIControlStateNormal];
    [navRightBtn.titleLabel setTextColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    [navRightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
}



//导航右侧按钮点击
-(void)navRightBtnClick:(id)sender{
    NSLog(@"navRightBtnClick");
    //    [self.tableView reloadData];
    //    [self readPlantAssistantData];
//    NSArray *peripherals = [sel findConnectedPeripherals];
//    NSLog(@"peripherals is :%@",peripherals);
    
    QueryHistoryViewController *history = [[QueryHistoryViewController alloc]init];
    [self.navigationController pushViewController:history animated:YES];
}


- (void)appendDeviceConnectionInfo:(PeripheralConnectionInfo *)connectionInfo {
    NSAssert([connectionInfo isKindOfClass:PeripheralConnectionInfo.class], @"添加设备失败，请检查添加对象是否正确");
    [PeripheralConnMgr.sharedInstance appendPeripheralConnectionInfo:connectionInfo];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    PeripheralConnectionInfo *connectionInfo = [self.connections objectOrNilAtIndex:indexPath.row];
    cell.textLabel.text = connectionInfo.currPeripheral.name;
    cell.detailTextLabel.text = connectionInfo.currPeripheral.description;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    PeripheralConnectionInfo *connectionInfo = [self.connections objectOrNilAtIndex:indexPath.row];
    
    BabyBluetooth *baby = connectionInfo.baby;
    if ([baby findConnectedPeripheral:connectionInfo.currPeripheral.name]) {
        [SVProgressHUD showInfoWithStatus:@"该设备已链接，无需重新链接"];
    }
}
@end
