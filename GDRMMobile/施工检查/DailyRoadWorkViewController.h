//
//  DailyRoadWorkViewController.h
//  YUNWUMobile
//
//  Created by admin on 2018/11/1.
//

#import <UIKit/UIKit.h>
#import "MaintainCheckDaily.h"

@interface DailyRoadWorkViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic,retain) NSString * planID;
//@property (nonatomic,retain) NSString * usedescription;
//跳转的巡查ID
@property (nonatomic,retain) NSString * inspectionID;
//所选施工项目的封道情况
@property (nonatomic, retain) NSString *close_desc;

//施工性质
@property (weak, nonatomic) IBOutlet UIButton *textconstr_nature1;
@property (weak, nonatomic) IBOutlet UIButton *textconstr_nature2;
@property (weak, nonatomic) IBOutlet UIButton *textconstr_nature3;
@property (weak, nonatomic) IBOutlet UIButton *textconstr_nature4;
//施工区域
@property (weak, nonatomic) IBOutlet UIButton *textconstr_are1;
@property (weak, nonatomic) IBOutlet UIButton *textconstr_are2;
@property (weak, nonatomic) IBOutlet UIButton *textconstr_are3;
@property (weak, nonatomic) IBOutlet UIButton *textconstr_are4;
@property (weak, nonatomic) IBOutlet UIButton *textconstr_are5;
//施工内容
@property (weak, nonatomic) IBOutlet UIButton *constr_content1;
@property (weak, nonatomic) IBOutlet UIButton *constr_content2;
@property (weak, nonatomic) IBOutlet UIButton *constr_content3;
@property (weak, nonatomic) IBOutlet UIButton *constr_content4;
@property (weak, nonatomic) IBOutlet UIButton *constr_content5;
@property (weak, nonatomic) IBOutlet UIButton *constr_content6;
@property (weak, nonatomic) IBOutlet UIButton *constr_content7;
//施工人员是否穿着安全标志服
@property (weak, nonatomic) IBOutlet UIButton *person_saft_mark1;
@property (weak, nonatomic) IBOutlet UIButton *person_saft_mark2;
//作业区长度是否符合要求
@property (weak, nonatomic) IBOutlet UIButton *work_length_require1;
@property (weak, nonatomic) IBOutlet UIButton *work_length_require2;
//施工车辆是否开启危险警示灯
@property (weak, nonatomic) IBOutlet UIButton *constr_car_light1;
@property (weak, nonatomic) IBOutlet UIButton *constr_car_light2;
//(夜间)是否布设照明设备和警示频闪灯
@property (weak, nonatomic) IBOutlet UIButton *night_light1;
@property (weak, nonatomic) IBOutlet UIButton *night_light2;
//是否开具《施工整改通知书》
@property (weak, nonatomic) IBOutlet UIButton *notice1;
@property (weak, nonatomic) IBOutlet UIButton *notice2;
//办理施工审批
@property (weak, nonatomic) IBOutlet UIButton *approval1;
@property (weak, nonatomic) IBOutlet UIButton *approval2;
//交通锥摆放是否规范
@property (weak, nonatomic) IBOutlet UIButton *traffic_cone1;
@property (weak, nonatomic) IBOutlet UIButton *traffic_cone2;
//标志牌布设是否规范
@property (weak, nonatomic) IBOutlet UIButton *sign_lay1;
@property (weak, nonatomic) IBOutlet UIButton *sign_lay2;
//施工材料堆放是否规范
@property (weak, nonatomic) IBOutlet UIButton *material_stack1;
@property (weak, nonatomic) IBOutlet UIButton *material_stack2;
//是否配备安全管理员
@property (weak, nonatomic) IBOutlet UIButton *have_safe_person1;
@property (weak, nonatomic) IBOutlet UIButton *have_safe_person2;
//施工区域是否渠化
@property (weak, nonatomic) IBOutlet UIButton *canalization1;
@property (weak, nonatomic) IBOutlet UIButton *canalization2;
//是否配合路政现场监督检查
@property (weak, nonatomic) IBOutlet UIButton *have_supervise1;
@property (weak, nonatomic) IBOutlet UIButton *have_supervise2;
//是否有其他违规行为
@property (weak, nonatomic) IBOutlet UIButton *have_against1;
@property (weak, nonatomic) IBOutlet UIButton *have_against2;
//检查小结
@property (weak, nonatomic) IBOutlet UITextView *TextViewRemark;
@property (weak, nonatomic) IBOutlet UITableView *tableViewList;

//受检单位
@property (weak, nonatomic) IBOutlet UITextField *textorg;
//施工负责人电话
@property (weak, nonatomic) IBOutlet UITextField *texttel;
//检查时间
@property (weak, nonatomic) IBOutlet UITextField *textdate;
- (IBAction)selectDate:(id)sender;

//方向
@property (weak, nonatomic) IBOutlet UITextField *textdirection;
//检查人员
@property (weak, nonatomic) IBOutlet UITextField *textinspector;
- (IBAction)selectUser:(id)sender;
- (IBAction)deleteUser:(id)sender;
//检查桩号
@property (weak, nonatomic) IBOutlet UITextField *textcheck_station;
//施工证号
@property (weak, nonatomic) IBOutlet UITextField *textproject_code;



- (IBAction)BtnaddClick:(id)sender;
- (IBAction)BtnSaveClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fujianButton;
- (IBAction)fujianBtnClick:(id)sender;





@end
