//
//  QueryResultDetailViewController.h
//  BabyBluetoothAppDemo
//
//  Created by suger on 2018/10/8.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QueryRecordInfo;
//搜索结果
@interface QueryResultDetailViewController : UIViewController
    @property(nonatomic, copy) QueryRecordInfo *info;
    
@end
