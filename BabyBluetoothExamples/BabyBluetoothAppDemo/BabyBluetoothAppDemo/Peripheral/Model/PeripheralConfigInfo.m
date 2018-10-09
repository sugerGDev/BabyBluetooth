//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import "PeripheralConfigInfo.h"
#import "YYKit.h"


 NSString *const  kServiceIdKey = @"kServiceIdKey";

 NSString *const  kCharacteristicIdKey = @"kCharacteristicIdKey";





@implementation PeripheralConfigInfo {

}
- (instancetype)initWithServiceId:(nullable NSString *)serviceId characteristicId:(NSString *)characteristicId {
    self = [super init];
    if (self) {
        _serviceId = [serviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _characteristicId = [characteristicId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

//        NSAssert( ([_serviceId isKindOfClass:NSString .class] && _serviceId.length != 0), @"请配置serviceId字段，初始化失败");
        NSAssert( ([_characteristicId isKindOfClass:NSString .class] && _characteristicId.length != 0), @"请配置characteristicId字段，初始化失败");
    }

    return self;
}

- (BOOL)isScan {

    NSDictionary *config = self.class.scanConfigInfo;

    return ([self.serviceId isEqualToString:[config stringValueForKey:kServiceIdKey default:@""]] &&
            [self.characteristicId isEqualToString:[config stringValueForKey:kCharacteristicIdKey default:@""]]);
}

+ (NSDictionary *)scanConfigInfo {
    return @{
        kServiceIdKey : @"FEEA",
        kCharacteristicIdKey : @"2AA1",
    };
}


@end
