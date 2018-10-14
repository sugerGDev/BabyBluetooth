//
//  NSData+PrinterStatus.m
//  BabyBluetoothAppDemo
//
//  Created by sugar on 2018/10/14.
//  Copyright © 2018年 刘彦玮. All rights reserved.
//

#import "NSData+PrinterStatus.h"

@implementation NSData (PrinterStatus)
#pragma mark - Private
- (NSString *)toString {
    NSMutableString *str = [NSMutableString stringWithCapacity:2];
    NSUInteger length = self.length;
    char *bytes = malloc(sizeof(char) * length);
    [self getBytes:bytes length:length];
    
    for (int i = 0; i < length; i++){
        [str appendFormat:@"%02.2hhX", bytes[i]];
    }
    free(bytes);
    return str;
}

- (NSDictionary *)mapFlags {
    return @{
             @"00":@"准备打印",
             @"01":@"正在打印中",
             @"02":@"缺纸，请放纸",
             @"04":@"开盖有纸",
             @"06":@"开盖缺纸"
             };
}

#pragma mark - Public
- (BOOL)canPrinter {
  return   [self.toString isEqualToString:self.mapFlags.allKeys.firstObject];
}

- (NSString *)tipPrinterStatusStr{
    return [self.mapFlags objectForKey: self.toString];
}


@end
