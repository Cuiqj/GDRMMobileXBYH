//
//  CarCheckViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import <UIKit/UIKit.h>
#import "DateSelectController.h"
#import "ListSelectViewController.h"
@interface CarCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,DatetimePickerHandler,ListSelectPopoverDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableview;
@property (weak, nonatomic) IBOutlet UITextField *textcarno;
@property (weak, nonatomic) IBOutlet UITextField *textcheck_person;
@property (weak, nonatomic) IBOutlet UITextField *textcheck_time;
@property (weak, nonatomic) IBOutlet UITextField *textrecheck_person;
@property (weak, nonatomic) IBOutlet UITextField *textrecheck_time;
@property (weak, nonatomic) IBOutlet UITableView *carCheckRecordsTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *jieguoPicker;
@property (weak, nonatomic) IBOutlet UILabel *requirementLabel;
 
@property (weak, nonatomic) IBOutlet UITextView *textremark;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *myNewBtn;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UIButton *saveRecordBtn;

@property(nonatomic,strong)UIPopoverController *pickPopover;

- (IBAction)BtnSaveDetail:(id)sender;
- (IBAction)BtnSaveMain:(id)sender;
- (IBAction)BtnNewMain:(UIButton *)sender;

@end
