//
//  AtonementNoticePrintViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "AtonementNoticePrintViewController.h"
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

static NSString * xmlName = @"AtonementNoticeTable";

@interface AtonementNoticePrintViewController ()
@property (nonatomic,retain) AtonementNotice * notice;

- (void)generateDefaultsForNotice:(AtonementNotice *)notice;
@end

@implementation AtonementNoticePrintViewController
@synthesize labelCaseCode     = _labelCaseCode;
@synthesize textParty         = _textParty;
@synthesize textPartyAddress  = _textPartyAddress;
@synthesize textCaseReason    = _textCaseReason;
@synthesize textOrg           = _textOrg;
@synthesize textViewCaseDesc  = _textViewCaseDesc;
@synthesize textWitness       = _textWitness;
@synthesize textViewPayReason = _textViewPayReason;
@synthesize textPayMode       = _textPayMode;
@synthesize textCheckOrg      = _textCheckOrg;
@synthesize labelDateSend     = _labelDateSend;
@synthesize textBankName      = _textBankName;
@synthesize caseID            = _caseID;
@synthesize notice            = _notice;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    NSString * strtemp = [[AppDelegate App] serverAddress];
    
    if ([strtemp isEqualToString:@"http://219.131.172.163:81/irmsdatagy/"]) {
//        xmlName = @"GYAtonementNoticeTable";
    }
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame  = viewFrame;
    /*modify by lxm 不能实时更新*/
    if (![self.caseID isEmpty]) {
        NSArray *noticeArray = [AtonementNotice AtonementNoticesForCase:self.caseID];
        if (noticeArray.count>0) {
            self.notice = [noticeArray objectAtIndex:0];
        } else {
            self.notice = [AtonementNotice newDataObjectWithEntityName:@"AtonementNotice"];
        }
        if (!self.notice.caseinfo_id || [self.notice.caseinfo_id isEmpty]) {
            self.notice.caseinfo_id = self.caseID;
            [self generateDefaultsForNotice:self.notice];
            
//            self.notice.case_desc = [self pinjie:self.notice.case_desc];
        }
//        [self generateDefaultsForNotice:self.notice];
        
        [self loadPageInfo];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSString *)pinjie:(NSString *)notice{
    NSRange range = [notice rangeOfString:@"认定公路路产损坏的事实为："];
    if (range.location != NSNotFound) {
        NSInteger len = range.length + range.location;
        NSString * str = [notice substringToIndex:len];
        NSLog(@"%@",str);
        NSString * fanhui = [str stringByAppendingString:[self getDeformationInfo]];
        if ([[self getDeformationInfo] length] >0) {
            return fanhui;
        }
    }
    return notice;
}
-(NSString*)getDeformationInfo{
    Citizen *citizen=[[Citizen allCitizenNameForCase:self.caseID] firstObject];
    NSString *deformString=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *deformEntity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
    NSPredicate *deformPredicate=[NSPredicate predicateWithFormat:@"proveinfo_id ==%@ && citizen_name==%@",self.caseID,citizen.automobile_number];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:deformEntity];
    [fetchRequest setPredicate:deformPredicate];
    NSArray *deformArray=[context executeFetchRequest:fetchRequest error:nil];
    if (deformArray.count>0) {
        for (CaseDeformation *deform in deformArray) {
            NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([roadSizeString isEmpty]) {
                roadSizeString=@"";
            } else {
                roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
            }
            NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([remarkString isEmpty]) {
                remarkString=@"";
            } else {
                remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
            }
            NSString * quantity=[[NSString alloc] initWithFormat:@"%d",deform.quantity.integerValue];
            
            //            NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
            //            quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
            if ([deform.roadasset_name length]>0) {
                deformString=[deformString stringByAppendingFormat:@"、%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit];
            }
        }
        NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
        deformString=[deformString stringByTrimmingCharactersInSet:charSet];
        
    } else {
        deformString=@"";
    }
    return deformString;
}


- (void)viewDidUnload
{
    [self setLabelCaseCode:nil];
    [self setTextParty:nil];
    [self setTextPartyAddress:nil];
    [self setTextCaseReason:nil];
    [self setTextOrg:nil];
    [self setTextViewCaseDesc:nil];
    [self setTextWitness:nil];
    [self setTextViewPayReason:nil];
    [self setTextPayMode:nil];
    [self setTextCheckOrg:nil];
    [self setLabelDateSend:nil];
    [self setNotice:nil];
    [self setTextBankName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)pageSaveInfo
{
    [self savePageInfo];
}

- (void)loadPageInfo{
  
    
    CaseInfo *caseInfo       = [CaseInfo caseInfoForID:self.caseID];
    self.labelCaseCode.text  = [[NSString alloc] initWithFormat:@"(%@)年%@交赔字第%@号",caseInfo.case_mark2, [FileCode fileCodeWithPredicateFormat:@"赔补偿案件编号"].organization_code, caseInfo.full_case_mark3];
    Citizen *citizen         = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" case:self.caseID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    self.textParty.text      = citizen.party;
    //self.textParty.text = [NSString stringWithFormat:@"%@(%@)", citizen.party,citizen.automobile_number ];
    
    self.textPartyAddress.text = citizen.address;
    self.textCaseReason.text   = [NSString stringWithFormat:@"%@", proveInfo.case_short_desc];
    self.textOrg.text = self.notice.organization_id;
    NSString * newStr          = [self.notice.organization_id  stringByReplacingOccurrencesOfString: @"广东省公路管理局" withString: @" "];
    NSString * newStr2         = [newStr stringByReplacingOccurrencesOfString: @"一中队" withString: @""];
    NSString * newStr3         = [newStr2 stringByReplacingOccurrencesOfString: @"二中队" withString: @""];
    NSString * newStr4         = [newStr2 stringByReplacingOccurrencesOfString: @"三中队" withString: @""];
    NSString * newStr5         = [newStr2 stringByReplacingOccurrencesOfString: @"四中队" withString: @""];
//    NSArray * chunks = [newStr5 componentsSeparatedByString:@"西部沿海"];
//    NSString * newStr6 = newStr5;
//    if ([chunks count]>=2)
//        newStr6 = [NSString stringWithFormat:@"西部沿海%@",chunks[1]];
    if ([newStr5 containsString:@"大队"]) {
        self.textOrg.text        = newStr5;
    }else{
        self.textOrg.text        = [newStr5 stringByAppendingString:@"大队"];
    }
    self.textViewCaseDesc.text = self.notice.case_desc;
//    [self CaseDesc];
//    self.notice.case_desc = self.textViewCaseDesc.text;

    //案件勘验详情
    self.textWitness.text       = self.notice.witness;
    self.textViewPayReason.text = self.notice.pay_reason;
    
    NSArray *temp=[Citizen allCitizenNameForCase:self.caseID];
    NSArray *citizenList=[[temp valueForKey:@"automobile_number"] mutableCopy];
    
    NSArray *deformations = [CaseDeformation deformationsForCase:self.caseID forCitizen:[citizenList objectAtIndex:0]];
    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    NSNumber *sumNum      = @(summary);
    NSString *numString   = [sumNum numberConvertToChineseCapitalNumberString];
    self.textPayMode.text = [[NSString stringWithFormat:@" %@",numString] stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
//    self.textBankName.text         = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    self.textBankName.text         = [self.notice bank_name];
    self.textCheckOrg.text         = self.notice.check_organization;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    self.labelDateSend.text = [dateFormatter stringFromDate:self.notice.date_send];
    NSString * start_date_time = [dateFormatter stringFromDate:proveInfo.start_date_time];
    self.LabelCitizentime.text = [NSString stringWithFormat:@"当事人%@于%@",citizen.party,start_date_time];
    
}

- (void)generateDefaultAndLoad
{
    [self generateDefaultsForNotice:self.notice];
    [self loadPageInfo];
}

//公路赔补偿通知书 保存数据
- (void)savePageInfo{
    CaseProveInfo *proveInfo       = [CaseProveInfo proveInfoForCase:self.caseID];
    proveInfo.case_long_desc       = self.textCaseReason.text;      //损坏公路路产
    self.notice.organization_id    = self.textOrg.text;         //西部沿海高速公路路政    后加的大队_info是打印数据
    self.notice.case_desc          = self.textViewCaseDesc.text;        //昊于2018年05月31日11时05分驾驶车牌为2...
    self.notice.pay_mode           = self.textPayMode.text;    //肆万贰仟玖佰伍拾元整
    self.notice.pay_reason         = self.textViewPayReason.text;//昊损坏公路路产的违法事实清楚，其行为违反了的《中华
    self.notice.check_organization = self.textCheckOrg.text;        //广东省公路事务中心
    self.notice.witness            = self.textWitness.text;     //勘验笔录，证人证词和现场拍摄的照片等材料
    //self.notice.party =  self.textParty.text;
    [[AppDelegate App] saveContext];
}

- (NSString *)CaseDesc{
    NSString * str = [CaseProveInfo generateEventDescForNotices:self.caseID];
    NSArray *temp=[str componentsSeparatedByString:@"处时"];
    NSArray *temp1=[str componentsSeparatedByString:@"之间时"];
    NSString * case_desc;
    if([temp count]>1){
        case_desc = [[temp objectAtIndex:0] stringByAppendingString:@"处时发生交通事故，经现场勘查，损坏公路路产，详见《公路赔（补）偿清单》。"];
    }else if([temp1 count]>1){
        case_desc = [[temp1 objectAtIndex:0] stringByAppendingString:@"之间时发生交通事故，经现场勘查，损坏公路路产，详见《公路赔（补）偿清单》。"];
        
    }else{
        return str;
    }
    return case_desc;
}

- (void)generateDefaultsForNotice:(AtonementNotice *)notice{
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    if ([proveInfo.event_desc isEmpty] || proveInfo.event_desc == nil) {
        //proveInfo.event_desc = [CaseProveInfo generateEventDescForCase:self.caseID];
        proveInfo.event_desc     = [CaseProveInfo generateEventDescForNotices:self.caseID];
    }
    NSDateFormatter *codeFormatter = [[NSDateFormatter alloc] init];
    [codeFormatter setDateFormat:@"yyyyMM'0'dd"];
    [codeFormatter setLocale:[NSLocale currentLocale]];
    notice.code   = [codeFormatter stringFromDate:[NSDate date]];
    NSRange range = [proveInfo.event_desc rangeOfString:@"于"];
    //notice.case_desc = [proveInfo.event_desc substringFromIndex:range.location+1];
    //notice.case_desc = [@"于" stringByAppendingString:[proveInfo.event_desc substringFromIndex:range.location+1]];
    
//    notice.case_desc =[CaseProveInfo generateEventDescForNotices:self.caseID];
    notice.case_desc = [self CaseDesc];
    NSArray * array = [notice.case_desc componentsSeparatedByString:@"分"];
    if ([array count]>=2) {
        notice.case_desc = [array objectAtIndex:1];
    }
    notice.citizen_name       = proveInfo.citizen_name;
    //notice.witness = @"现场照片、勘验检查笔录、询问笔录、现场勘验图";
    notice.witness            = @"勘验笔录，证人证词和现场拍摄的照片等材料";
    notice.check_organization = [[Systype typeValueForCodeName:@"复核单位"] objectAtIndex:0];
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    notice.organization_id    = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
//    notice.bank_name = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
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
    
    Citizen *citizen        = [Citizen citizenForCitizenName:notice.citizen_name nexus:@"当事人" case:self.caseID];
    NSString *plistPath     = [[NSBundle mainBundle] pathForResource:@"MatchLaw" ofType:@"plist"];
    NSDictionary *matchLaws = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *payReason     = @"";
    if (matchLaws) {
        NSString *breakStr      = @"";
        NSString *matchStr      = @"";
        NSString *payStr        = @"";
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
        payReason = @"由于交通事故造成了公路路产损坏，应按照《公路法》第八十五条第一款和《广东省公路条例》第二十三条第一款的规定，依法承担民事责任，依照广东省《损坏公路路产赔偿标准》（粤交路[1998]38号、[1999]263号）文件。";
        payReason = [NSString stringWithFormat:@"应按照%@，根据%@、并依照%@的规定，当事人应当承担民事责任，赔偿路产损失。",  breakStr, matchStr, payStr];
        payReason = [NSString stringWithFormat:@"%@%@的违法事实清楚，其行为违反了的《中华人民共和国公路法》 第五十二条、《中华人民共和国公路法》 第四十六条、《中华人民共和国公路法》 第八十五条第一款、《广东省公路条例》 第二十三条之规定，当事人应当承担民事责任，赔偿路产损失。", citizen.party, proveInfo.case_short_desc];
        
        
        
    }
    NSArray * tmp = [payReason componentsSeparatedByString:@"违法事实清楚，"];
    payReason = [[tmp objectAtIndex:0] stringByAppendingString:@"违法事实清楚，"];
    payReason =[NSString stringWithFormat:@"%@依据法律条文《中华人民共和国公路法》第五十二条、第八十五条第一款和《广东省公路条例》第二十三条第一款，并依照《损坏公路路产赔补偿标准》（粤交路[1998]38号、粤交路[1999]263号）",payReason];
    notice.pay_reason     =  @"《中华人民共和国公路法》第五十二条、第八十五条第一款和《广东省公路条例》第二十三条第一款，并依照《损坏公路路产赔补偿标准》（粤交路[1998]38号、粤交路[1999]263号）";
    NSArray *deformations = [CaseDeformation deformationsForCase:self.caseID forCitizen:notice.citizen_name];
    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    NSNumber *sumNum      = @(summary);
    NSString *numString   = [sumNum numberConvertToChineseCapitalNumberString];
    //notice.pay_mode = [NSString stringWithFormat:@"路产损失费人民币%@（￥%.2f元）",numString,summary];
    notice.pay_mode       = [NSString stringWithFormat:@"路产损失费%@",numString];
    notice.date_send      = [NSDate date];
    [[AppDelegate App] saveContext];
}

/*test by lxm 无效*/
-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect = CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.notice];
        
        //add by lxm 2013.05.08
        CaseInfo *caseInfo      = [CaseInfo caseInfoForID:self.caseID];
        self.labelCaseCode.text = [[NSString alloc] initWithFormat:@"(%@)年%@高交赔字第%@号",caseInfo.case_mark2, [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.full_case_mark3];
        Citizen *citizen        = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" case:self.caseID];
        citizen.party           = self.textParty.text;
        [self drawDateTable:xmlName withDataModel:citizen];
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:proveInfo];
        
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}
//打印预览。 赔补偿通知书
-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect = CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable1:xmlName];
        [self drawDateTable:xmlName withDataModel:self.notice];
        
        //add by lxm 2013.05.08
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        
        Citizen *citizen = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" case:self.caseID];
        citizen.party    = self.textParty.text;
        [self drawDateTable:xmlName withDataModel:citizen];
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:proveInfo];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect           = CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        //self.notice.bank_name= [self.notice.bank_name substringToIndex:3];
        [self drawDateTable:xmlName withDataModel:self.notice];
        
        //add by lxm 2013.05.08
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        
        Citizen *citizen = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" case:self.caseID];
        citizen.party    = self.textParty.text;
        [self drawDateTable:xmlName withDataModel:citizen];
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:proveInfo];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

@end
