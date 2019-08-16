//
//  ShiGongCheckViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/13.
//
//


#import <UIKit/UIKit.h>
#import "InspectionConstructionViewController.h"
#import "InspectionConstruction.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"
#import "CaseInfoPickerViewController.h"
#import "CasePrintViewController.h"
#import "ShiGongCheckViewController.h"
#import "MaintainPlanPickerViewController.h"
#import "RoadInspectViewController.h"
@interface ShiGongCheckViewController :UIViewController<UITextFieldDelegate,CaseIDHandler,UserPickerDelegate,DatetimePickerHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,MaintainPlanPickerDelegate>
//@property (weak, nonatomic) IBOutlet UIButton *uiBtnSave;
//@property (weak, nonatomic) IBOutlet UIButton *uiBtnAdd;
//@property (weak, nonatomic) IBOutlet UIButton * uiBtnFujian;
@property (weak, nonatomic) IBOutlet UITableView * tableCloseList;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollContent;
@property (weak, nonatomic) IBOutlet UITextField * endDate;
@property (weak, nonatomic) IBOutlet UITextField * stattdate;
@property (weak, nonatomic) IBOutlet UITextField * Fuzeren;
@property (weak, nonatomic) IBOutlet UITextField * tel_phone;

@property (weak, nonatomic) IBOutlet UITextField *textprojrctcode;
//施工检查备注
@property (weak, nonatomic) IBOutlet UITextView *textcheck_remark;
@property (weak, nonatomic) IBOutlet UITextField *textShiGongDanWei;
@property (weak, nonatomic) IBOutlet UITextField *textDidian;
//施工项目
@property (weak, nonatomic) IBOutlet UITextField *textProject;
//封路情况
@property (weak, nonatomic) IBOutlet UITextField *textchedao;
- (IBAction)selectProject:(UITextField *)sender;

//跳转的巡查ID
@property (nonatomic, retain) NSString *inspectionID;
//所选施工项目的封道情况
@property (nonatomic, retain) NSString *close_desc;

//  巡查情况要用到   施工检查要用到
@property (nonatomic, assign) RoadInspectViewController *roadInspectVC;

@property (weak, nonatomic) IBOutlet UIButton *DailyRoadWorkCheck;
- (IBAction)DailyRoadWorkCheckClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SpecialProject;
- (IBAction)SpecialProjectCheckClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *ButtonfuJian;

//@property (retain, nonatomic) NSURL *pdfFormatFileURL;
//@property (retain, nonatomic) NSURL *pdfFileURL;

@end

