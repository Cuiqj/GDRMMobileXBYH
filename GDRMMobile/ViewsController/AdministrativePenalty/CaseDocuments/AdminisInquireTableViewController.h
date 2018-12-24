//
//  AdminisInquireTableViewController.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/8/3.
//
//违章询问笔录
#import "CasePrintViewController.h"

@interface AdminisInquireTableViewController : CasePrintViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIPopoverController *pickerPopover;

@property (weak, nonatomic) IBOutlet UITextField *TextStartdate;
@property (weak, nonatomic) IBOutlet UITextField *TextEnddate;
- (IBAction)SelectDate:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *TextNumberInauire;
@property (weak, nonatomic) IBOutlet UITextField *TextRemarkaddress;
@property (weak, nonatomic) IBOutlet UITextField *Textinquirer_name;
@property (weak, nonatomic) IBOutlet UITextField *Textrecorder_name;
@property (weak, nonatomic) IBOutlet UITextField *Textanswerer_name;
@property (weak, nonatomic) IBOutlet UITextField *Textanswerer_type;
@property (weak, nonatomic) IBOutlet UITextField *TextSex;
@property (weak, nonatomic) IBOutlet UITextField *TextAge;
@property (weak, nonatomic) IBOutlet UITextField *TextCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *TextTelephone;
@property (weak, nonatomic) IBOutlet UITextField *TextOrgname_duty;
@property (weak, nonatomic) IBOutlet UITextField *Textaddress;
@property (weak, nonatomic) IBOutlet UITextField *textInquirenameshow;
@property (weak, nonatomic) IBOutlet UITextField *TextInquireSecond;
@property (weak, nonatomic) IBOutlet UITextField *textInquireexelawid;
@property (weak, nonatomic) IBOutlet UITextField *textInquireSecondexelawid;
@property (weak, nonatomic) IBOutlet UITextView *TextVieaskforInquireDesc;
@property (weak, nonatomic) IBOutlet UITextView *TextVieResultInquireDesc;

@property(nonatomic,strong)UIPopoverController *pickPopover;


- (IBAction)SelectUser:(id)sender;


@end
