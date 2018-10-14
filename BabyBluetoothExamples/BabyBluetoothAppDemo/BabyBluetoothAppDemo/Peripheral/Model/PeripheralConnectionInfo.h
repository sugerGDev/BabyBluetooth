//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeripheralConfigInfo.h"

@class PeripheralConfigInfo;
@class CBPeripheral;
@class BabyBluetooth;
@class CBService;
@class CBCharacteristic;
@class PTDispatcher;

/**
 * 每个链接设备对象
 */
@interface PeripheralConnectionInfo : NSObject

@property(weak,  nonatomic, readonly)BabyBluetooth *baby;

@property(strong, nonatomic, readonly)CBPeripheral *currPeripheral;

@property(nonatomic, strong) NSMutableString *scanContent;

@property(nonatomic, strong, readonly) PeripheralConfigInfo *configInfo;


/**
 打印机相关参数
 打印机实例
 */
@property(nonatomic, weak,readonly) PTDispatcher *dispatcher;

/**
 打印机相关参数
 是否可以打印每次每次在调用打印功能必须检查项
 */
@property(nonatomic, assign) BOOL canPrinter;




- (instancetype)init NS_UNAVAILABLE;
// 初始化扫描枪方法
- (instancetype)initWithCurrPeripheral:(CBPeripheral *)currPeripheral baby:(BabyBluetooth *)baby configInfo:(PeripheralConfigInfo *)configInfo;
// 初始化打印机方法
- (instancetype)initWithCurrPeripheral:(CBPeripheral *)currPeripheral dispatcher:(PTDispatcher *)dispatcher configInfo:(PeripheralConfigInfo *)configInfo;
/**
 * 重新链接
 */
- (void)reConnnection;


- (void)connect;
/**
 * 取消链接
 */
- (void)cancelConnection;
@end
