//
//  AdminstrativePenaltyServiceReceiptTableViewController.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/8/3.
//

#import "AdminstrativePenaltyServiceReceiptTableViewController.h"
#import "CaseServiceReceipt.h"
#import "CaseServiceFiles.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "CaseProveInfo.h"

static NSString * const xmlName = @"AdminstrativePenaltyServiceReceiptTable";
@interface AdminstrativePenaltyServiceReceiptTableViewController ()
@property (nonatomic,strong) CaseServiceReceipt * caseServiceReceipt;

@end

@implementation AdminstrativePenaltyServiceReceiptTableViewController
@synthesize caseID = _caseID;

- (void)viewDidLoad {
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, 500);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseServiceReceipt = [CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
        if (self.caseServiceReceipt == nil) {
            self.caseServiceReceipt = [CaseServiceReceipt newCaseServiceReceiptForCase:self.caseID];
            [self generateDefaultInfo:self.caseServiceReceipt];
        }
//        [self generateDefaultInfo:self.caseServiceReceipt];
        [self pageLoadInfo];
    }
}
- (void)generateDefaultInfo:(CaseServiceReceipt *)caseServiceReceipt{
    
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    caseServiceReceipt.incepter_name=citizen.party;
    caseServiceReceipt.isuploaded = (@NO);
//    caseServiceReceipt.service_position = caseInfo.full_happen_place;
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString * orgname =[[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
//    NSArray *array = [orgname componentsSeparatedByString:@"路政大队"]; //从字符A中分隔成2个元素的数组
//    NSString * service_company = [NSString stringWithFormat:@"%@路政大队",array[0]];
    caseServiceReceipt.service_company = orgname;
    [[AppDelegate App] saveContext];
}
-(void)pageLoadInfo{
    CaseProveInfo * info = [CaseProveInfo proveInfoForCase:self.caseID];
    self.CaseReasontext.text = info.case_short_desc;
    self.OrgnameText.text = self.caseServiceReceipt.service_company;
    self.CitizenPartytext.text = self.caseServiceReceipt.incepter_name;
    self.ReplacePeopleText.text = self.caseServiceReceipt.agent_name ? self.caseServiceReceipt.agent_name : @"";
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)pageSaveInfo{
    self.caseServiceReceipt.agent_name = self.ReplacePeopleText.text;
    self.caseServiceReceipt.service_company = self.OrgnameText.text ;
    self.caseServiceReceipt.incepter_name = self.CitizenPartytext.text;
    [[AppDelegate App] saveContext];
}
-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseServiceReceipt];
//        [self drawDateTable:@"AdminstrativeInquireTable" withDataModel:self.caseinquire];
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
        [self drawDateTable:xmlName withDataModel:self.caseServiceReceipt];
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

@end
