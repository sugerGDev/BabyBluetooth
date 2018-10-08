//
// Created by suger on 2018/10/8.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import "QueryDatabaseMgr.h"
#import "QueryRecordInfo.h"
#import "NSObject+YYModel.h"


@implementation QueryDatabaseMgr {

@private
    NSDictionary *_source;
}
@synthesize source = _source;

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (NSDictionary *)source {
    if (!_source) {
        
        NSString *path = [NSBundle.mainBundle pathForResource:@"database" ofType:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];

        _source = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];

        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSDictionary * obj, BOOL *stop) {
            [_source setValue:[QueryRecordInfo modelWithDictionary:obj] forKey:key];
        }];

    }
    return _source;
}


@end
