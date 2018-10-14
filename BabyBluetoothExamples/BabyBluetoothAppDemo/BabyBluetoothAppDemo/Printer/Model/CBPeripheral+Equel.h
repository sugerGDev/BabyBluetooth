//
// Created by sugar on 2018/10/14.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Equel)
/**
 * 判读是否是蓝牙打印机
 * @return
 */
- (BOOL)isPrinter;
@end
