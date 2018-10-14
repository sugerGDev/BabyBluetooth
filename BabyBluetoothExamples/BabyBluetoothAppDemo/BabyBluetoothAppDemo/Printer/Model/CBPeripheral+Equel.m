//
// Created by sugar on 2018/10/14.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import "CBPeripheral+Equel.h"


@implementation CBPeripheral (Equel)
- (BOOL)isEqual:(CBPeripheral *)object {

    if  (![object isKindOfClass:CBPeripheral.class]) {
        return NO;
    }

    return [object.name isEqualToString:self.name];
}

- (BOOL)isPrinter {
    //使用特定型号
    return  [self.name containsString:@"HM-A300"];
}
@end