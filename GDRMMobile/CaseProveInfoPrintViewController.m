//
//  CaseProveInfoPrintViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseProveInfoPrintViewController.h"
#import "RoadSegment.h"
#import "UserInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"
#import "CaseDeformation.h"

static NSString * const xmlName = @"ProveInfoTable";

@interface CaseProveInfoPrintViewController ()
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;
@property (nonatomic, retain) NSString *autoNumber;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@end

@implementation CaseProveInfoPrintViewController

@synthesize caseID = _caseID;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
//    NSLog(@"测试中xmlname------%@",xmlName);
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;

    if (![self.caseID isEmpty]) {
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];     //读取案号对应的勘验记录
        [self generateDefaultInfo:self.caseProveInfo];                         //根据案件记录，完整勘验信息
        [self pageLoadInfo];                                                    //加载信息
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"ProveInfoTable"];
        for (UITextView * aTextView in [self.view subviews]) {
            if ([aTextView isKindOfClass:[UITextView class]]) {
                [aTextView.text drawInRect:aTextView.frame withFont:aTextView.font];
            }
        }
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

//根据案件记录，完整勘验信息
//FIXME lxm
- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo{
    if (caseProveInfo.end_date_time==nil) {
        caseProveInfo.end_date_time=[NSDate date];
    }
    
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    if ([caseProveInfo.prover length] <= 0) {
        if (inspectorArray.count < 1) {
            // modified by cjl
            if (caseProveInfo.prover == nil) {
                caseProveInfo.prover = currentUserName;
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
            caseProveInfo.prover = inspectorName;
        }
    }
    
    if (caseProveInfo.recorder == nil) {
        caseProveInfo.recorder = currentUserName;        
    }

    if ([caseProveInfo.event_desc length] <= 0) {
        caseProveInfo.event_desc = [CaseProveInfo generateEventDescForCase:self.caseID];
    }

    [[AppDelegate App] saveContext];
}

- (IBAction)reFormEvetDesc:(UIButton *)sender {
    self.textevent_desc.text = [self generateOtherEventDescForCase];
}

- (NSString *)generateOtherEventDescForCase{
    [self pageSaveInfo];
    NSString *event_desc;
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    if (![citizen.party isEqualToString:@"事主逃逸"] && citizen.party) {    //路政案件
        event_desc = [CaseProveInfo generateEventDescForCase:self.caseID];
    }else{ //保险案件
        event_desc = [self generateEventDescForCase];
    }
    return event_desc;
    //    self.textevent_desc.text = [CaseProveInfo generateEventDescForCase:self.caseID];
}

/*add by lxm
 *2013.05.02
 */
- (void)pageLoadInfo{
    //案号
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    // 当事人
    Citizen *citizen = [Citizen citizenForCitizenName:self.caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
    NSLog(@"!!!!!!!!!!!!!!!-----%@-----",caseInfo);
    //案号 
    self.textMark2.text = caseInfo.case_mark2;
    self.textMark3.text = caseInfo.full_case_mark3;
//    NSLog(@"_________type:%@,--------insurance%@,company%@",caseInfo.text)
//    textcase_type;
//    @synthesize textinsurance_no;
//    @synthesize textinsurance_company

    //案由
    if(citizen){
        self.caseProveInfo.case_short_desc = [self.caseProveInfo.case_short_desc stringByReplacingOccurrencesOfString:@"交通事故造成" withString:@""];
        if(![self.caseProveInfo.case_short_desc containsString:@"交通事故造成"]){
            self.caseProveInfo.case_short_desc = [NSString stringWithFormat:@"交通事故造成%@",self.caseProveInfo.case_short_desc];
        }
    }
    
    // self.textcase_short_desc.text = [NSString stringWithFormat:@"%@%@", citizen.automobile_number , self.caseProveInfo.case_short_desc];
    self.textcase_short_desc.text =self.caseProveInfo.case_short_desc;
    
    //勘验时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textstart_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.start_date_time];
    self.textend_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
    
    //勘验场所
    self.caseProveInfo.remark = [self.caseProveInfo.remark stringByReplacingOccurrencesOfString:@"米"withString:@"m"];
    self.textprover_place.text = self.caseProveInfo.remark;
    
    
    //天气情况
    self.textorganizer.text = caseInfo.weater;
    
    //分割字符串
    NSArray *chunks = [self.caseProveInfo.prover componentsSeparatedByString: @","];

    if(chunks && [chunks count]>=3)
    {
        //勘验人1 单位职务    西部沿海高速公路路政大队路政管理员
        self.textprover1.text = [chunks objectAtIndex:0];
        self.textprover1_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:0]]];
        //勘验人2 单位职务
        self.textprover2.text = [chunks objectAtIndex:1];
        self.textprover2_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:1]]];
        //勘验人3 单位职务
        self.textprover3.text = [chunks objectAtIndex:2];
        self.textprover3_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:2]]];
    }else if(chunks && [chunks count]>=2){
        //勘验人1 单位职务    西部沿海高速公路路政大队路政管理员
        self.textprover1.text = [chunks objectAtIndex:0];
//        self.textprover1_duty.text = @"西部沿海高速公路路政大队路政管理员";
        self.textprover1_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:0]]];
        //勘验人2 单位职务
        self.textprover2.text = [chunks objectAtIndex:1];
//        self.textprover2_duty.text = @"西部沿海高速公路路政大队路政管理员";
        self.textprover2_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:1]]];
//        self.textprover2_duty.text=[[[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:1]] stringByReplacingOccurrencesOfString: @"二中队" withString: @""] stringByReplacingOccurrencesOfString: @"一中队" withString: @""] ;
//        self.textprover2_duty.text = [[self.textprover2_duty.text stringByReplacingOccurrencesOfString: @"三中队" withString: @""] stringByReplacingOccurrencesOfString: @"四中队" withString: @""] ;
    }else{
        self.textprover1.text = self.caseProveInfo.prover;
        self.textprover1_duty.text = [self.textprover1.text length] >0 ? [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:self.caseProveInfo.prover]] : @"";
        self.textprover2.text = self.caseProveInfo.secondProver;
        self.textprover2_duty.text = [self.textprover2.text length] >0 ? [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:self.caseProveInfo.secondProver]] : @"";
//        if ([self.caseProveInfo.secondProver length] > 0) {
//            //self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.secondProver];
//            self.textprover2_duty.text = [[[UserInfo orgAndDutyForUserName:self.caseProveInfo.secondProver] stringByReplacingOccurrencesOfString: @"二中队" withString: @""] stringByReplacingOccurrencesOfString: @"一中队" withString: @""] ;
//            self.textprover2_duty.text = [[self.textprover2_duty.text stringByReplacingOccurrencesOfString: @"三中队" withString: @""] stringByReplacingOccurrencesOfString: @"四中队" withString: @""] ;
//        }
    }

//    //当事人(车牌号) 单位职务
//    self.textcitizen_name.text = self.caseProveInfo.citizen_name;
//
//    self.textcitizen_duty.text = [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.org_principal_duty];
    NSString * textcitizen_duty_text;
    if (citizen.org_name && citizen.org_principal_duty) {
        if(citizen.org_name && !citizen.org_principal_duty){
            textcitizen_duty_text = citizen.org_name;
        }else if (!citizen.org_name && citizen.org_principal_duty){
            textcitizen_duty_text = citizen.org_principal_duty;
        }else{
            textcitizen_duty_text = [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.org_principal_duty];
        }
    }
    self.textcitizen_name.text = [self.caseProveInfo.citizen_name length]  > 0? self.caseProveInfo.citizen_name : @"无";
    self.caseProveInfo.citizen_name = @"";
    self.textcitizen_duty.text = [textcitizen_duty_text length] > 0 ? textcitizen_duty_text : @"无";
//    if ([self.textcitizen_duty.text isEqualToString:@""]) {
//        citizen.org_name = @"";
//        citizen.org_principal_duty = @"";
//    }
    
    //当事人代表  单位职务
    self.textparty.text = [self.caseProveInfo.organizer length] > 0 ? self.caseProveInfo.organizer : @"无";
    self.textparty_org_duty.text = [self.caseProveInfo.organizer_org_duty length] > 0? self.caseProveInfo.organizer_org_duty : @"无";
    
    //被邀请人 单位职务
    self.textinvitee.text = [self.caseProveInfo.invitee length] > 0? self.caseProveInfo.invitee : @"无";
    self.textInvitee_org_duty.text = [self.caseProveInfo.invitee_org_duty length] > 0 ? self.caseProveInfo.invitee_org_duty : @"无";
    
    //记录人 单位职务
    self.textrecorder.text = self.caseProveInfo.recorder;
    self.textrecorder_duty.text =[self.textrecorder.text length] >0 ? [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:self.caseProveInfo.recorder]] : @"";
    //self.textrecorder_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.recorder];
//     self.textrecorder_duty.text = [[[UserInfo orgAndDutyForUserName:self.caseProveInfo.recorder] stringByReplacingOccurrencesOfString: @"二中队" withString: @""] stringByReplacingOccurrencesOfString: @"一中队" withString: @""] ;
//    self.textrecorder_duty.text = [[ self.textrecorder_duty.text stringByReplacingOccurrencesOfString: @"三中队" withString: @""] stringByReplacingOccurrencesOfString: @"四中队" withString: @""] ;
    
    
    //勘验情况及结果
    self.textevent_desc.text = [self generateOtherEventDescForCase];
}

//保存数据
- (void)pageSaveInfo{
    //案号
//    self.caseProveInfo.caseinfo =
//    self.caseProveInfo.case_mark2 = self.textMark2.text;
//    self.caseProveInfo.case_mark3 = self.textMark3.text;
    //案由
    self.caseProveInfo.case_long_desc = self.textcase_short_desc.text;
    
    //勘验时间FIXME by lxm
    /*
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
     [dateFormatter setLocale:[NSLocale currentLocale]];
     self.textstart_date_time.text = [dateFormatter stringFromDate:];
     self.textend_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
     self.caseProveInfo.start_date_time = ;
     */
    
    //self.caseProveInfo.case_mark2 = self.textMark2.text;
    //self.caseProveInfo.case_mark3 = self.textMark3.text;
    
    //勘验场所
    self.caseProveInfo.remark = self.textprover_place.text;
    
    //勘验人1 单位职务
    NSString * prover1 = self.textprover1.text;
    NSString * prover2 = self.textprover2.text;
    NSString * prover3 = self.textprover3.text;
    if(prover2.length != 0){
        prover2 = [NSString stringWithFormat:@",%@",prover2];
    }
    if(prover3.length != 0){
        prover3 = [NSString stringWithFormat:@",%@",prover3];
    }
    if(prover1.length != 0){
        self.caseProveInfo.prover=[NSString stringWithFormat:@"%@%@%@",prover1,prover2,prover3];
    }
    
//    if([self.textprover2.text length]==0)
//    {
//        self.caseProveInfo.prover = self.textprover1.text;
//    }else if(([self.textprover1.text length]==0)&&(([self.textprover2.text length]==0))){
//        self.caseProveInfo.prover = @"";
//    }
//    else if(([self.textprover2.text length]!=0)&&(([self.textprover1.text length]!=0))){
//        self.caseProveInfo.prover=[NSString stringWithFormat:@"%@,%@",self.textprover1.text,self.textprover2.text];
//    }
//    else if([self.textprover1.text length]==0){
//        self.caseProveInfo.prover=self.textprover2.text;
//    }
//
    // modified by cjl
//    self.caseProveInfo.prover = self.textprover1.text;
    self.caseProveInfo.secondProver = self.textprover2.text;
    
    //当事人 单位职务
    self.caseProveInfo.citizen_name = self.textcitizen_name.text;
//    Citizen *citizen = [Citizen citizenForCitizenName:self.caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
    //当事人代理人 单位职务
    self.caseProveInfo.organizer  =   self.textparty.text ;
    self.caseProveInfo.organizer_org_duty  =   self.textparty_org_duty.text;
    //被邀请人 单位职务'
    self.caseProveInfo.invitee   =   self.textinvitee.text;
    self.caseProveInfo.invitee_org_duty = self.textInvitee_org_duty.text;
    
    //记录人 单位职务
    //self.caseProveInfo.recorder = self.textrecorder.text;
    self.caseProveInfo.recorder = [[self.textrecorder.text stringByReplacingOccurrencesOfString: @"二中队" withString: @""] stringByReplacingOccurrencesOfString: @"一中队" withString: @""] ;
    self.caseProveInfo.recorder = [[self.caseProveInfo.recorder stringByReplacingOccurrencesOfString: @"三中队" withString: @""] stringByReplacingOccurrencesOfString: @"四中队" withString: @""] ;
//    self.caseProveInfo.recorder_org_duty = @"西部沿海高速公路路政大队路政管理员";
    //勘验情况及结果
  
    self.caseProveInfo.event_desc = self.textevent_desc.text;
    
    // 更新
    CaseInfo* caseInfo = [CaseInfo caseInfoForID:self.caseID];
    caseInfo.happen_date = self.caseProveInfo.start_date_time;
    
    [[AppDelegate App] saveContext];
    
}
- (NSString *)generateEventDescForCase{
    CaseInfo * caseInfo =  [CaseInfo caseInfoForID:self.caseID];
    
    //    NSLog(@"%@",self.textprover_place.text);
    NSString * place = self.textprover_place.text;
    NSRange range = [self.textprover_place.text rangeOfString:@"m"];
    if (range.location  != NSNotFound) {
        place = [self.textprover_place.text substringToIndex:range.location+1];
    }
    NSString * event_desc= [[self.textstart_date_time.text stringByAppendingString: @"，我大队路政巡查人员巡查至"] stringByAppendingString:place];
    event_desc = [[[event_desc stringByAppendingString:@"处，发现公路"] stringByAppendingString: caseInfo.place] stringByAppendingString: @"有路产设施损坏，肇事车辆（人员）已逃离现场。经现场勘验损坏路产设施有："];
    NSLog(@"event_desc   %@",event_desc);
    CaseDeformation * caseDeformation = [CaseDeformation deformationsForCase:self.caseID];
    NSString * Deformation = @"";
    NSInteger Totalprice = 0;
    for (NSInteger i = 0; i < [(NSArray *)caseDeformation count]; i++) {
        //        NSArray * array =  [(NSArray *)caseDeformation objectAtIndex:0];
        CaseDeformation * mation = [(NSArray *)caseDeformation objectAtIndex:i];
        NSString *roadSizeString=[mation.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([roadSizeString isEmpty]) {
            roadSizeString=@"";
        }
        Totalprice = Totalprice + [mation.total_price integerValue];
        NSString * price = [NSString stringWithFormat:@"%ld", [mation.price integerValue]];
        NSString * quantity = [NSString stringWithFormat:@"%ld",[mation.quantity integerValue]];
        NSString * total_price = [NSString stringWithFormat:@"%ld", [mation.total_price integerValue]];
        if (mation.roadasset_name) {
            if (i == [(NSArray *)caseDeformation count]-1) {
                Deformation = [[[[[Deformation stringByAppendingString:mation.roadasset_name] stringByAppendingString:roadSizeString] stringByAppendingString:quantity] stringByAppendingString:mation.unit] stringByAppendingString:@"。"];
                break;
            }
            Deformation = [[[[[Deformation stringByAppendingString:mation.roadasset_name] stringByAppendingString:roadSizeString] stringByAppendingString:quantity] stringByAppendingString:mation.unit] stringByAppendingString:@"、"];
        }
    }
    if([(NSArray *)caseDeformation count] == 0){
        Deformation = @"无路产设施损坏。";
    }
    NSString * money = [NSString stringWithFormat:@"\n\n                                           上述路产共计损失金额%ld元\n\n\n以上勘验完毕。",Totalprice];
    event_desc = [[event_desc stringByAppendingString:Deformation] stringByAppendingString:money];
    return event_desc;
}

//去打印整个表格
-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
   if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.textFieldTag = self.textstart_date_time.tag;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showPastDate:self.caseProveInfo.start_date_time];
   }else if ([segueIdentifier isEqualToString:@"toDateTimePicker2"]) {
       DateSelectController *dsVC=segue.destinationViewController;
       dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
       dsVC.delegate=self;
       dsVC.pickerType=1;
       dsVC.textFieldTag = self.textend_date_time.tag;
       dsVC.datePicker.maximumDate=[NSDate date];
       [dsVC showPastDate:self.caseProveInfo.end_date_time];
   }
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender
{
    UITextField* textField = (UITextField* )sender;
    switch (textField.tag) {
        case 100:
            [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
            break;
        case 101:
            [self performSegueWithIdentifier:@"toDateTimePicker2" sender:self];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
        case 101:
        case 200:
        case 201:
        case 202:
        case 205:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

- (void)setPastDate:(NSDate *)date withTag:(int)tag{
    if (tag == self.textstart_date_time.tag) {
        self.caseProveInfo.start_date_time = date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textstart_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.start_date_time];
    }else if (tag == self.textend_date_time.tag) {
        self.caseProveInfo.end_date_time = date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textend_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
    }
}

- (IBAction)userSelect:(UITextField *)sender {
    self.textFieldTag = sender.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (self.textFieldTag == 200) {
        self.textprover1.text = name;
//        self.textprover1_duty.text = @"西部沿海高速公路路政大队路政管理员";
        self.textprover1_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:name]];
//        [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:0]];
    }else if (self.textFieldTag == 201){
        self.textprover2.text = name;
        self.textprover2_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:name]];
    }else if (self.textFieldTag == 202){
        self.textprover3.text = name;
        self.textprover3_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:name]];
    }else if (self.textFieldTag == 205){
        self.textrecorder.text = name;
        self.textrecorder_duty.text = [self textProver_duty_nsstring:[UserInfo orgAndDutyForUserName:name]];
        //        [UserInfo orgAndDutyForUserName:name];
    }
}
- (NSString * )textProver_duty_nsstring:(NSString *)duty{
    NSArray *array = [duty componentsSeparatedByString: @"西部沿海"];
    if ([array count] >= 2) {
        NSString * prover_duty = [NSString stringWithFormat:@"西部沿海%@",array[1]];
        prover_duty = [[[[prover_duty stringByReplacingOccurrencesOfString:@"一中队" withString:@""] stringByReplacingOccurrencesOfString:@"二中队" withString:@""] stringByReplacingOccurrencesOfString:@"" withString:@"三中队"]stringByReplacingOccurrencesOfString:@"四中队" withString:@""];
        return prover_duty;
    }
    return duty;
}
- (void)deleteCurrentDoc{
    NSManagedObjectContext * context = [[AppDelegate App] managedObjectContext];
    if(self.caseProveInfo){
        [context deleteObject:self.caseProveInfo];
        [[AppDelegate App] saveContext];
    }
}
    
@end
