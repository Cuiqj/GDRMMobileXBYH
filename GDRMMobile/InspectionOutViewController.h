//
//  InspectionOutViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-13.
//
//

#import <UIKit/UIKit.h>
#import "CheckItemDetails.h"
#import "CheckItems.h"
#import "TempCheckItem.h"
#import "DateSelectController.h"
#import "InspectionOutCheck.h"
#import "Inspection.h"
#import "InspectionHandler.h"
#import "InspectionRecord.h"

@interface InspectionOutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,DatetimePickerHandler>


- (IBAction)btnCancel:(UIBarButtonItem *)sender;            //取消     返回
- (IBAction)btnSave:(UIBarButtonItem *)sender;              //提交     保存
- (IBAction)SelectroadsegmentnameClick:(id)sender;      //路段选择

- (IBAction)btnOK:(UIBarButtonItem *)sender;            //确定
- (IBAction)btnDismiss:(UIBarButtonItem *)sender;       //隐藏
- (IBAction)textTouch:(UITextField *)sender;
//@property (nonatomic,retain) NSString * inspectionID;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITableView *tableCheckItems;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCheckItemDetails;
@property (weak, nonatomic) IBOutlet UITextField *textDetail;
@property (weak, nonatomic) IBOutlet UITextView *textDeliver;
@property (weak, nonatomic) IBOutlet UITextField *textEndDate;
@property (weak, nonatomic) IBOutlet UITextField *textMile;
@property (weak, nonatomic) IBOutlet UITextField *textroad;
@property (weak, nonatomic) IBOutlet UITextField *roadsegmentText;
@property (weak, nonatomic) IBOutlet UILabel *Labelroadsegment;
@property (weak, nonatomic) IBOutlet UILabel *Labeltime;
@property (weak, nonatomic) IBOutlet UILabel *LabelMile;



@property (weak, nonatomic) id<InspectionHandler> delegate;

@end
