//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


UIKIT_EXTERN NSString *const  kServiceIdKey;

UIKIT_EXTERN NSString *const  kCharacteristicIdKey;

/**
 * 每个设备链接配置对象
 */
@interface PeripheralConfigInfo : NSObject

@property(nonatomic, copy) NSString *serviceId;
@property(nonatomic, copy) NSString *characteristicId;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithServiceId:(nullable NSString *)serviceId characteristicId:(NSString *)characteristicId;

/**
 * 判断是否扫描仪器
 * @return 是否扫描仪
 */
- (BOOL)isScan;

/**
 * 扫描仪服务ID和特征ID
 * @return kServiceIdKey 和 kCharacteristicIdKey组成的配置字典
 */
+ (NSDictionary *)scanConfigInfo;

@end
