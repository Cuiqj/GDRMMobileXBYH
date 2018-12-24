//
//  AdminisInquireTableViewController.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/8/3.
//
//违章询问笔录


#import "AdminisInquireTableViewController.h"
#import "CaseInquire.h"
#import "UserInfo.h"
#import "CaseInfo.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"


static NSString * const xmlName = @"AdminisInquireTable";
//AdminisInquireTable   故事版
@interface AdminisInquireTableViewController ()
@property (nonatomic,strong) CaseInquire * caseinquire;


@end

@implementation AdminisInquireTableViewController
NSInteger currentTag;
@synthesize caseID = _caseID;

- (void)viewDidLoad {
    [super setCaseID:self.caseID];
//    [self LoadPaperSettings:@"AdminstrativeInquireTable"];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    
    if (![self.caseID isEmpty]) {
//        Citizen * citizen = [Citizen citizenByCaseID:self.caseID];
        self.caseinquire = [CaseInquire inquireForCase:self.caseID];
        if (!self.caseinquire) {
            self.caseinquire = [CaseInquire newDataObjectWithEntityName:@"CaseInquire"];
            self.caseinquire.proveinfo_id = self.caseID;
        }
        [self generateDefaultInfo:self.caseinquire];
        [self pageLoadInfo];
    }
    [self createTextFieldtag];
    [super viewDidLoad];
}
- (void)createTextFieldtag{
    self.TextStartdate.tag = 667;
    self.TextEnddate.tag = 668;
    self.TextInquireSecond.tag = 666;
    self.textInquirenameshow.tag = 665;
    self.Textrecorder_name.tag = 664;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"AdminstrativeInquireTable"];
        Citizen * citizen = [Citizen citizenByCaseID:self.caseID];
        [self drawDateTable:@"AdminstrativeInquireTable" withDataModel:citizen];
        [self drawDateTable:@"AdminstrativeInquireTable" withDataModel:self.caseinquire];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
    
}
//保存数据
- (void)pageSaveInfo{
    self.caseinquire.inquiry_question =  self.TextVieaskforInquireDesc.text;
    self.caseinquire.inquiry_answer = self.TextVieResultInquireDesc.text;
    self.caseinquire.times = @([self.TextNumberInauire.text integerValue]);
    [[AppDelegate App] saveContext];
}
-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)generateDefaultInfo:(CaseInquire *)caseinquire{
//    Citizen * citizen = [Citizen citizenByCaseID:self.caseID];
//    CaseInquire * caseinquire = [CaseInquire inquireForCase:self.caseID andRelation:citizen.party];
    self.caseinquire.proveinfo_id = self.caseID;
    CaseInfo * caseinfo = [CaseInfo caseInfoForID:self.caseID];
    if (self.caseinquire.date_inquired==nil) {
        self.caseinquire.date_inquired = caseinfo.happen_date;
    }
    if (self.caseinquire.date_inquired_end==nil) {
        self.caseinquire.date_inquired_end = [NSDate date];
    }
    
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    if ([caseinquire.inquirer_name length] <= 0) {
        if (inspectorArray.count < 1) {
            // modified by cjl
            if (caseinquire.inquirer_name == nil) {
                caseinquire.inquirer_name = currentUserName;
            }
        } else {
            NSString *inspectorName = @"";
            for (NSString *name in inspectorArray) {
                if ([inspectorName isEmpty]) {
                    inspectorName = name;
                } else {
                    inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
                }
            }
            caseinquire.inquirer_name = inspectorName;
        }
    }
    
    if (caseinquire.recorder_name == nil) {
        caseinquire.recorder_name = currentUserName;
    }
    
    [[AppDelegate App] saveContext];
}

- (void)pageLoadInfo{
    self.TextNumberInauire.text = [self.caseinquire.times integerValue] ? [NSString stringWithFormat:@"%ld", [self.caseinquire.times integerValue]] : @"";
    Citizen * citizen = [Citizen citizenByCaseID:self.caseID];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.TextStartdate.text = [dateFormatter stringFromDate:self.caseinquire.date_inquired];
    self.TextEnddate.text = [dateFormatter stringFromDate:self.caseinquire.date_inquired_end];
    self.Textaddress.text = citizen.address;   //联系地址
    self.Textinquirer_name.text = [self.caseinquire prover1];
    self.Textrecorder_name.text = self.caseinquire.recorder_name;
    self.Textanswerer_name.text = citizen.party;
    self.Textanswerer_type.text = citizen.nexus;
    self.TextSex.text = citizen.sex;
    self.TextAge.text =  [NSString stringWithFormat:@"%ld",[citizen.age integerValue]];
    self.TextCardNumber.text = citizen.card_no;
    self.TextTelephone.text = citizen.tel_number;
    self.TextOrgname_duty.text = [citizen nameAndprincipal_duty];
    self.TextRemarkaddress.text = [self.caseinquire remark];    //地址
    self.textInquirenameshow.text = [self.caseinquire prover1];
    self.TextInquireSecond.text = [self.caseinquire prover2];
    self.textInquireexelawid.text = [self.caseinquire prover1_exelawid];
    self.textInquireSecondexelawid.text = [self.caseinquire prover2_exelawid];
    
    self.TextVieaskforInquireDesc.text = self.caseinquire.inquiry_question;
    self.TextVieResultInquireDesc.text = self.caseinquire.inquiry_answer;
}


- (IBAction)SelectDate:(id)sender {
    UITextField * field = (UITextField *)sender;
    currentTag = field.tag;
    UIStoryboard *MainStoryboard            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    DateSelectController *datePicker = [MainStoryboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=1;
    // [datePicker showdate:self.textDate.text];
    UITextField* textField = (UITextField* )sender;
    CGRect frame = CGRectMake(textField.frame.origin.x+100, textField.frame.origin.y, textField.frame.size.width-100, textField.frame.size.height);
    self.pickPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    [self.pickPopover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    datePicker.dateselectPopover=self.pickPopover;
}
- (void)setDate:(NSString *)date{
    NSDateFormatter *formator =[[NSDateFormatter alloc]init];
    [formator setLocale:[NSLocale currentLocale]];
    [formator setDateFormat:@"yyyy-MM-dd-HH-mm"];
    if (currentTag == 667) {
        self.caseinquire.date_inquired = [formator dateFromString:date];
        [formator setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.TextStartdate.text = [formator stringFromDate:self.caseinquire.date_inquired];
    }else if (currentTag == 668) {
        self.caseinquire.date_inquired_end = [formator dateFromString:date];
        [formator setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.TextEnddate.text =[formator stringFromDate:self.caseinquire.date_inquired_end];
    }
}
- (IBAction)SelectUser:(id)sender {
    UITextField * field = (UITextField *)sender;
    currentTag = field.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        UITextField * textfield = (UITextField *)sender;
        [self.pickerPopover presentPopoverFromRect:textfield.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}
- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (currentTag == 666) {
        self.TextInquireSecond.text = name;
        self.caseinquire.inquirer_name=[NSString stringWithFormat:@"%@,%@",self.textInquirenameshow.text,name];
        self.textInquireSecondexelawid.text = [UserInfo exelawIDForUserName:name];
    }else if (currentTag == 665){
        self.textInquirenameshow.text = name;
        if (self.TextInquireSecond.text.length>0) {
            self.caseinquire.inquirer_name=[NSString stringWithFormat:@"%@,%@",self.textInquirenameshow.text,name];
        }else{
            self.caseinquire.inquirer_name = self.textInquirenameshow.text;
        }
        self.textInquireexelawid.text = [self.caseinquire prover1_exelawid];
    }else if (currentTag == 664){
        self.Textrecorder_name.text = name;
        self.caseinquire.recorder_name = name;
    }
}

@end
