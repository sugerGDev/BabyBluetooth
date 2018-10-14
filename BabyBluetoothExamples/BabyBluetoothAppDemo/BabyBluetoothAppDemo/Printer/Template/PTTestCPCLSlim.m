//
//  PTTestCPCLSlim.m
//  BabyBluetoothAppDemo
//
//  Created by sugar on 2018/10/14.
//  Copyright © 2018年 刘彦玮. All rights reserved.
//

#import "PTTestCPCLSlim.h"
#import <PrinterSDK/PTCommandCPCL.h>

@implementation PTTestCPCLSlim
+ (NSData *)printerBatchNo:(NSString *)batchNo name:(NSString *)name merchant:(NSString *)merchant date:(NSString *)date {
    
    PTCommandCPCL *cmd = [[PTCommandCPCL alloc] init];
    [cmd cpclLabelWithOffset:0 hRes:200 vRes:200 height:400 quantity:1];
    //横划线
    [cmd cpclLineWithXPos:0 yPos:160 xEnd:600 yEnd:140 thickness:2];
    
    [cmd cpclSetBold:1];
    
    if (merchant.length) {
        [cmd cpclTextWithRotate:0 font:8 fontSize:0 x:15 y:50 text:merchant];
    }
    
    if (name.length) {
        [cmd cpclTextWithRotate:0 font:8 fontSize:0 x:16 y:90 text:name];
    }
    
    if (date.length) {
        [cmd cpclTextWithRotate:0 font:8 fontSize:0 x:16 y:130 text:date];
    }
    
    [cmd cpclSetBold:0];
    
    if (batchNo.length) {
        [cmd cpclBarcode:@"93" width:1 ratio:1 height:80 x:70 y:180 barcode:batchNo];
        [cmd cpclTextWithRotate:0 font:8 fontSize:0 x:155 y:280 text:batchNo];
        
    }
    
    
    ////    [cmd cpclForm]; // 如果需要打印一张后自A动定位到下一张标签上，请确认打印机时标签纸模式，然后加上这一行。
    [cmd cpclPrint];
    return cmd.cmdData;
}

@end
