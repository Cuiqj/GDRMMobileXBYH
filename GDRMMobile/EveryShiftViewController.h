//
//  EveryShiftViewController.h
//  GDRMXBYHMobile
//
//  Created by admin on 2019/6/17.
//

#import <UIKit/UIKit.h>

@interface EveryShiftViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *textdate_inspection;
@property (weak, nonatomic) IBOutlet UITextField *textinspection_mile;      //当日巡查里程     当班"
@property (weak, nonatomic) IBOutlet UITextField *textinspection_man_num;   //当日参加巡查人次"  当班    "8/4"
@property (weak, nonatomic) IBOutlet UITextField *textaccident_num;       //发生交通事故/其中涉及路产损害" "0/0"
@property (weak, nonatomic) IBOutlet UITextField *textdeal_accident_num;     //处理路产损害赔偿" "0/0"
@property (weak, nonatomic) IBOutlet UITextField *textdeal_bxlp_num;     //处理路产保险理赔案件" "0/0"
@property (weak, nonatomic) IBOutlet UITextField *textfxqx;     //发现报送道路、交安设施缺陷"
@property (weak, nonatomic) IBOutlet UITextField *textfxwfxw;   //发现违法行为"
@property (weak, nonatomic) IBOutlet UITextField *textjzwfxw;   //纠正违法行为"
@property (weak, nonatomic) IBOutlet UITextField *textcllmzaw;   //处理路面障碍物"
@property (weak, nonatomic) IBOutlet UITextField *textbzgzc;   //帮助故障车"
@property (weak, nonatomic) IBOutlet UITextField *textjcsgd;    //检查施工点/纠正违反公路施工安全作业规程行为"  "0/0"
@property (weak, nonatomic) IBOutlet UITextField *textgzzfj;       //告知交通综合行政执法局处理案件"
@property (weak, nonatomic) IBOutlet UITextField *textfcflws;     //发出法律文书"
@property (weak, nonatomic) IBOutlet UITextField *textqlxr;    //劝离行人" "0/0"

@property (nonatomic,retain) NSString * InspectionID;

- (IBAction)DeleteDataClick:(id)sender;
- (IBAction)BtnSaveDataClick:(id)sender;


@end
