//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import "PeripheralConnectionInfo.h"
#import "SVProgressHUD.h"
#import "PeripheralConfigInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "YYKit.h"

@interface PeripheralConnectionInfo()
/**
 * 配置信息
 */
@property(nonatomic, strong) PeripheralConfigInfo *configInfo;
/**
 * 当前链接对象
 */
@property(strong, nonatomic)CBPeripheral *currPeripheral;
/**
 * 管理对象
 */
@property(weak,   nonatomic)BabyBluetooth *baby;
/**
 * 当前链接唯一标示
 */
@property(nonatomic, copy) NSString *connectionInfoId;


@property(nonatomic, strong) CBService *tService;
@property(nonatomic, strong) CBCharacteristic *tCharacteristic;
@end

@implementation PeripheralConnectionInfo

- (instancetype)initWithCurrPeripheral:(CBPeripheral *)currPeripheral
                                  baby:(BabyBluetooth *)baby
                            configInfo:(PeripheralConfigInfo *)configInfo {
    self = [super init];
    if (self) {
        _currPeripheral = currPeripheral;
        _configInfo = configInfo;
        _baby = baby;

        NSAssert([_configInfo isKindOfClass:PeripheralConfigInfo .class], @"请配置PeripheralConfigInfo 相关信息");


        self.connectionInfoId = [NSString stringWithFormat:@"%ld",(long)self.hash];

        [self _babyDelegate];

        [self _doConnectionAction];
    }

    return self;
}


//babyDelegate
-(void)_babyDelegate{

    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];


    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [self.baby setBlockOnConnectedAtChannel:self.connectionInfoId block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        //TODO: 保存链接成功的蓝牙设备
        [NSUserDefaults.standardUserDefaults setObject:weakSelf.currPeripheral.identifier.UUIDString forKey:kLastConnectionPeripheralUUID];
    }];

    //设置设备连接失败的委托
    [self.baby setBlockOnFailToConnectAtChannel:self.connectionInfoId block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];

    //设置设备断开连接的委托
    [self.baby setBlockOnDisconnectAtChannel:self.connectionInfoId block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
    }];

    //设置发现设备的Services的委托
    [self.baby setBlockOnDiscoverServicesAtChannel:self.connectionInfoId block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf _appendSevice:s];
        }

        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristicsAtChannel:self.connectionInfoId block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf _appendCharacteristicsAtService:service];

    }];
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristicAtChannel:self.connectionInfoId block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:self.connectionInfoId block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptorsAtChannel:self.connectionInfoId block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];

    //读取rssi的委托
    [self.baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];


    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");

        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }

    }];

    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];

    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
            CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
            CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};

    [self.baby setBabyOptionsAtChannel:self.connectionInfoId scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];

}

#pragma mark - Public
// 重新链接
- (void)reConnnection {

}

#pragma mark -Private
- (void)_appendSevice:(CBService *)service {
//    [self.services addObject:service];
    if ([service.UUID.UUIDString isEqualToString: self.configInfo.serviceId ]) {
        self.tService = service;
    }
}

- (void)_appendCharacteristicsAtService:(CBService *)service {
   
    if  (![self.tService isEqual:service] ) {
        return;
    }

    for (CBCharacteristic *c in service.characteristics) {
        if ([c.UUID.UUIDString isEqualToString:self.configInfo.characteristicId]) {
            self.tCharacteristic = c;
            break;
        }
    }

    if  (
            self.tService &&
            self.tCharacteristic &&
            ( (self.currPeripheral.state != CBPeripheralStateConnecting ) ||
                    (self.currPeripheral.state != CBPeripheralStateConnected) )
            ) {
        // 开始订阅
        [self _doNotifyAction];

    }
   
}

-(void)_doConnectionAction{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    self.baby.having(self.currPeripheral).and.channel(self.connectionInfoId).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}

#pragma mark - 订阅 Private
- (void)_doNotifyAction {

    [SVProgressHUD showInfoWithStatus:@"订阅中.."];

    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }

    if (self.tCharacteristic.properties & CBCharacteristicPropertyNotify ||  self.tCharacteristic.properties & CBCharacteristicPropertyIndicate) {

        if(self.tCharacteristic.isNotifying) {
            //如果已经订阅了，则不做处理
            //            [baby cancelNotify:self.currPeripheral characteristic:self.tCharacteristic];
            return;

        }else{

//            __weak __typeof(self)weakSelf = self;
            [self.currPeripheral setNotifyValue:YES forCharacteristic:self.tCharacteristic];
            [self.baby notify:self.currPeripheral
          characteristic:self.tCharacteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       NSLog(@"notify block");
//                       if (!weakSelf.content) {
//                           weakSelf.content = [[NSMutableString alloc]initWithCapacity:10];
//                       }
//
//                       [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf];
//
//                       NSString *valueStr = [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
//                       valueStr = [valueStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//
//                       if (![weakSelf.content isEqualToString:valueStr]) {
//                           // 之前的内容和原来的内容不同的时候
//                           [weakSelf.content appendFormat:@"%@",valueStr];
//                       }
//
//                       [weakSelf performSelector:@selector(_showScanResult:) withObject:weakSelf.content afterDelay:.5f];

                   }];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
}

/*
- (void)_showScanResult:(NSString *)result {

    [SVProgressHUD showInfoWithStatus:result];
    [self _saveQueryResult:result];

    self.content = nil;
}

#pragma mark - 保存到本地
- (void)_saveQueryResult:(NSString *)result {



    NSArray *array = [WHCSqlite query:QueryRecordInfo.class where:[NSString stringWithFormat:@"qId = '%@' ",result]];
    QueryRecordInfo *info = nil;

    if  (array.count ){

        info = array.firstObject;
        // 存在之前扫描的内容，则把内容放到第一位
        NSMutableArray *all = [WHCSqlite query:QueryRecordInfo.class].mutableCopy;
        NSInteger rId = [all indexOfObject:array.firstObject];
        if (rId != NSNotFound) {
            [all exchangeObjectAtIndex:0 withObjectAtIndex:rId];
        }
        [WHCSqlite clear:QueryRecordInfo .class];
        [WHCSqlite inserts:all];


    } else {
        // 在后头插入数据
        info = [QueryDatabaseMgr.sharedInstance.source objectForKey:result];
        if (!info) {
            info = [[QueryRecordInfo alloc]initWithQId:result];
        }
        [WHCSqlite insert:info];
    }



    if ([self _doCheckVisibleViewControllerWithInfo:info] ){
        return;
    }

    QueryResultDetailViewController *detail = [[QueryResultDetailViewController alloc]init];
    detail.info = info;
    [self.navigationController pushViewController:detail animated:YES];

}

- (BOOL)_doCheckVisibleViewControllerWithInfo:(QueryRecordInfo *)info {

    if (
            [self.navigationController.visibleViewController isKindOfClass:QueryResultDetailViewController.class] ) {
        QueryResultDetailViewController *detail = (QueryResultDetailViewController *)self.navigationController.visibleViewController;
        detail.info = info;
        return YES;
    }
    return NO;
}
*/
 @end
