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
 
    self.batchTxtField.text = self.info.batchId;
    self.merchantTxtField.text = self.info.merchant;
    self.dateTxtField.text = self.info.date;
    self.productTxtField.text = self.info.productName;
}
#pragma mark - Action
    
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
    
    NSArray <QueryRecordInfo *>*array = [WHCSqlite query:QueryRecordInfo.class where:[NSString stringWithFormat:@"qId = '%@' ",self.info.qId]];
    
    
    QueryRecordInfo *source = array.firstObject.copy;
    source.batchId = self.info.batchId;
    source.qId = self.info.qId;
    
    NSString *m = nil;
    
    {
        m = [self.merchantTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (m.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"厂家不能为空"];
            return;
        }
        source.merchant = m;
    }
    
    
    {
        m = [self.dateTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (m.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"生产日期不能为空"];
            return;
        }
        source.date = m;
    }
    
    
    {
        m = [self.productTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (m.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"名称不能为空"];
            return;
        }
        source.productName = m;
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
    
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    @end
