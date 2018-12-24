//
//  ServicesCheckViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import <UIKit/UIKit.h>
#import "RoadInspectViewController.h"
@interface ServicesCheckViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *LeftTableView;
@property (weak, nonatomic) IBOutlet UITableView *RightTableView;
@property (weak, nonatomic) IBOutlet UITextField *textzhibiao;
@property (weak, nonatomic) IBOutlet UITextField *textleirong;
@property (weak, nonatomic) IBOutlet UILabel *labelBiaozhun;
@property (weak, nonatomic) IBOutlet UITextField *textScore;
@property (weak, nonatomic) IBOutlet UITextView *textRemark;
@property (weak, nonatomic) IBOutlet UIView *serviceCheckView;
@property (weak, nonatomic) IBOutlet UITextField *textchecktime;
@property (weak, nonatomic) IBOutlet UITextField *textservicename;
@property (weak, nonatomic) IBOutlet UITextField *textservice_fuzeren;
@property (weak, nonatomic) IBOutlet UITextField *textcheck_fuzeren;
@property (weak, nonatomic) IBOutlet UIView *checkDetailView;
@property (weak, nonatomic) IBOutlet UITextField *texttarget;
@property (weak, nonatomic) IBOutlet UITextField *textitem;
@property (weak, nonatomic) IBOutlet UILabel *labelstandard;
@property (weak, nonatomic) IBOutlet UITextField *textgrade;
@property (weak, nonatomic) IBOutlet UILabel *labelscore;
@property (weak, nonatomic) IBOutlet UITextView *textremark;
@property (nonatomic,weak) NSString* inspectionID;
@property (nonatomic, strong) RoadInspectViewController *roadinspectVC;

- (IBAction)btnSave:(id)sender;
- (IBAction)btnToAttach:(id)sender;
- (IBAction)btnNew:(id)sender;
- (IBAction)textToued:(UITextField *)sender;
- (IBAction)btnEdit:(id)sender;

@end
