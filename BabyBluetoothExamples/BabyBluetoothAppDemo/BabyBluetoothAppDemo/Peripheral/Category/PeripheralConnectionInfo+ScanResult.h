//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeripheralConnectionInfo.h"

@interface PeripheralConnectionInfo (ScanResult)
- (void)doScanActionWithData:(NSData *)data;
@end
