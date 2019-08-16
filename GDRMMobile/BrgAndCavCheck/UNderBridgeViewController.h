//
//  UNderBridgeViewController.h
//  YUNWUMobile
//
//  Created by admin on 2018/8/13.
//

#import "RoadInspectViewController.h"

#import <UIKit/UIKit.h>

@interface UNderBridgeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@property (nonatomic,retain) NSString * roadname;

@property (weak, nonatomic) IBOutlet UILabel *LabelCheckDemand;
@property (weak, nonatomic) IBOutlet UITextField *RoadNametext;
- (IBAction)RoadNameTextClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *Managedtext;
- (IBAction)ManagedClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *Ckecktimestarttext;
- (IBAction)timeSelectClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *Endtimetext;
@property (weak, nonatomic) IBOutlet UITextField *Usernametext;
- (IBAction)UsernameSelectClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *onetext;
@property (weak, nonatomic) IBOutlet UITextField *twotext;
@property (weak, nonatomic) IBOutlet UITextField *threetext;
@property (weak, nonatomic) IBOutlet UITextField *fourtext;
@property (weak, nonatomic) IBOutlet UITextField *fivetext;
@property (weak, nonatomic) IBOutlet UITextField *sixtext;
@property (weak, nonatomic) IBOutlet UITextField *seventext;
@property (weak, nonatomic) IBOutlet UITextField *eighttext;
@property (weak, nonatomic) IBOutlet UITextField *ninetext;
@property (weak, nonatomic) IBOutlet UITextField *tentext;
@property (weak, nonatomic) IBOutlet UITextField *eleventext;
@property (weak, nonatomic) IBOutlet UITableView *ListTableView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
//复查验证情况
@property (weak, nonatomic) IBOutlet UITextView *textviewremark;

@property (nonatomic, strong) RoadInspectViewController * roadVC;

- (IBAction)addinfoClick:(id)sender;
- (IBAction)BtnSaveClick:(id)sender;
- (IBAction)BtntoFuJianClick:(id)sender;


- (IBAction)BtnRemoveDataUserClick:(id)sender;





@end

