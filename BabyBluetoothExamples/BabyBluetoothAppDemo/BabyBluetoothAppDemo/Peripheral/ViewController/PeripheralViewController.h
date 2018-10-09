//
//  PeripheralViewContriller.h
//  BabyBluetoothDemo
//
//  Created by 刘彦玮 on 15/8/4.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
//#import "PeripheralInfo.h"
//#import "CharacteristicViewController.h"

#import "PeripheralConnectionInfo.h"

@interface PeripheralViewController : UITableViewController

- (void)appendDeviceConnectionInfo:(PeripheralConnectionInfo *)connectionInfo;

@end
