//
//  CaseMapPrinterViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//现场笔录打印

#import "CasePrintViewController.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"

@interface AdministrativePenaltyMapPrinterViewController : CasePrintViewController<UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,DatetimePickerHandler,UserPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TextAdress;
@property (weak, nonatomic) IBOutlet UITextField *TextStartDate;
@property (weak, nonatomic) IBOutlet UITextField *TextEndDate;
@property (weak, nonatomic) IBOutlet UITextField *TextProver1;
@property (weak, nonatomic) IBOutlet UITextField *TextProver2;
@property (weak, nonatomic) IBOutlet UITextField *TextProver1Number;
@property (weak, nonatomic) IBOutlet UITextField *TextProver2Number;
@property (weak, nonatomic) IBOutlet UITextField *TextRecorder;
@property (weak, nonatomic) IBOutlet UITextField *TextCitizenName;
@property (weak, nonatomic) IBOutlet UITextField *TextSex;
@property (weak, nonatomic) IBOutlet UITextField *TextCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *TextCaseRelation;     //与案件关系
@property (weak, nonatomic) IBOutlet UITextField *TextOrg_duty;
@property (weak, nonatomic) IBOutlet UITextField *TextTelephone;
@property (weak, nonatomic) IBOutlet UITextField *TextContactAdress;   //联系地址
@property (weak, nonatomic) IBOutlet UITextField *TextCarNumber;
@property (weak, nonatomic) IBOutlet UITextField *TextCarType;
@property (weak, nonatomic) IBOutlet UITextView *TextViewRemark;       //event_desc_found在检查中发现

@property (nonatomic,strong) UIPopoverController *pickPopover;
@property (nonatomic,strong) UIPopoverController *pickerPopover;

- (IBAction)SelectStartTime:(id)sender;
- (IBAction)SelectEndTime:(id)sender;
- (IBAction)SelectProverOne:(id)sender;
- (IBAction)SelectProverTwo:(id)sender;
- (IBAction)SelcetRecorder:(id)sender;
- (void)setDate:(NSString *)date;



@end
