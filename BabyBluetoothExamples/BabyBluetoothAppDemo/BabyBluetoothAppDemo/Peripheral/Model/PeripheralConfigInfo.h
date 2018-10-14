//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PTPrinter;


UIKIT_EXTERN NSString *const  kServiceIdKey;

UIKIT_EXTERN NSString *const  kCharacteristicIdKey;

/**
 * 每个设备链接配置对象
 */
@interface PeripheralConfigInfo : NSObject

@property(nonatomic, copy) NSString *serviceId;
@property(nonatomic, copy) NSString *characteristicId;
@property(nonatomic, strong)PTPrinter *printer;


- (instancetype)init NS_UNAVAILABLE;
// 链接扫描枪
- (instancetype)initWithServiceId:(nullable NSString *)serviceId characteristicId:(NSString *)characteristicId;
// 链接蓝牙打印机
- (instancetype)initWithPrinter:(PTPrinter *)printer;
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
