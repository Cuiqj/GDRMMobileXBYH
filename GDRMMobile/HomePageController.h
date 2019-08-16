//
//  HomePageController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgSyncViewController.h"
#import "LoginViewController.h"
#import "LogoutViewController.h"

@interface HomePageController : UIViewController<UINavigationControllerDelegate,OrgSetDelegate,UserSetDelegate,LogOutDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelOrgShortName;
@property (weak, nonatomic) IBOutlet UIButton *BrgCavBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentUser;
@property (weak, nonatomic) IBOutlet UIButton *UIGouzhaowujianchabutton;
- (IBAction)btnLogOut:(UIBarButtonItem *)sender;
- (IBAction)btnServicesCheck:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *CarcheckBtn;


@property (weak, nonatomic) IBOutlet UIButton *BridgeSafeBtn;
- (IBAction)bridgeSafeClick:(id)sender;

- (IBAction)btnCarcheck:(id)sender;
- (IBAction)btnYZDN:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnToMapView;

@end
