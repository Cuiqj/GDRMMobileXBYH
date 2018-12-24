//
//  RoadWayClosedViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/2/20.
//
//



#import <UIKit/UIKit.h>
#import "DateSelectController.h"
//#import "SystemTypeListViewController.h"
#import "ListSelectViewController.h"
#import "RoadInspectViewController.h"
#import "RoadSegmentPickerViewController.h"

@interface RoadWayClosedViewController : UIViewController <UITextFieldDelegate, DatetimePickerHandler, ListSelectPopoverDelegate, RoadSegmentPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *texttitle;
@property (weak, nonatomic) IBOutlet UITextField *textroadsegment;
@property (weak, nonatomic) IBOutlet UITextField *textfix;
@property (weak, nonatomic) IBOutlet UITextField *textclosed_roadway;
@property (weak, nonatomic) IBOutlet UITextField *texttype;
@property (weak, nonatomic) IBOutlet UITextField *texttime_start;
@property (weak, nonatomic) IBOutlet UITextField *texttime_end;
@property (weak, nonatomic) IBOutlet UITextField *textStartStationKM;
@property (weak, nonatomic) IBOutlet UITextField *textStartStationM;
@property (weak, nonatomic) IBOutlet UITextField *textEndStationKM;
@property (weak, nonatomic) IBOutlet UITextField *textEndStationM;
@property (weak, nonatomic) IBOutlet UITextView *textclosed_reason;
@property (weak, nonatomic) IBOutlet UITextView *textclosed_result;
@property (weak, nonatomic) IBOutlet UITextView *textremark;

//巡查记录ID
@property (nonatomic, strong) NSString *rel_id;
@property (nonatomic, strong) RoadInspectViewController *roadVC;
@property (weak, nonatomic) IBOutlet UITableView *roadWayClosedListTableView;

- (IBAction)btnNew:(id)sender;
- (IBAction)btnPhoto:(id)sender;

- (IBAction)btnSave:(id)sender;
- (IBAction)textTouch:(UITextField *)sender;
@end