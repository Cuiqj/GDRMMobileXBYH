//
//  AdminstrativePenaltyConstructionTableViewController.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/8/3.
//

#import "AdminstrativePenaltyConstructionTableViewController.h"
#import "ConstructionCorrect.h"
#import "DateSelectController.h"


static NSString * const xmlName = @"AdminstrativePenaltyConstructionTable";
@interface AdminstrativePenaltyConstructionTableViewController ()

@property (nonatomic,strong) ConstructionCorrect * Correct;


@end

@implementation AdminstrativePenaltyConstructionTableViewController
@synthesize caseID = _caseID;

- (void)viewDidLoad {
    [super setCaseID:self.caseID];
    //    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, 1100);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.Correct = [ConstructionCorrect caseConstructionCorrectForCase:self.caseID];
        if (self.Correct == nil) {
            self.Correct = [ConstructionCorrect newCaseConstructionCorrectForCase:self.caseID];
            [self generateDefaultInfo:self.Correct];
        }
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)generateDefaultInfo:(ConstructionCorrect *)correct{
    
    [[AppDelegate App] saveContext];
}
- (void)pageLoadInfo{
    self.casemark_before.text = self.Correct.smallplace ? self.Correct.smallplace : @"";
    self.casemark_later.text = self.Correct.mark ? self.Correct.mark : @"";
    self.ConstructionPeopleText.text = self.Correct.correct_name ? self.Correct.correct_name : @"";
    self.ConstructionReasonText.text = self.Correct.law ? self.Correct.law : @"";
    self.ConstructionQuestionText.text = self.Correct.at_once ? self.Correct.at_once : @"";
    self.ConstructionQuestionLaterText.text = self.Correct.later ? self.Correct.later : @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    if (self.Correct.end_date_time != nil) {
        self.ConstructionEndDateText.text = [dateFormatter stringFromDate:self.Correct.end_date_time];
    }
    self.ConstructionReasonOne.text = self.Correct.breakLaw_one ? self.Correct.breakLaw_one : @"";
    self.ConstructionReasonTwo.text = self.Correct.breakLaw_two ? self.Correct.breakLaw_two : @"";
    self.ConstructionReasonThree.text = self.Correct.breakLaw_three ? self.Correct.breakLaw_three : @"";
    self.ConstructionReasonFour.text = self.Correct.breakLaw_four ? self.Correct.breakLaw_four : @"";
    self.ContentAndDemandOne.text = self.Correct.demand_one ? self.Correct.demand_one : @"";
    self.ContentAndDemandTwo.text = self.Correct.demand_two ? self.Correct.demand_two : @"";
    self.ContentAndDemandThree.text = self.Correct.demand_three ? self.Correct.demand_three : @"";
    self.ContentAndDemandFour.text = self.Correct.demand_four ? self.Correct.demand_four : @"";
}
- (void)pageSaveInfo{
    self.Correct.smallplace = self.casemark_before.text;
    self.Correct.mark = self.casemark_later.text;
    self.Correct.correct_name = self.ConstructionPeopleText.text;
    self.Correct.law = self.ConstructionReasonText.text;
    self.Correct.at_once = self.ConstructionQuestionText.text;
    self.Correct.later = self.ConstructionQuestionLaterText.text;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
//    if (self.ConstructionEndDateText.text != nil) {
//        self.Correct.end_date_time = [dateFormatter dateFromString:self.ConstructionEndDateText.text];
//    }
    self.Correct.breakLaw_one = self.ConstructionReasonOne.text;
    self.Correct.breakLaw_two = self.ConstructionReasonTwo.text;
    self.Correct.breakLaw_three = self.ConstructionReasonThree.text;
    self.Correct.breakLaw_four = self.ConstructionReasonFour.text;
    self.Correct.demand_one = self.ContentAndDemandOne.text;
    self.Correct.demand_two = self.ContentAndDemandTwo.text;
    self.Correct.demand_three = self.ContentAndDemandThree.text;
    self.Correct.demand_four = self.ContentAndDemandFour.text;
    [[AppDelegate App] saveContext];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawDateTable:xmlName withDataModel:self.Correct];
        [self drawStaticTable:xmlName];
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
        [self drawDateTable:xmlName withDataModel:self.Correct];
//        [self drawStaticTable:xmlName];
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

- (IBAction)SelectDate:(id)sender {
    UIStoryboard *MainStoryboard            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    DateSelectController *datePicker = [MainStoryboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=0;
    // [datePicker showdate:self.textDate.text];
    UITextField* textField = (UITextField* )sender;
    CGRect frame = textField.frame;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    [self.pickerPopover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    datePicker.dateselectPopover=self.pickerPopover;
}
- (void)setDate:(NSString *)date{
    NSDateFormatter * formator =[[NSDateFormatter alloc]init];
    [formator setLocale:[NSLocale currentLocale]];
    [formator setDateFormat:@"yyyy-MM-dd"];
    self.Correct.end_date_time = [formator dateFromString:date];
    [formator setDateFormat:@"yyyy年MM月dd日"];
    self.ConstructionEndDateText.text = [formator stringFromDate:self.Correct.end_date_time];
}
@end
