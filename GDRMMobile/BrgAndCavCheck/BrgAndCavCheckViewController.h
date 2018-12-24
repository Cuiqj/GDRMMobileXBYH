//
//  ZLYHRoadAssetCheckViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/12.
//
//

#import <UIKit/UIKit.h>
#import "RoadInspectViewController.h"

@interface BrgAndCavCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableview;
@property (weak, nonatomic) IBOutlet UILabel     *startTimeLabel;

@property (weak, nonatomic) IBOutlet UIPickerView       *banciPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *doneorNotSeg;
@property (weak, nonatomic) IBOutlet UITableView        *detailTableView;
@property (weak, nonatomic) IBOutlet UIScrollView       *editView;

@property (weak, nonatomic) IBOutlet UITextField *textProblem;
@property (weak, nonatomic) IBOutlet UITextField *textSolution;
@property (weak, nonatomic) IBOutlet UITextField *textHongxian;
@property (weak, nonatomic) IBOutlet UITextView  *textRemark;
@property (weak, nonatomic) IBOutlet UIButton    *saveBtn;
///////////////////////////
@property (weak, nonatomic) IBOutlet UILabel *textProject;
@property (weak, nonatomic) IBOutlet UITextField *texteast;
@property (weak, nonatomic) IBOutlet UITextField *textwest;
@property (weak, nonatomic) IBOutlet UILabel *textrequirement;
@property (weak, nonatomic) IBOutlet UITextField *texthandle;
@property (weak, nonatomic) IBOutlet UITextView *textremark;

///////////////////////////

@property (nonatomic,weak   ) NSString                  * inspectionID;
@property (nonatomic, strong) RoadInspectViewController *roadinspectVC;

@property (nonatomic,strong) UIPopoverController *picker;
- (IBAction)btnSave:(id)sender;

- (IBAction)btnNewZhangliang:(UIButton *)sender;

@end
