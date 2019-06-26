//
//  RoadInspectViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewInspectRecordViewController.h"
#import "InspectionRecordCell.h"
#import "NewInspectionViewController.h"
#import "InspectionOutViewController.h"
#import "InspectionListViewController.h"
#import "InspectionCheckPickerViewController.h"
#import "DateSelectController.h"
#import "TrafficRecord.h"
#import "AttachmentViewController.h"
//#import "DynamicInfoViewController.h"
#import "RoadWayClosed.h"
#import "BaoxianCaseViewController.h"
#import "ServiceCheck.h"
//#import "AddNewInspectRecordViewController.h"

typedef enum {
    kRecord = 0,
    kPath
} InpectionState;

@interface RoadInspectViewController : UIViewController<DatetimePickerHandler,InspectionListDelegate,UITableViewDataSource,UITableViewDelegate,InspectionHandler,UITextFieldDelegate,InspectionPickerDelegate, UIAlertViewDelegate>
//UITextViewDelegate
- (IBAction)btnSaveRemark:(UIButton *)sender;       //保存
- (IBAction)btnDeliver:(UIButton *)sender;          //交班
- (IBAction)segSwitch:(id)sender;                   //选择过站记录
- (IBAction)selectionStation:(id)sender;            //出发站点
- (IBAction)selectTime:(id)sender;                  //过站时间
- (IBAction)selectCheckStatus:(id)sender;           //往站点方向巡查

@property (weak, nonatomic) IBOutlet UIView *pathView;
@property (weak, nonatomic) IBOutlet UILabel *labelInspectionInfo;
@property (weak, nonatomic) IBOutlet UITextView *textViewRemark;
@property (weak, nonatomic) IBOutlet UITableView * tableRecordList;
@property (weak, nonatomic) IBOutlet UILabel *labelRemark;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonAddNew;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonFujian;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonSave;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonDeliver;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inspectionSeg;
@property (weak, nonatomic) IBOutlet UITextField *textCheckTime;
@property (weak, nonatomic) IBOutlet UITextField *textStationName;
@property (weak, nonatomic) IBOutlet UITextField *textCheckStatus;
//本班次巡查信息汇总    按钮
@property (weak, nonatomic) IBOutlet UIButton *EveryShiftButton;


@property (nonatomic,retain) NSString *inspectionID;
//@property (nonatomic,retain) NSString *inspectRecordID;
@property (nonatomic,assign) InpectionState state;


@property (weak, nonatomic) IBOutlet UILabel *inspectionRecordlabel;  //实际巡查路线
@property (weak, nonatomic) IBOutlet UITextField *inspectionRecordtext;  //路线
- (IBAction)inspectionRecordtextButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *inspectionRecordtextButton;    //生成
@property (weak, nonatomic) IBOutlet UITextField *roadsegmentText;          //路段
- (IBAction)roadsegmentTextClick:(id)sender;

@property (nonatomic,retain) UIStoryboardSegue * mysegue;
- (IBAction)btnInpectionList:(id)sender;
- (IBAction)btnAddNew:(id)sender;
- (IBAction)btnToFujian:(id)sender;
//本班次巡查信息汇总
- (IBAction)pushtoEveryShiftController:(id)sender;

- (void) createRecodeByCaseID:(NSString *)inspectRecordID;
- (void) createRecodeByShiGongCheckID:(NSString *)shiGongCheckID;
- (void) createRecodeByShiGongCheckID:(NSString *)shiGongCheckID;
- (void) createRecodeByShiGongCheck:(NSString *)shiGongCheckID withRemark:(NSString *)Remark;
- (void) setxxx:(NSString *)inspectRecordID;
- (void) createRecodeByTrafficRecord:(TrafficRecord *)trafficRecord;
- (void) createRecodeByDynamicInfo:(RoadWayClosed *)DynamicInfo;
- (void) createRecodeByBaoxianCase:(NSString  *)baoxianCaseId;
- (void) createRecodeByServicesCheck:(ServiceCheck  *)ServicesCheck;
@end
