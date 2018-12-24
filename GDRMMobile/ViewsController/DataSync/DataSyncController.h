//
//  ServerSettingController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OrgSyncViewController.h"

#import <UIKit/UIKit.h>

#import "DataDownLoad.h"
#import "DataUpLoad.h"

@interface  DataSyncController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *uibuttonInit;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonReset;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonUpload;
@property (weak, nonatomic) IBOutlet UILabel *versionName;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonResetForm;
@property (weak, nonatomic) IBOutlet UIButton *UpdateVersionBtn;
@property (weak, nonatomic) IBOutlet UIButton *ChangeOrganization;

@property (weak, nonatomic) IBOutlet UILabel *versionTime;
- (IBAction)btnInitData:(id)sender;
- (IBAction)btnUpLoadData:(UIButton *)sender;
- (IBAction)btnUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *setServerBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateDocFormatBtn;

- (IBAction)btnUpdateDocFormat:(UIButton *)sender;       //更新文书
- (IBAction)Changeorganization:(id)sender;               //切换机构

@end
