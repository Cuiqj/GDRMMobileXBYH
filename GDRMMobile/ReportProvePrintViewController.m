//。保险案件里勘验
//  ReportProvePrintViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/15.
//
//

#import "ReportProvePrintViewController.h"
#import "InsuranceNotice.h"
#import "PoliceReport.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "CaseProveInfo.h"
#import "DateSelectController.h"
#import "OrgInfo.h"
@interface ReportProvePrintViewController ()
@property(strong,nonatomic) PoliceReport * iPolicereport;
@property (nonatomic,retain) NSDate *senddate;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@end
static NSString * xmlName = @"ReportProve";

@implementation ReportProvePrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setCaseID:self.caseID];
    NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale currentLocale]];
    [formater setDateFormat:@"yyyy年MM月dd日"];

    // Do any additional setup after loading the view.
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    self.iPolicereport =[PoliceReport policeReportForCaseID:self.caseID];
    if(!self.iPolicereport){
        self.iPolicereport= [PoliceReport newDataObjectWithEntityName:@"PoliceReport"];
        [self generateDefaultsForNotice:self.iPolicereport];
                self.textProveTime.text= [formater stringFromDate:[NSDate date]];
        self.senddate=[NSDate date];
        self.textProveDetail.text=[CaseProveInfo generateBaoAnZhengminDescWithCaseID:self.caseID];
    }
    else{
        self.textProveDetail.text=self.iPolicereport.report_desc;
        self.textProveTime.text= [formater stringFromDate:self.iPolicereport.send_date];
        self.senddate=self.iPolicereport.send_date;
    }
    
    
    //[self.iPolicereport addObserver:self forKeyPath:@"report_desc" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示" message:change[@"new"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alterview show];

}
-(void)dealloc{
    ;// [self.iPolicereport removeObserver:self forKeyPath:@"report_desc" context:nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)pageSaveInfo
{
    self.iPolicereport.report_desc=self.textProveDetail.text;
    self.iPolicereport.send_date =self.senddate;
    self.iPolicereport.caseinfo_id= self.caseID;
    [self savePageInfo];
}
- (IBAction)textTouch:(UITextField *)sender{
    
}
- (IBAction)btnSelectTime:(UITextField *)sender { 
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
    self.textProveTime.text= [formater stringFromDate:date];
    self.senddate= date;
}
-(void)setDate:(NSString *)date{
    NSDateFormatter * formater =[[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale currentLocale]];
    [formater setDateFormat:@"yyyy-MM-dd hh:mm"];
    self.senddate= [formater dateFromString:date];
    self.textProveTime.text=date;
}


- (void)generateDefaultAndLoad
{
     [self generateDefaultsForNotice:self.iPolicereport];
    //[self loadPageInfo];
}

- (void)savePageInfo{
    self.iPolicereport.report_desc=self.textProveDetail.text;
    self.iPolicereport.send_date=self.senddate;
    self.iPolicereport.caseinfo_id=self.caseID;
    
    [[AppDelegate App] saveContext];
}

- (void)generateDefaultsForNotice:(PoliceReport *)notice{
    notice.report_desc =[CaseProveInfo generateBaoAnZhengminDescWithCaseID:self.caseID];
    self.textProveDetail.text=notice.report_desc;
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
        [self drawDateTable:xmlName withDataModel:self.iPolicereport];
        [self drawDateTable:xmlName withDataModel:[OrgInfo orgInfoForSelected]];
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
        [self drawDateTable:xmlName withDataModel:self.iPolicereport];
        [self drawDateTable:xmlName withDataModel:[OrgInfo orgInfoForSelected]];
        
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
        [self drawDateTable:xmlName withDataModel:self.iPolicereport];
        [self drawDateTable:xmlName withDataModel:[OrgInfo orgInfoForSelected]];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}



@end
