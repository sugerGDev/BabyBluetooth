//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 每个设备链接配置对象
 */
@interface PeripheralConfigInfo : NSObject

@property(nonatomic, copy) NSString *serviceId;
@property(nonatomic, copy) NSString *characteristicId;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithServiceId:(NSString *)serviceId characteristicId:(NSString *)characteristicId;

@end
