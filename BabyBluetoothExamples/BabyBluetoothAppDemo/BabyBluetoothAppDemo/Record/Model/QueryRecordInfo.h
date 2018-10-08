//
// Created by suger on 2018/10/8.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>

/**
 * 保存查询记录
 * 反显查询记录
 */
@interface QueryRecordInfo : NSObject<NSCopying,WHC_SqliteInfo>
//查询记录二维码或者条形码
@property (nonatomic, copy)NSString *qId;
    // 批次号
@property(nonatomic, copy) NSString *batchId;
//日期
@property(nonatomic, copy) NSString *date;
// 厂家
@property(nonatomic, copy) NSString *merchant;
// 产品名
@property(nonatomic, copy) NSString *productName;

- (instancetype)initWithQId:(NSString *)qId;

@end
