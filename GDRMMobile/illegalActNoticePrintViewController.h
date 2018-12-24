//
//  illegalActNoticePrintViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/14.
//
//

#import "CasePrintViewController.h"
#import "DateSelectController.h"
@interface illegalActNoticePrintViewController : CasePrintViewController<DatetimePickerHandler>
@property (weak, nonatomic) IBOutlet UITextField *textparty;
@property (weak, nonatomic) IBOutlet UITextField *textlocation;
@property (weak, nonatomic) IBOutlet UITextField *textbuildingtype;
@property (weak, nonatomic) IBOutlet UITextField *textsenddate;
@property (weak, nonatomic) IBOutlet UITextField *textinkaddress;
@property (weak, nonatomic) IBOutlet UITextField *textinktel;
- (IBAction)textTouch:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textorg;
- (IBAction)selectDate:(UITextField *)sender;

@end
