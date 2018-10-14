//
//  NSData+PrinterStatus.h
//  BabyBluetoothAppDemo
//
//  Created by sugar on 2018/10/14.
//  Copyright © 2018年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (PrinterStatus)
- (BOOL)canPrinter;
- (NSString *)tipPrinterStatusStr;
@end
