//
// Created by sugar on 2018/10/14.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <PrinterSDK/PrinterSDK.h>
#import "PeripheralConnectionInfo+Printer.h"
#import "BabyDefine.h"
#import "PeripheralConnMgr.h"
#import "NSData+PrinterStatus.h"
#import "SVProgressHUD.h"
@implementation PeripheralConnectionInfo (Printer)
- (void)connectPrinter {
    BabyLog(@" >>> 初始化打印机 ");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BabyLog(@" >>> 链接打印机 ");
        // 注册bloks
        [self _registerPrinterBlocks];
        
        // 链接蓝牙
        [self _connectPrinter];
        

    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//      
//    });
}



- (void)_registerPrinterBlocks {
    
    __weak __typeof(self)weakSelf = self;
    // 连接成功回调
    [self.dispatcher whenConnectSuccess:^{
            BabyLog(@" >>> 链接成功");
        // 检查蓝牙打印机状态
        [weakSelf _checkPrinterStatus];
    }];
    
    [self.dispatcher whenReceiveData:^(NSData *data) {
        
        if (data == nil) {
            BabyLog(@"打印纸状态为空");
            return ;
        }
        
        if (data.length != 1) {
            return;
        }
        
        if (data.canPrinter) {
            
        }else {
            BabyLog(@" >>> printer status is %@", data.tipPrinterStatusStr);
            [SVProgressHUD showErrorWithStatus:data.tipPrinterStatusStr];
        }
        
        
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


- (void)_checkPrinterStatus {
    PTCommandCPCL *cpcl =  [[PTCommandCPCL alloc]init];
    [cpcl cpclGetPaperStatus];
    [self.dispatcher sendData:cpcl.cmdData];

}

@end
