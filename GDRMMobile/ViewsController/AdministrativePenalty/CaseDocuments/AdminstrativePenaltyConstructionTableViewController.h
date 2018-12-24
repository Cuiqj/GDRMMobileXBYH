//
//  AdminstrativePenaltyConstructionTableViewController.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/8/3.
//

#import "CasePrintViewController.h"

@interface AdminstrativePenaltyConstructionTableViewController : CasePrintViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *casemark_before;
@property (weak, nonatomic) IBOutlet UITextField *casemark_later;
@property (weak, nonatomic) IBOutlet UITextField *ConstructionPeopleText;
@property (weak, nonatomic) IBOutlet UITextField *ConstructionReasonText;
@property (weak, nonatomic) IBOutlet UITextField *ConstructionQuestionText;
@property (weak, nonatomic) IBOutlet UITextField *ConstructionQuestionLaterText;
@property (weak, nonatomic) IBOutlet UITextField *ConstructionEndDateText;
//责改原因即违法事实
@property (weak, nonatomic) IBOutlet UITextView *ConstructionReasonOne;
@property (weak, nonatomic) IBOutlet UITextView *ConstructionReasonTwo;
@property (weak, nonatomic) IBOutlet UITextView *ConstructionReasonThree;
@property (weak, nonatomic) IBOutlet UITextView *ConstructionReasonFour;
//内容和要求
@property (weak, nonatomic) IBOutlet UITextField *ContentAndDemandOne;
@property (weak, nonatomic) IBOutlet UITextField *ContentAndDemandTwo;
@property (weak, nonatomic) IBOutlet UITextField *ContentAndDemandThree;
@property (weak, nonatomic) IBOutlet UITextField *ContentAndDemandFour;

@property (nonatomic,strong) UIPopoverController *pickerPopover;

- (IBAction)SelectDate:(id)sender;



@end
