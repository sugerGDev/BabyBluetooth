//
// Created by suger on 2018/10/8.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import "QueryRecordInfo.h"
#import <YYKit-fork/YYKit.h>

@implementation QueryRecordInfo {
    
}
- (instancetype)initWithQId:(NSString *)qId {
    self = [super init];
    if (self) {
        _qId = qId;
    }
    return self;
}
    
- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}
    
- (BOOL)isEqual:(QueryRecordInfo *)object {
    if (! [object isKindOfClass:self.class] ) {
        return NO;
    }
    
    NSString *target = [self.qId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *source = [object.qId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [target isEqualToString:source];
}
    
    
+ (NSString *)whc_SqliteVersion {
        return @"1.0.0";
}
    
+ (NSString *)whc_OtherSqlitePath {
    return [NSString stringWithFormat:@"%@/Library/per.db",NSHomeDirectory()];
}
    
    @end
