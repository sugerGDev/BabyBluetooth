//
// Created by suger on 2018/10/8.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QueryRecordInfo;

@interface QueryDatabaseMgr : NSObject
+ (instancetype)sharedInstance;
@property(strong, nonatomic, readonly) NSDictionary <NSString *,QueryRecordInfo *>*source;
@end
