//
//  ZLYHRoadAssetCheckViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/12.
//
//

#import <UIKit/UIKit.h>
#import "RoadInspectViewController.h"

@interface BrgAndCavCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableview;
@property (weak, nonatomic) IBOutlet UILabel     *startTimeLabel;

@property (weak, nonatomic) IBOutlet UIPickerView       *banciPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *doneorNotSeg;
@property (weak, nonatomic) IBOutlet UITableView        *detailTableView;
@property (weak, nonatomic) IBOutlet UIScrollView       *editView;

@property (weak, nonatomic) IBOutlet UITextField *textProblem;
@property (weak, nonatomic) IBOutlet UITextField *textSolution;
@property (weak, nonatomic) IBOutlet UITextField *textHongxian;
@property (weak, nonatomic) IBOutlet UITextView  *textRemark;
//无异常保存 按钮
@property (weak, nonatomic) IBOutlet UIButton    *saveBtn;
//桥涵检查    有异常 详细情况 按钮
@property (weak, nonatomic) IBOutlet UIButton *ExceptionHandlingBtn;

///////////////////////////
@property (weak, nonatomic) IBOutlet UILabel *textProject;
@property (weak, nonatomic) IBOutlet UITextField *texteast;
@property (weak, nonatomic) IBOutlet UITextField *textwest;
@property (weak, nonatomic) IBOutlet UILabel *textrequirement;
@property (weak, nonatomic) IBOutlet UITextField *texthandle;
@property (weak, nonatomic) IBOutlet UITextView *textremark;
@property (weak, nonatomic) IBOutlet UITextField *textrecordtime;
@property (weak, nonatomic) IBOutlet UITextField *textcheckuser;



///////////////////////////

@property (nonatomic,weak   ) NSString                  * inspectionID;
@property (nonatomic, strong) RoadInspectViewController *roadinspectVC;

@property (nonatomic,strong) UIPopoverController *picker;
//无异常保存 点击事件
- (IBAction)btnSave:(id)sender;
//桥涵检查    有异常 详细情况 跳转
- (IBAction)ExceptionHandlingClick:(id)sender;

- (IBAction)btnNewZhangliang:(UIButton *)sender;
//检查时间
- (IBAction)recordtimeClick:(id)sender;
//检查人
- (IBAction)userClcik:(id)sender;
//清空所选检查人
- (IBAction)CleartextUser:(id)sender;


@end
