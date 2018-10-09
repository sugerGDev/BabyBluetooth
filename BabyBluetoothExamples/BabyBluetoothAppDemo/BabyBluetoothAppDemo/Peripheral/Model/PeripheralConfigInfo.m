//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import "PeripheralConfigInfo.h"


@implementation PeripheralConfigInfo {

}
- (instancetype)initWithServiceId:(NSString *)serviceId characteristicId:(NSString *)characteristicId {
    self = [super init];
    if (self) {
        _serviceId = [serviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _characteristicId = [characteristicId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        NSAssert( ([_serviceId isKindOfClass:NSString .class] && _serviceId.length != 0), @"请配置serviceId字段，初始化失败");
        NSAssert( ([_characteristicId isKindOfClass:NSString .class] && _characteristicId.length != 0), @"请配置characteristicId字段，初始化失败");
    }

    return self;
}

@end
