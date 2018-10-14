//
// Created by sugar on 2018/10/14.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <PrinterSDK/PrinterSDK.h>
#import "PeripheralConnectionInfo+Printer.h"
#import "BabyDefine.h"
#import "PeripheralConnMgr.h"


@implementation PeripheralConnectionInfo (Printer)
- (void)connectPrinter {
    BabyLog(@" >>> 链接打印机 ");
    // 注册bloks
    [self _registerPrinterBlocks];
    
    // 链接蓝牙
    [self _connectPrinter];
    
    // 检查蓝牙打印机状态
    [self _checkPrinterStatus];
}

- (void)_registerPrinterBlocks {
    
    __weak __typeof(self)weakSelf = self;
    // 连接成功回调
    [self.dispatcher whenConnectSuccess:^{
            BabyLog(@" >>> 数据发送成功");
    }];
    
    // 出现连接错误时
    [self.dispatcher whenConnectFailureWithErrorBlock:^(PTBleConnectError error) {
        [PeripheralConnMgr.sharedInstance removePeripheralConnectionInfo:weakSelf];
    }];
    
    //  断开连接回调
    [self.dispatcher whenUnconnect:^(NSNumber *number) {
        [PeripheralConnMgr.sharedInstance removePeripheralConnectionInfo:weakSelf];
    }];
    
    // 数据发送成功
    [self.dispatcher whenSendSuccess:^(NSNumber *number) {
        BabyLog(@" >>> 数据发送成功");
    }];
    
    // 数据发送失败
    [self.dispatcher whenSendFailure:^{
          BabyLog(@" >>>  数据发送失败");
    }];
    
    // 数据发送进度
    [self.dispatcher whenSendProgressUpdate:^(NSNumber *number) {
        
    }];
    
    
    // 接收到打印机打印状态回调
    [self.dispatcher whenUpdatePrintState:^(PTPrintState state) {
        
    }];
}


- (void)_connectPrinter {
    [self.dispatcher connectPrinter:self.configInfo.printer];
}
@end
