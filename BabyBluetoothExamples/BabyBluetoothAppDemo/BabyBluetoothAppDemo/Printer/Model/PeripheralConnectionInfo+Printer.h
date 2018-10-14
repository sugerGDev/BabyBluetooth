//
// Created by sugar on 2018/10/14.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeripheralConnectionInfo.h"
@class QueryRecordInfo;
/**
 * 蓝牙链接对象
 */
@interface PeripheralConnectionInfo (Printer)
- (void)connectPrinter;
- (void)print:(QueryRecordInfo *)info;
@end
