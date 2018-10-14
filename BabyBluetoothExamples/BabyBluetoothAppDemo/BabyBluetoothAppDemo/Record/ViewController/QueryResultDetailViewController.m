//
//  QueryResultDetailViewController.m
//  BabyBluetoothAppDemo
//
//  Created by suger on 2018/10/8.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

#import "QueryResultDetailViewController.h"
#import "QueryRecordInfo.h"
#import "SVProgressHUD.h"
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>
#import "PeripheralConnMgr.h"
#import "PeripheralConnectionInfo+Printer.h"


@interface QueryResultDetailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *batchTxtField;
@property (weak, nonatomic) IBOutlet UITextField *merchantTxtField;
@property (weak, nonatomic) IBOutlet UITextField *dateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *productTxtField;
@property(nonatomic, assign) BOOL isModified;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation QueryResultDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isModified = (self.title.length == 0);
    self.title =  self.isModified ?    @"扫描结果" : self.title ;
    self.backBtn.hidden = self.isModified;
    self.cancelBtn.hidden = !self.isModified;
    self.saveBtn.hidden = !self.isModified;
    
    self.merchantTxtField.userInteractionEnabled = self.isModified;
    self.dateTxtField.userInteractionEnabled = self.isModified;
    self.productTxtField.userInteractionEnabled = self.isModified;
    
    [self appendData];
    [self _setRightNavItem];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter
- (void)setInfo:(QueryRecordInfo *)info {
    _info = info;
    [self appendData];
}

- (void)appendData {
    
    self.batchTxtField.text = self.info.qId;
    self.merchantTxtField.text = self.info.merchant;
    self.dateTxtField.text = self.info.date;
    self.productTxtField.text = self.info.productName;
}

- (void)_setRightNavItem {
    // 导航右侧菜单
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"打印" style:(UIBarButtonItemStylePlain) target:self action:@selector(navRightBtnClick:)];
    NSLog(@"self.navigationItem.rightBarButtonItem  is %@",self.navigationItem.rightBarButtonItem );
}
#pragma mark - Action
- (void)navRightBtnClick:(id)aSnder {
    
    
    QueryRecordInfo *source = nil;
    NSArray <QueryRecordInfo *>*array = [WHCSqlite query:QueryRecordInfo.class where:[NSString stringWithFormat:@"qId = '%@' ",self.info.qId]];
    source = array.firstObject.copy;
    
    if (source == nil) {
        source = [[QueryRecordInfo alloc]initWithQId:self.info.qId];
    }else {
        source.qId = self.info.qId;
    }
    
    
    if (! [self _canSave:source] ) {
        return;
    }
    
    PeripheralConnectionInfo *printerConnInfo = [PeripheralConnMgr.sharedInstance printerConntionInfo];
    if (!printerConnInfo) {
        [SVProgressHUD showErrorWithStatus:@"还未链接蓝牙打印机"];
        return;
    }
    
    [printerConnInfo print:source];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.productTxtField]) {
        [self.merchantTxtField becomeFirstResponder];
    }else if ([textField isEqual:self.merchantTxtField]) {
        [self.dateTxtField becomeFirstResponder];
    }else {
        [UIApplication.sharedApplication.keyWindow endEditing:YES];
    }
    
    return YES;
}

- (IBAction)doSaveAction:(id)sender {
    
    QueryRecordInfo *source = nil;
    NSArray <QueryRecordInfo *>*array = [WHCSqlite query:QueryRecordInfo.class where:[NSString stringWithFormat:@"qId = '%@' ",self.info.qId]];
    source = array.firstObject.copy;
    
    if (source == nil) {
        source = [[QueryRecordInfo alloc]initWithQId:self.info.qId];
    }else {
        source.qId = self.info.qId;
    }
    
    if (! [self _canSave:source] ) {
        return;
    }
    
    [WHCSqlite delete:QueryRecordInfo.class where:[NSString stringWithFormat:@"qId = '%@' ",self.info.qId]];
    [WHCSqlite insert:source];
    [SVProgressHUD showInfoWithStatus:@"修改成功"];
    [self doCancelAction:nil];
    
}




- (IBAction)doCancelAction:(id)sender {
    
    
    [ self.navigationController popViewControllerAnimated:YES ];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIApplication.sharedApplication.keyWindow endEditing:YES];
}

#pragma mark - private
- (BOOL)_canSave:(QueryRecordInfo *)source{
    
    
    NSString *m = nil;
    
    {
        m = [self.merchantTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (m.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"厂家不能为空"];
            return NO;
        }
        source.merchant = m;
    }
    
    
    {
        m = [self.dateTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (m.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"生产日期不能为空"];
            return NO;
        }
        source.date = m;
    }
    
    
    {
        m = [self.productTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (m.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"名称不能为空"];
            return NO;
        }
        source.productName = m;
    }
    
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
