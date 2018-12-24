//
//  ZLYHRoadAssetCheckViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/12.
//
//

#import <UIKit/UIKit.h>
#import "RoadInspectViewController.h"

@interface ZLYHRoadAssetCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
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


@property (nonatomic,weak   ) NSString                  * inspectionID;
@property (nonatomic, strong) RoadInspectViewController *roadinspectVC;

@property (nonatomic,strong) UIPopoverController *picker;
- (IBAction)btnSave:(id)sender;

- (IBAction)btnNewZhangliang:(UIButton *)sender;

@end
