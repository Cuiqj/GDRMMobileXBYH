//
//  ZLYNinInspectVC.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/4.
//
//

#import <UIKit/UIKit.h>
#import "InspectionHandler.h"
@interface ZLYNinInspectVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textRoad;
@property (weak, nonatomic) id<InspectionHandler> delegate;
- (IBAction)selectRoad:(id)sender;
- (IBAction)selectFix:(id)sender;
- (IBAction)selectSide:(id)sender;
- (IBAction)selectTime:(id)sender ;
@property (weak, nonatomic ) IBOutlet UITextField *textFix;
@property (weak, nonatomic ) IBOutlet UITextField *textSide;
@property (weak, nonatomic ) IBOutlet UITextField *textSKM;
@property (weak, nonatomic ) IBOutlet UITextField *textSM;
@property (weak, nonatomic ) IBOutlet UITextField *textEKM;
@property (weak, nonatomic ) IBOutlet UITextField *textEM;
@property (weak, nonatomic ) IBOutlet UITextView  *textRemark;
@property (nonatomic,strong) NSString    *inspectionID;

@end
