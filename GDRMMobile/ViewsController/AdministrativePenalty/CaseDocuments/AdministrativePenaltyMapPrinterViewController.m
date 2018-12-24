//
//  CaseMapPrinterViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "AdministrativePenaltyMapPrinterViewController.h"
#import "CaseMap.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "DateSelectController.h"
#import "UserInfo.h"

static NSString * const xmlName = @"AdministrativePenaltyNowRecordTable";

@interface AdministrativePenaltyMapPrinterViewController ()
@property (nonatomic,strong) CaseProveInfo * caseprove;


@end

@implementation AdministrativePenaltyMapPrinterViewController
NSInteger currentTag;
//@synthesize TextViewRemark = _textViewRemark;

@synthesize caseID = _caseID;
@synthesize maintainplanID = _maintainplanID;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
//    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, 870);
    self.view.frame = viewFrame;
    [super viewDidLoad];
    [self setTextFieldTag];
    [self loadPageInfo];
	// Do any additional setup after loading the view.
}
- (void)setTextFieldTag{
    self.TextAdress.tag = 555;
    self.TextStartDate.tag = 556;
    self.TextEndDate.tag = 557;
    self.TextProver1.tag = 558;
    self.TextProver2.tag = 559;
    self.TextRecorder.tag = 560;
}

- (void)viewDidUnload
{
    [self setTextAdress:nil];
    [self setTextStartDate:nil];
    [self setTextEndDate:nil];
    [self setTextProver1:nil];
    [self setTextProver2:nil];
    [self setTextProver1Number:nil];
    [self setTextProver2Number:nil];
    [self setTextRecorder:nil];
    [self setTextCitizenName:nil];
    [self setTextSex:nil];
    [self setTextCardNumber:nil];
    [self setTextCaseRelation:nil];
    [self setTextOrg_duty:nil];
    [self setTextTelephone:nil];
    [self setTextContactAdress:nil];
    [self setTextCarNumber:nil];
    [self setTextCarType:nil];
    [self setTextViewRemark:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)loadPageInfo{
//    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    self.caseprove = [CaseProveInfo proveInfoForCase:self.caseID];
    Citizen *citizen = [Citizen citizenByCaseID:self.caseID];
    self.TextAdress.text = self.caseprove.remark;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.TextStartDate.text = [dateFormatter stringFromDate:self.caseprove.start_date_time];
    self.TextEndDate.text = [dateFormatter stringFromDate:self.caseprove.end_date_time];
    self.TextProver1.text = [self.caseprove prover1];
    self.TextProver2.text = [self.caseprove prover2];
    self.TextProver1Number.text = [self.caseprove prover1_exelawid];
    self.TextProver2Number.text = [self.caseprove prover2_exelawid];
    self.TextRecorder.text = self.caseprove.recorder;
    
    self.TextCitizenName.text = citizen.party;
    self.TextSex.text = citizen.sex;
    self.TextCardNumber.text = citizen.card_no;
    self.TextCaseRelation.text = citizen.nexus;
    self.TextOrg_duty.text = [citizen nameAndprincipal_duty];
    self.TextTelephone.text = citizen.tel_number;
    self.TextContactAdress.text = citizen.address;
    
    self.TextViewRemark.text = self.caseprove.event_desc_found;
    
    
    
   
    //        self.labelDraftTime.text = [dateFormatter stringFromDate:caseMap.draw_time];
    
//    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath=[pathArray objectAtIndex:0];
//    NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseID];
//    mapPath=[documentPath stringByAppendingPathComponent:mapPath];
//    NSString *mapName = @"casemap.jpg";
//    NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        UIImage *imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
//        //            self.mapImage.image = imageFile;
//    }
//    
//    //        self.labelTime.text = [dateFormatter stringFromDate:caseInfo.happen_date];
//    NSString *locality = [[NSString alloc] initWithFormat:@"%@高速%@%02dKm+%03dm",[[AppDelegate App].projectDictionary objectForKey:@"cityname"] ,caseInfo.side,caseInfo.station_start.integerValue/1000,caseInfo.station_start.integerValue%1000];
//   
//   
//    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
//    if (caseProveInfo) {
//        //            self.labelProver.text = caseProveInfo.prover;
//    }
//    
//    //        self.labelCitizen.text = citizen.automobile_number;
}
- (void)pageSaveInfo{
//    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//    self.caseprove = [CaseProveInfo proveInfoForCase:self.caseID];
    Citizen *citizen = [Citizen citizenByCaseID:self.caseID];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.caseprove.end_date_time = [dateFormatter dateFromString:self.TextEndDate.text];
    self.caseprove.start_date_time = [dateFormatter dateFromString:self.TextStartDate.text];
    //执法人员及记录人在选择时保存
    citizen.automobile_number = self.TextCarNumber.text;
    citizen.automobile_pattern = self.TextCarType.text;
//    NSString * event_found = [self.TextViewRemark.text stringByReplacingOccurrencesOfString:@"在检查中发现：" withString:@""];
    self.caseprove.event_desc_found = self.TextViewRemark.text;

    
    
}
- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        Citizen * citizen = [Citizen citizenByCaseID:self.caseID];
        [self drawDateTable:xmlName withDataModel:citizen];
        [self drawDateTable:xmlName withDataModel:self.caseprove];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawStaticTable:@"AdministrativePenaltyMapTable"];
//        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseMap];
//        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseInfo];
//        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseProveInfo];
//        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:citizen];
//
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:filePath];
//    } else {
//        return nil;
//    }
}

-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
//    if (![filePath isEmpty]) {
//        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseMap];
//        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseInfo];
//        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseProveInfo];
//        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
//        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:citizen];
//
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:formatFilePath];
//    } else {
//        return nil;
//    }
    return nil;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
- (IBAction)SelectStartTime:(id)sender {
    currentTag = 556;   //  时间选择
    [self selectDateAndTime:sender];
}
- (IBAction)SelectEndTime:(id)sender {
    currentTag = 557;   //时间选择
    [self selectDateAndTime:sender];
}
- (IBAction)SelectProverOne:(id)sender {
    currentTag = 558;   //执法人员
    [self userSelect:sender];
}
- (IBAction)SelectProverTwo:(id)sender {
    currentTag = 559;   //执法人员
    [self userSelect:sender];
}
- (IBAction)SelcetRecorder:(id)sender {
    currentTag = 560;   //记录人
    [self userSelect:sender];
}
- (void)userSelect:(UITextField *)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}
- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (currentTag == 558) {
        self.TextProver1.text = name;
        if (self.TextProver2.text.length>0) {
            self.caseprove.prover=[NSString stringWithFormat:@"%@,%@",name,self.TextProver2.text];
        }else{
            self.caseprove.prover = name;
        }
        self.TextProver1Number.text = [UserInfo exelawIDForUserName:name];
    }else if (currentTag == 559){
        self.TextProver2.text = name;
        self.caseprove.prover=[NSString stringWithFormat:@"%@,%@",self.TextProver1.text,name];
        self.TextProver2Number.text = [UserInfo exelawIDForUserName:name];
    }else if (currentTag == 560){
        self.TextRecorder.text = name;
        self.caseprove.recorder = name;
    }
}


- (void)selectDateAndTime:(id)sender{
    UIStoryboard *MainStoryboard            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    DateSelectController *datePicker = [MainStoryboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate = self;
    datePicker.pickerType=1;
    // [datePicker showdate:self.textDate.text];
    UITextField* textField = (UITextField* )sender;
    CGRect frame = textField.frame;
    self.pickPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    [self.pickPopover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    datePicker.dateselectPopover=self.pickPopover;
}
- (void)setDate:(NSString *)date{
    NSDateFormatter *formator =[[NSDateFormatter alloc]init];
    [formator setLocale:[NSLocale currentLocale]];
    [formator setDateFormat:@"yyyy-MM-dd-HH-mm"];
    if (currentTag == 556) {
        self.caseprove.start_date_time = [formator dateFromString:date];
        [formator setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.TextStartDate.text = [formator stringFromDate:self.caseprove.start_date_time];
    }else if (currentTag == 557) {
        self.caseprove.end_date_time = [formator dateFromString:date];
        [formator setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.TextEndDate.text =[formator stringFromDate:self.caseprove.end_date_time];
    }
}

@end
