//
//  ViewController.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "ViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "SVProgressHUD.h"
#import "PeripheralViewController.h"
#import "YYKit.h"
#import "CBPeripheral+Equel.h"
#import <PrinterSDK/PrinterSDK.h>

/**
 * 使用 printer 内搜索
 */
#ifndef D_USE_PRINTER_SCAN
#define  D_USE_PRINTER_SCAN 1
#endif
@interface ViewController (){
    NSMutableArray *peripheralDataArray;
    BabyBluetooth *baby;
    
#if D_USE_PRINTER_SCAN
    // 保存蓝牙搜索结果
    NSDictionary<NSString *, PTPrinter *> *ptDictionary;
#endif
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    NSLog(@"viewDidLoad");
    
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(doWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    //设置蓝牙委托
    [self babyDelegate];
    
    // 开始扫描
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _startScan];
    });
    
    // 右导航按钮
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [navRightBtn setTitle:@"🔍" forState:UIControlStateNormal];
    [navRightBtn.titleLabel setTextColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    [navRightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}




-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
    
}

#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //            return YES;
        //        }
        //        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
#if D_USE_PRINTER_SCAN
    [PTDispatcher.share whenFindBluetoothAll:^(NSDictionary<NSString *, PTPrinter *> *printerDic) {
        //TODO:保存蓝牙打印机搜索结果
        self->ptDictionary = printerDic;
    }];
#endif
    
}


#pragma mark - Private
- (void)doWillEnterForegroundNotification:(NSNotification *)notification {
    //    BabyLog(@"self.navigationController.visibleViewController is %@",self.navigationController.visibleViewController);
    //判断搜索view是否是本view
    if ([ NSStringFromClass(self.navigationController.visibleViewController.class) isEqualToString:NSStringFromClass(self.class)]) {
        [self _startScan];
    }
}

- (void)_startScan {
    BabyLog(@">>> start scan");
    if (baby.centralManager.state == CBCentralManagerStatePoweredOn) {
        [baby cancelAllPeripheralsConnection];
        
#if  D_USE_PRINTER_SCAN
        [PTDispatcher.share scanBluetooth];
#endif
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
            baby.scanForPeripherals().begin();
        });
    }else {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"设备异常，状态码为；（%ld）",(long)baby.centralManager.state]];
    }
}

- (void)_stopScan {
    
    [baby cancelScan];
#if D_USE_PRINTER_SCAN
    [PTDispatcher.share stopScanBluetooth];
#endif
}

- (void)navRightBtnClick:(id)aSender {
    
    [baby cancelAllPeripheralsConnection];
    [self _startScan];
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    

    NSArray *peripherals = [peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        
        BabyLog(@"peripheral is %@  advertisementData is %@  RSSI is %@",peripheral,advertisementData,RSSI);
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral.copy forKey:@"peripheral"];
        [item setValue:RSSI.copy forKey:@"RSSI"];
        [item setValue:advertisementData.copy forKey:@"advertisementData"];
        

            
#if  D_USE_PRINTER_SCAN
        //TODO:如果是蓝牙打印机，需要保存制定的封装类型
        if (peripheral.isPrinter) {
            BabyLog(@"pt dict is %@",self->ptDictionary);
            
            PTPrinter *p = nil;
            if ( (p = [self _findPrinterWithPeripheral:peripheral]) ) {
                 [item setValue:p forKey:@"printer"];
            }
           
        }
#endif
        
        [peripheralDataArray addObject:item];
        
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //TODO: 自动链接之前的设备
        NSString *lastConnectionPeripheralUUID = [NSUserDefaults.standardUserDefaults objectForKey:kLastConnectionPeripheralUUID];
        if (
            // 当前页面
            [NSStringFromClass(self.navigationController.visibleViewController.class) isEqualToString:NSStringFromClass(self.class)]&&
            // 之前的链接uuid 一致
            [peripheral.identifier.UUIDString isEqualToString:lastConnectionPeripheralUUID]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self _navPeripheralViewControllerWithPeripheral:peripheral];
            });
        }
    }
}

#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return peripheralDataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    
    cell.textLabel.text = peripheralName;
    //信号和服务
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    [self _navPeripheralViewControllerWithPeripheral:peripheral];
    
}

- (void)_navPeripheralViewControllerWithPeripheral:(CBPeripheral *)peripheral {
    //停止扫描
    [self _stopScan];
    
    __block NSDictionary *targetItem = nil;
    
    [peripheralDataArray enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
        CBPeripheral *p = [item objectForKey:@"peripheral"];
        if ([p isEqual:peripheral]) {
            targetItem = item;
            *stop = YES;
        }
    }];

    if (targetItem == nil) {
        return;
    }
    
    PeripheralConnectionInfo *connectionInfo = nil;
    {
        
        if (peripheral.isPrinter) {
            PTPrinter *printer = nil;
#if !D_USE_PRINTER_SCAN
            NSDictionary *advertisementData = [targetItem objectForKey:@"advertisementData"];
            NSNumber *RSSI = [targetItem objectForKey:@"RSSI"];
            

          printer = [[PTPrinter alloc]initWithPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
#else
            
            printer =  [self _findPrinterWithPeripheral:peripheral];
#endif
            
            PeripheralConfigInfo *configInfo = [[PeripheralConfigInfo alloc] initWithPrinter:printer];
            connectionInfo = [[PeripheralConnectionInfo alloc] initWithCurrPeripheral:peripheral dispatcher:PTDispatcher.share configInfo:configInfo];
            
        } else {
            
            NSDictionary *config = PeripheralConfigInfo.scanConfigInfo;
            NSString *s = [config stringValueForKey:kServiceIdKey default:@""];
            NSString *c = [config stringValueForKey:kCharacteristicIdKey default:@""];
            
            PeripheralConfigInfo *configInfo = [[PeripheralConfigInfo alloc]initWithServiceId:s characteristicId:c];
            connectionInfo = [[PeripheralConnectionInfo alloc]initWithCurrPeripheral:peripheral baby:baby configInfo:configInfo];
        }
    }
    
    [peripheralDataArray removeObject:targetItem];
    targetItem = nil;
    [self.tableView reloadData];
    

    
    PeripheralViewController *vc = [[PeripheralViewController alloc]init];
    [vc appendDeviceConnectionInfo:connectionInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

#if D_USE_PRINTER_SCAN
#pragma mark - 蓝牙打印机适配
- (PTPrinter *)_findPrinterWithPeripheral:(CBPeripheral *)peripheral {
    __block PTPrinter *target = nil;
    [ptDictionary.allValues enumerateObjectsUsingBlock:^(PTPrinter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.peripheral isEqual:peripheral]) {
            target = obj;
            *stop = YES;
        }
    }];
    return target;
}
#endif

@end
