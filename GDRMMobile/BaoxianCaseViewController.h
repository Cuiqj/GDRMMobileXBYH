//
//  BaoxianCaseViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/2/28.
//
//

#import <UIKit/UIKit.h>
#import "DataModelsHeader.h"
#import "AccInfoBriefViewController.h"
#import "CitizenInfoBriefViewController.h"
#import "DeformInfoBriefViewController.h"
#import "DeformationInfoViewController.h"
#import "InquireInfoViewController.h"
#import "InquireInfoBriefViewController.h"
#import "PaintBriefViewController.h"
#import "CasePaintViewController.h"
#import "CasePaintViewController.h"
#import "CaseDocumentsViewController.h"
#import "CaseListViewController.h"
#import "CaseIDHandler.h"
#import "CasePhoto.h"
#import "UserInfo.h"
#import "CaseInfoPickerViewController.h"

#import "CitizenListViewController.h"
#import "CaseDescListViewController.h"
#import "DateSelectController.h"

#import "CaseDocuments.h"
#import "RoadSegmentPickerViewController.h"
#import "RoadInspectViewController.h"
@class RoadInspectViewController;

@interface BaoxianCaseViewController :  UIViewController<UITextFieldDelegate,CaseIDHandler,DatetimePickerHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,RoadSegmentPickerDelegate,ReloadPaintDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UITextField *textCasemark2;
@property (weak, nonatomic) IBOutlet UITextField *textCasemark3;
@property (weak, nonatomic) IBOutlet UITextField *textWeatheer;
@property (weak, nonatomic) IBOutlet UITextField *textHappenDate;
@property (weak, nonatomic) IBOutlet UITextField *textRoadSegment;
@property (weak, nonatomic) IBOutlet UITextField *textSide;
@property (weak, nonatomic) IBOutlet UITextField *textPlace;
@property (weak, nonatomic) IBOutlet UITextField *textStationStartM;

@property (weak, nonatomic) IBOutlet UITextField *textStationStartKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationEndKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationEndM;
@property (weak, nonatomic) IBOutlet UITextField *textcase_type;
@property (weak, nonatomic) IBOutlet UITextField *textinsurance_no;
@property (weak, nonatomic) IBOutlet UITextField *textCaseDesc;
@property (weak, nonatomic) IBOutlet UITextField *textinsurance_company;
@property (weak, nonatomic) IBOutlet UILabel *labelPhotoIndex;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segInfoPage;
@property (weak, nonatomic) IBOutlet UIScrollView *infoView;
@property (weak, nonatomic) IBOutlet UITableView *docListView;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonEdit;            //编辑
@property (weak, nonatomic) IBOutlet UIButton *uiButtonCamera;      //相机。   可能现场照片
@property (weak, nonatomic) IBOutlet UIButton *uiButtonPickFromLibrary;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonSave;           //保存。
@property (weak, nonatomic) IBOutlet UIButton *uiButtonNewCase;         //新案件       新增



//@property (weak,nonatomic) IBOutlet UITableView *testList;

@property (nonatomic,retain) NSString *caseID;
@property (nonatomic,retain) CaseInfo *caseInfo;
@property (nonatomic,retain) Citizen  *citizenInfo;

//@property (nonatomic,retain) id infoPageVC;
@property (nonatomic,retain) AccInfoBriefViewController *accInfoBriefVC;
@property (nonatomic,retain) CitizenInfoBriefViewController *citizenInfoBriefVC;
@property (nonatomic,retain) DeformInfoBriefViewController *deformInfoVC;
@property (nonatomic,retain) InquireInfoBriefViewController *inquireInfoBriefVC;
@property (nonatomic,retain) PaintBriefViewController *paintBriefVC;

@property (nonatomic,assign) BOOL needsMove;

@property (nonatomic, retain) NSString *inspectionID;
@property (nonatomic, assign) RoadInspectViewController *roadInspectVC;

@property (weak, nonatomic) IBOutlet UISwitch *SwitchNumber;


- (IBAction)btnImageFromCamera:(id)sender;
- (IBAction)btnImageFromLibrary:(id)sender;
- (IBAction)btnClickToEditor:(id)sender;            //编辑赔补偿清单
- (IBAction)btnNewCase:(id)sender;                  //新增
- (IBAction)selectWeather:(id)sender;
- (IBAction)selectRoadSegmet:(UITextField *)sender;
- (IBAction)selectRoadSide:(UITextField *)sender;
- (IBAction)selectRoadPlace:(UITextField *)sender;
- (IBAction)selectAutoMobilePattern:(id)sender;
- (IBAction)selectBadDesc:(id)sender;
- (IBAction)selectCitizen:(id)sender;
- (IBAction)selectCaseDesc:(id)sender;
- (IBAction)selectDateAndTime:(id)sender;
- (IBAction)btnSaveCaseInfo:(id)sender;         //保存信息
- (IBAction)btnPreviousCase:(id)sender;         //历史案件

- (IBAction)SwitchOnOrOff:(id)sender;


- (IBAction)selectCaseType:(id)sender;
- (IBAction)selectInsCompany:(id)sender;

- (IBAction)changeInfoPage:(UISegmentedControl *)sender;

-(void)saveCaseInfoForCase:(NSString *)caseID;
-(void)loadCaseInfoForCase:(NSString *)caseID;

-(void)saveCitizenInfoForCase:(NSString *)caseID andAutoNumber:(NSString *)aAutoNumber;
-(void)loadCitizenInfoForCase:(NSString *)caseID andAutoNumber:(NSString *)aAutoNumber;

-(void)saveCaseProveInfoForCase:(NSString *)caseID;
-(void)loadCaseProveInfoForCase:(NSString *)caseID;
-(BOOL)checkCaseBaseInfo;


@end
