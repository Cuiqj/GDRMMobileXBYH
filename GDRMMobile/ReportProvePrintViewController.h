//
//  ReportProvePrintViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/15.
//
//

#import "CasePrintViewController.h"
#import "DateSelectController.h"
@interface ReportProvePrintViewController : CasePrintViewController <DatetimePickerHandler>
@property (weak, nonatomic) IBOutlet UITextView *textProveDetail;
@property (weak, nonatomic) IBOutlet UITextField *textProveTime;
- (IBAction)btnSelectTime:(UITextField *)sender;

@end
