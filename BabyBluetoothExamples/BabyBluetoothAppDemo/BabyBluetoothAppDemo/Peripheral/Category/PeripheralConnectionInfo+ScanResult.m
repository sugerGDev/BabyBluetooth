//
// Created by suger on 2018/10/9.
// Copyright (c) 2018 刘彦玮. All rights reserved.
//

#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>
#import "PeripheralConnectionInfo+ScanResult.h"
#import "QueryRecordInfo.h"
#import "QueryDatabaseMgr.h"
#import "SVProgressHUD.h"
#import "QueryResultDetailViewController.h"
#import "QMUIHelper.h"
#import "WHC_ModelSqlite.h"
#import <QMUIKit/QMUIKit.h>


@implementation PeripheralConnectionInfo (ScanResult)


- (void)doScanActionWithData:(NSData *)data {
    
    if (data == nil) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (!self.scanContent) {
        self.scanContent = [[NSMutableString alloc]initWithCapacity:10];
    }


    NSString *valueStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    if (![self.scanContent isEqualToString:valueStr]) {
        // 之前的内容和原来的内容不同的时候
        [self.scanContent appendFormat:@"%@",valueStr];
    }

    [self performSelector:@selector(_showScanResult:) withObject:self.scanContent afterDelay:.5f];

}


- (void)_showScanResult:(NSString *)result {

    if (result.length == 0) {
        return;
    }
    
    [SVProgressHUD showInfoWithStatus:result];
    [self _saveQueryResult:result];
    self.scanContent = nil;
}


#pragma mark - 保存到本地
- (void)_saveQueryResult:(NSString *)result {

    NSArray *array = [WHCSqlite query:QueryRecordInfo.class where:[NSString stringWithFormat:@"qId = '%@' ",result]];
    QueryRecordInfo *info = nil;

    if  (array.count ){

        info = array.firstObject;
        // 存在之前扫描的内容，则把内容放到第一位
        NSMutableArray *all = [WHCSqlite query:QueryRecordInfo.class].mutableCopy;
        NSInteger rId = [all indexOfObject:array.firstObject];
        if (rId != NSNotFound) {
            [all exchangeObjectAtIndex:0 withObjectAtIndex:rId];
        }
        [WHCSqlite clear:QueryRecordInfo .class];
        [WHCSqlite inserts:all];


    } else {
        // 在后头插入数据
        info = [QueryDatabaseMgr.sharedInstance.source objectForKey:result];
        if (!info) {
            info = [[QueryRecordInfo alloc]initWithQId:result];
        }
        [WHCSqlite insert:info];
    }



    if ([self _doCheckVisibleViewControllerWithInfo:info] ){
        return;
    }

    QueryResultDetailViewController *detail = [[QueryResultDetailViewController alloc]init];
    detail.info = info;
    [QMUIHelper.visibleViewController.navigationController pushViewController:detail animated:YES];

}

- (BOOL)_doCheckVisibleViewControllerWithInfo:(QueryRecordInfo *)info {

    UINavigationController *nav = QMUIHelper.visibleViewController.navigationController;
    if (
            [nav.visibleViewController isKindOfClass:QueryResultDetailViewController.class] ) {
        QueryResultDetailViewController *detail = (QueryResultDetailViewController *)nav.visibleViewController;
        detail.info = info;
        return YES;
    }
    return NO;
}


@end
