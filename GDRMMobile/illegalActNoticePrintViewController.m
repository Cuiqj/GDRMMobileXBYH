//
//  illegalActNoticePrintViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/14.
//
//

#import "illegalActNoticePrintViewController.h"
#import "AtonementNotice.h"
#import "CaseDeformation.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "NSNumber+NumberConvert.h"
#import "Systype.h"
#import "MatchLaw.h"
#import "MatchLawDetails.h"
#import "LawItems.h"
#import "LawbreakingAction.h"
#import "Laws.h"
#import "FileCode.h"
#import "CaseLawInfo.h"
#import "DateSelectController.h"
@interface illegalActNoticePrintViewController ()
@property (nonatomic,retain) CaseLawInfo *caseLawInfo;
@property (nonatomic,retain) NSDate *senddate;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@end
static NSString * xmlName = @"illegalActNotice";

@implementation illegalActNoticePrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setCaseID:self.caseID];
    // Do any additional setup after loading the view.
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    self.caseLawInfo=[CaseLawInfo CaseLawInfoForCaseID:self.caseID];
    if(!self.caseLawInfo&&![self.caseID isEmpty]){
        self.caseLawInfo= [CaseLawInfo newDataObjectWithEntityName:@"CaseLawInfo"];
        self.caseLawInfo.org_id=[[OrgInfo orgInfoForSelected] valueForKey:@"myid" ];
        self.caseLawInfo.caseinfo_id=self.caseID;
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        Citizen *citizen = [[ Citizen allCitizenNameForCase:self.caseID] objectAtIndex:0];
        NSDateFormatter *formater =[[NSDateFormatter alloc] init];
        [formater setLocale:[NSLocale currentLocale]];
        [formater setDateFormat:@"yyyy年MM月dd日hh时mm分"];
        self.textparty.text=citizen.party;
        self.textlocation.text=caseInfo.full_happen_place;
        self.textbuildingtype.text=@"";
        self.textorg.text=[[[OrgInfo orgInfoForSelected] valueForKey:@"orgname"] stringByReplacingOccurrencesOfString:@"广东省公路管理局西部沿海高速公路" withString:@""];
        self.textinkaddress.text=[[OrgInfo orgInfoForSelected] valueForKey:@"address"];
        self.textinktel.text=[[OrgInfo orgInfoForSelected] valueForKey:@"telephone"];
        self.textsenddate.text= [formater stringFromDate:[NSDate date]];
        self.senddate=[NSDate date];
    }
    else{
        if(self.caseLawInfo)
         [self loadPageInfo];
    }
}

- (void)viewDidUnload
{ 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)pageSaveInfo
{
    [self savePageInfo];
}
- (IBAction)textTouch:(UITextField *)sender{

}
- (IBAction)selectDate:(UITextField *)sender{ 
    DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=1;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    [self.pickerPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    datePicker.dateselectPopover=self.pickerPopover;
    [datePicker showPastDate:self.senddate];

}
-(void)setPastDate:(NSDate *)date withTag:(int)tag{
        NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale currentLocale]];
    [formater setDateFormat:@"yyyy年MM月dd日hh时mm分"];
    self.textsenddate.text= [formater stringFromDate:date];
    self.senddate= date;
}
 -(void)loadPageInfo{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    Citizen *citizen = [[ Citizen allCitizenNameForCase:self.caseID] objectAtIndex:0];
     
    NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale currentLocale]];
    [formater setDateFormat:@"yyyy年MM月dd日hh时mm分"];
    
    //citizen = [Citizen citizenForCitizenName:self.caseLawInfo.party nexus:@"当事人" case:self.caseID];
    if(self.caseLawInfo){
        self.textparty.text=self.caseLawInfo.party;
        self.textlocation.text=self.caseLawInfo.location;
        self.textbuildingtype.text=self.caseLawInfo.buildingtype;
        self.textorg.text=self.caseLawInfo.sendorgname;
        self.textinkaddress.text=self.caseLawInfo.linkaddress;
        self.textinktel.text=self.caseLawInfo.linktel;
        self.textsenddate.text= [formater stringFromDate: self.caseLawInfo.senddate];
        self.senddate=self.caseLawInfo.senddate;
    }else{
        self.textparty.text=citizen.party;
        self.textlocation.text=caseInfo.place;
        self.textbuildingtype.text=@"";
        self.textorg.text=[[[OrgInfo orgInfoForSelected] valueForKey:@"orgname"] stringByReplacingOccurrencesOfString:@"广东省公路管理局西部沿海高速公路" withString:@""];
        self.textinkaddress.text=[[OrgInfo orgInfoForSelected] valueForKey:@"address"];
        self.textinktel.text=[[OrgInfo orgInfoForSelected] valueForKey:@"telephone"];
        self.textsenddate.text= [formater stringFromDate:[NSDate date]];
        self.senddate=[NSDate date];
    }
    
    
}

- (void)generateDefaultAndLoad
{
    // [self generateDefaultsForNotice:self.caseLawInfo];
    [self loadPageInfo];
}

- (void)savePageInfo{
    self.caseLawInfo.party=self.textparty.text;
    self.caseLawInfo.location=self.textlocation.text;
    self.caseLawInfo.buildingtype=self.textbuildingtype.text;
    self.caseLawInfo.sendorgname=self.textorg.text;
    self.caseLawInfo.linkaddress=self.textinkaddress.text;
    self.caseLawInfo.linktel=self.textinktel.text;
    self.caseLawInfo.senddate= self.senddate;
    self.caseLawInfo.org_id= [[OrgInfo orgInfoForSelected] valueForKey:@"myid"];
    self.caseLawInfo.caseinfo_id=self.caseID;
    [[AppDelegate App] saveContext];
}

- (void)generateDefaultsForNotice:(AtonementNotice *)notice{
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    if ([proveInfo.event_desc isEmpty] || proveInfo.event_desc == nil) {
        //proveInfo.event_desc = [CaseProveInfo generateEventDescForCase:self.caseID];
        proveInfo.event_desc = [CaseProveInfo generateEventDescForNotices:self.caseID];
    }
    NSDateFormatter *codeFormatter = [[NSDateFormatter alloc] init];
    [codeFormatter setDateFormat:@"yyyyMM'0'dd"];
    [codeFormatter setLocale:[NSLocale currentLocale]];
    notice.code = [codeFormatter stringFromDate:[NSDate date]];
    NSRange range = [proveInfo.event_desc rangeOfString:@"于"];
    //notice.case_desc = [proveInfo.event_desc substringFromIndex:range.location+1];
    //notice.case_desc = [@"于" stringByAppendingString:[proveInfo.event_desc substringFromIndex:range.location+1]];
    
    notice.case_desc =[CaseProveInfo generateEventDescForNotices:self.caseID];
    notice.citizen_name = proveInfo.citizen_name;
    //notice.witness = @"现场照片、勘验检查笔录、询问笔录、现场勘验图";
    notice.witness = @"勘验笔录，证人证词和现场拍摄的照片等材料";
    notice.check_organization = @"广东省公路管理局";
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    notice.organization_id = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
    //    NSMutableArray *matchLaws = [NSMutableArray array];
    //    NSArray *lawbreakingActionArr = [LawbreakingAction LawbreakingActionsForCase:proveInfo.case_desc_id];
    //    if (lawbreakingActionArr) {
    //        for (LawbreakingAction *lawbreakAction in lawbreakingActionArr) {
    //            NSArray *matchLawArr = [MatchLaw matchLawsForLawbreakingActionID:lawbreakAction.myid];
    //            if (matchLawArr) {
    //                for (MatchLaw *matchLaw in matchLawArr) {
    //                    NSArray *matchLawDetailsArr = [MatchLawDetails matchLawDetailsForMatchlawID:matchLaw.myid];
    //                    if (matchLawDetailsArr) {
    //                        for (MatchLawDetails *matchLawDetails in matchLawDetailsArr) {
    //                            Laws *laws = [Laws lawsForLawID:matchLawDetails.law_id];
    //                            LawItems *lawItems = [LawItems lawItemForLawID:matchLawDetails.law_id andItemNo:matchLawDetails.lawitem_id];
    //                            if (lawItems.lawitem_no) {
    //                                [matchLaws addObject:[NSString stringWithFormat:@"《%@》第%@条", laws.caption, lawItems.lawitem_no]];
    //                            }else{
    //                                [matchLaws addObject:[NSString stringWithFormat:@"《%@》", laws.caption]];
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    Citizen *citizen = [Citizen citizenForCitizenName:notice.citizen_name nexus:@"当事人" case:self.caseID];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MatchLaw" ofType:@"plist"];
    NSDictionary *matchLaws = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *payReason = @"";
    if (matchLaws) {
        NSString *breakStr = @"";
        NSString *matchStr = @"";
        NSString *payStr = @"";
        NSDictionary *matchInfo = [[matchLaws objectForKey:@"case_desc_match_law"] objectForKey:proveInfo.case_desc_id];
        if (matchInfo) {
            if ([matchInfo objectForKey:@"breakLaw"]) {
                breakStr = [(NSArray *)[matchInfo objectForKey:@"breakLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"matchLaw"]) {
                matchStr = [(NSArray *)[matchInfo objectForKey:@"matchLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"payLaw"]) {
                payStr = [(NSArray *)[matchInfo objectForKey:@"payLaw"] componentsJoinedByString:@"、"];
            }
        }
        
        //payReason = [NSString stringWithFormat:@"%@%@的违法事实清楚，其行为违反了%@规定，根据%@、并依照%@的规定，当事人应当承担民事责任，赔偿路产损失。", citizen.party, proveInfo.case_short_desc, breakStr, matchStr, payStr];
        payReason = [NSString stringWithFormat:@" 根据%@、并依照%@。",   matchStr, payStr];
        payReason=@" 根据《中华人民共和国公路法》第八十五条第一款和《广东省公路条例》第二十三条第一款的规定，依法承担民事责任。依照广东省《损坏公路路产赔偿标准》（粤交路[1998]38号）、《关于增补公路路产赔偿项目标准的通知》(粤交路[1999]263号)。";
        
    }
    notice.pay_reason = payReason;
    NSArray *deformations = [CaseDeformation deformationsForCase:self.caseID forCitizen:notice.citizen_name];
    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    notice.pay_mode = [NSString stringWithFormat:@"路产损失费人民币%@（￥%.2f元）",numString,summary];
    notice.date_send = [NSDate date];
    [[AppDelegate App] saveContext];
}

/*test by lxm 无效*/
-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseLawInfo];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable1:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseLawInfo];
        
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        //self.notice.bank_name= [self.notice.bank_name substringToIndex:3];
        [self drawDateTable:xmlName withDataModel:self.caseLawInfo];
         UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

@end
