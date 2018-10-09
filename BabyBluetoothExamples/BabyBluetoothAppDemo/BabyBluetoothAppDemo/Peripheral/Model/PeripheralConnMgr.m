//
//  PeripheralConnMgr.m
//  BabyBluetoothAppDemo
//
//  Created by suger on 2018/10/9.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

#import "PeripheralConnMgr.h"
#import "BabyBluetooth.h"

@interface PeripheralConnMgr()
@property(nonatomic, strong) NSMutableArray< PeripheralConnectionInfo *> *connections;
@end

@implementation PeripheralConnMgr
+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}


- (NSMutableArray<PeripheralConnectionInfo *> *)connections {
    if (!_connections) {
        _connections = [NSMutableArray arrayWithCapacity:10];
    }
    return _connections;
}

- (BOOL)appendPeripheralConnectionInfo:(PeripheralConnectionInfo *)connectionInfo {
    // 检查该实体是否已经链接过
    BabyBluetooth *babyBluetooth = connectionInfo.baby;
   CBPeripheral *connectionPeripheral =  [babyBluetooth findConnectedPeripheral:connectionInfo.currPeripheral.name];
    if (connectionPeripheral) {
        BabyLog(@"该设备已经链接");
        return NO;
    } else {
        [self.connections addObject:connectionInfo];
        return YES;
    }
}

- (NSMutableArray <PeripheralConnectionInfo *> *)count {
    return self.connections;
}
@end