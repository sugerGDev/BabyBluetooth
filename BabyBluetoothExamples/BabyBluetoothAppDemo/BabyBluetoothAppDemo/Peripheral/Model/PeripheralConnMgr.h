//
//  PeripheralConnMgr.h
//  BabyBluetoothAppDemo
//
//  Created by suger on 2018/10/9.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeripheralConnectionInfo.h"

/**
 * 链接管理
 */
@interface PeripheralConnMgr : NSObject
+ (instancetype)sharedInstance;
/**
 * 添加链接实体
 * @param connectionInfo  链接实体
 * @return 是否添加成功，如果已经链接的设备，添加返回NO
 */
- (BOOL)appendPeripheralConnectionInfo:(PeripheralConnectionInfo *)connectionInfo;

/**
 * 获取当前链接设备集合
 * @return 集合对象
 */
- (NSMutableArray <PeripheralConnectionInfo *>*)count;

/**
 * 移除指定链接实体
 * @param connectionInfo 链接实体
 * @return 是否移除成功，如果移除成功，返回YES
 */
- (BOOL)removePeripheralConnectionInfo:(PeripheralConnectionInfo *)connectionInfo;

@end
