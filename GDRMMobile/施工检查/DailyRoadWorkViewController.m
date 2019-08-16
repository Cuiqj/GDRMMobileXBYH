//
//  DailyRoadWorkViewController.m
//  YUNWUMobile
//
//  Created by admin on 2018/11/1.
//

#import "DailyRoadWorkViewController.h"
#import "UserPickerViewController.h"
#import "MaintainPlan.h"
#import "DateSelectController.h"
#import "AttachmentViewController.h"
#import "CasePhoto.h"
//禁用弹出键盘    以防止navigationbar上调移动之后    回复会有黑条
#import "IQKeyboardManager.h"

#import "InspectionRecord.h"
#import "RoadInspectViewController.h"

@interface DailyRoadWorkViewController ()
@property (nonatomic, retain) NSMutableArray * dataarray;
@property (nonatomic, retain) MaintainCheckDaily * dailyCheck;
@property (nonatomic, retain) NSString * dailyCheckID;

@property (nonatomic ,retain) NSIndexPath * selectedindexpath;
@property (nonatomic, retain) UIPopoverController * pickerPopover;
@end

@implementation DailyRoadWorkViewController
{
    BOOL _wasKeyboardManagerEnabled;
}


- (void)viewDidLoad {
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    self.view = scrollView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    self.TextViewRemark.delegate = self;
    [super viewDidLoad];
    self.title = @"施工检查详细情况";
//    [self.fujianButton setHidden:YES];
    self.tableViewList.delegate = self;
    self.tableViewList.dataSource = self;
    self.dataarray = [NSMutableArray arrayWithArray:[MaintainCheckDaily allMaintainCheckDailyforMaintain_planid:self.planID]];
    MaintainPlan * mainplan = [MaintainPlan maintainPlanInfoForID:self.planID];
    self.textorg.text = mainplan.construct_org;
    self.texttel.text =mainplan.tel_number;
    [self BtnaddClick:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    if(self.inspectionID.length && self.dailyCheck){
        [self createInspectionRecordforShiGongCheck];
        for (UIViewController * temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[RoadInspectViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataarray.count;
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除数据库数据            检查内容删除
    id obj=[self.dataarray objectAtIndex:indexPath.row];
    MaintainCheckDaily * check = (MaintainCheckDaily *)self.dataarray[indexPath.row];
    if([check.myid isEqualToString:self.dailyCheckID]){
        self.dailyCheckID = @"";
    }
    NSArray * photos = [CasePhoto casePhotos:check.myid];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    for (id photo in photos) {
        [context deleteObject:photo];
    }
    [context deleteObject:obj];
    [self.dataarray removeObjectAtIndex:indexPath.row];
    [[AppDelegate App] saveContext];
    //删除tableviewcell
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];
    [self BtnaddClick:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier  = @"DailyRoadWorkCheckCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时"];
    MaintainCheckDaily * CheckDaily;
    if (self.dataarray.count>0) {
        CheckDaily = self.dataarray[indexPath.row];
    }
    cell.textLabel.text = [formatter stringFromDate:CheckDaily.date];
//    if (cell.textLabel.text.length <6) {
//        cell.textLabel.text = @"错误数据，请左滑删除";
//    }
    cell.textLabel.backgroundColor=[UIColor clearColor];
//    cell.detailTextLabel.text = maintainplan.project_address;
//    cell.textLabel.backgroundColor=[UIColor clearColor];
    if (CheckDaily.isuploaded.boolValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedindexpath = indexPath;
    self.dailyCheck = (MaintainCheckDaily *)self.dataarray[indexPath.row];
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"yyyy年MM月dd日HH时"];
    self.textdate.text = [dateformatter stringFromDate:self.dailyCheck.date];
    self.textdirection.text = self.dailyCheck.direction;
    self.textinspector.text = self.dailyCheck.inspector;
    if (self.dataarray.count>0) {
        self.dailyCheck = self.dataarray[indexPath.row];
        self.dailyCheckID = self.dailyCheck.myid;
    }
    self.textproject_code.text = self.dailyCheck.project_code;
    self.textcheck_station.text = self.dailyCheck.check_station;
    //施工性质
    if ([self.dailyCheck.constr_nature isEqualToString:@"长期作业"]) {
        [self.textconstr_nature1 setSelected:YES];
    }else if ([self.dailyCheck.constr_nature isEqualToString:@"短期作业"]) {
        [self.textconstr_nature2 setSelected:YES];
    }else if ([self.dailyCheck.constr_nature isEqualToString:@"临时作业"]) {
        [self.textconstr_nature3 setSelected:YES];
    } else if ([self.dailyCheck.constr_nature isEqualToString:@"移动作业"]) {
        [self.textconstr_nature4 setSelected:YES];
    }        // 施工区域
    if([self.dailyCheck.constr_are isEqualToString:@"主车道"]){
        [self.textconstr_are1 setSelected:YES];
    }else if ([self.dailyCheck.constr_are isEqualToString:@"超车道"]){
        [self.textconstr_are2 setSelected:YES];
    }else if ([self.dailyCheck.constr_are isEqualToString:@"慢车道"]){
        [self.textconstr_are3 setSelected:YES];
    }else if ([self.dailyCheck.constr_are isEqualToString:@"路肩"]){
        [self.textconstr_are4 setSelected:YES];
    }else if ([self.dailyCheck.constr_are isEqualToString:@"收费广场、匝道"]){
        [self.textconstr_are5 setSelected:YES];
    }           //施工内容
    if([self.dailyCheck.constr_content isEqualToString:@"修复钢板"]){
        [self.constr_content1 setSelected:YES];
    }else if ([self.dailyCheck.constr_content isEqualToString:@"路面"]){
        [self.constr_content2 setSelected:YES];
    }else if ([self.dailyCheck.constr_content isEqualToString:@"隧道"]){
        [self.constr_content3 setSelected:YES];
    }else if ([self.dailyCheck.constr_content isEqualToString:@"边坡"]){
        [self.constr_content4 setSelected:YES];
    }else if ([self.dailyCheck.constr_content isEqualToString:@"桥梁"]){
        [self.constr_content5 setSelected:YES];
    }else if ([self.dailyCheck.constr_content isEqualToString:@"伸缩缝"]){
        [self.constr_content6 setSelected:YES];
    }else if ([self.dailyCheck.constr_content isEqualToString:@"其他"]){
        [self.constr_content7 setSelected:YES];
    }       //是否穿安全标志服
    if([self.dailyCheck.person_saft_mark integerValue] == 1){
        [self.person_saft_mark1 setSelected:YES];
    }else if([self.dailyCheck.person_saft_mark integerValue] == 0){
        [self.person_saft_mark2 setSelected:YES];
    }     //作业区长度是否符合要求
    if ([self.dailyCheck.work_length_require integerValue] == 1) {
        [self.work_length_require1 setSelected:YES];
    }else if ([self.dailyCheck.work_length_require integerValue] == 0) {
        [self.work_length_require2 setSelected:YES];
    }       //施工车辆是否会开启危险警示灯
    if ([self.dailyCheck.constr_car_light integerValue] == 1) {
        [self.constr_car_light1 setSelected:YES];
    }else if ([self.dailyCheck.constr_car_light integerValue] == 0) {
        [self.constr_car_light2 setSelected:YES];
    }       //夜间）是否不舍照明设备和警示频闪灯
    if([self.dailyCheck.night_light integerValue] == 1){
        [self.night_light1 setSelected:YES];
    }else if([self.dailyCheck.night_light integerValue] == 0){
        [self.night_light2 setSelected:YES];
    }       //是否开具《施工整改通知书》
    if([self.dailyCheck.notice integerValue] == 1){
        [self.notice1 setSelected:YES];
    }else  if([self.dailyCheck.notice integerValue] == 0){
        [self.notice2 setSelected:YES];
    }       //办理施工审批
    if([self.dailyCheck.approval integerValue] == 1){
        [self.approval1 setSelected:YES];
    }else if([self.dailyCheck.approval integerValue] == 0){
        [self.approval2 setSelected:YES];
    }       //交通锥摆放是否规范
    if([self.dailyCheck.traffic_cone integerValue] == 1){
        [self.traffic_cone1 setSelected:YES];
    } else if([self.dailyCheck.traffic_cone integerValue] == 0){
        [self.traffic_cone2 setSelected:YES];
    }       //标志牌 布设是否规范
    if ([self.dailyCheck.sign_lay integerValue] == 1) {
        [self.sign_lay1 setSelected:YES];
    }else if ([self.dailyCheck.sign_lay integerValue] == 0) {
        [self.sign_lay2 setSelected:YES];
    }       //施工材料堆放是否规范
    if([self.dailyCheck.material_stack integerValue] == 1){
        [self.material_stack1 setSelected:YES];
    }else if([self.dailyCheck.material_stack integerValue] == 0){
        [self.material_stack2 setSelected:YES];
    }       //是否配备安全管理员
    if(self.dailyCheck.have_safe_person.integerValue == 1){
        [self.have_safe_person1 setSelected:YES];
    }else  if(self.dailyCheck.have_safe_person.integerValue == 0){
        [self.have_safe_person2 setSelected:YES];
    }       //施工区域是否渠化
    if ([self.dailyCheck.canalization integerValue] == 1) {
        [self.canalization1 setSelected:YES];
    }else if ([self.dailyCheck.canalization integerValue] == 0) {
        [self.canalization2 setSelected:YES];
    }       //是否配合路政现场监督检查
    if ([self.dailyCheck.have_supervise integerValue] == 1) {
        [self.have_supervise1 setSelected:YES];
    }else if([self.dailyCheck.have_supervise integerValue] == 0){
        [self.have_supervise2 setSelected:YES];
    }       //是否有其他违规行为
    if ([self.dailyCheck.have_against integerValue] == 1) {
        [self.have_against1 setSelected:YES];
    }else if ([self.dailyCheck.have_against integerValue] == 0) {
        [self.have_against2 setSelected:YES];
    }
    if (self.dailyCheck.summary.length>0) {
        self.TextViewRemark.text = self.dailyCheck.summary;
    }
    //所有控制表格中行高亮的代码都只在这里
    [self.tableViewList deselectRowAtIndexPath:[self.tableViewList indexPathForSelectedRow] animated:YES];
    [self.tableViewList selectRowAtIndexPath:indexPath animated:nil scrollPosition:nil];
}
- (IBAction)selectUser:(id)sender {
    UITextField * textfield = (UITextField *)sender;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:textfield.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}
-(void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (self.textinspector.text.length>0) {
        self.textinspector.text = [NSString stringWithFormat:@"%@、%@",self.textinspector.text,name];
    }else{
        self.textinspector.text = name;
    }
}
- (IBAction)deleteUser:(id)sender {
    self.textinspector.text = @"";
}

- (IBAction)BtnaddClick:(id)sender {
    MaintainPlan * mainplan = [MaintainPlan maintainPlanInfoForID:self.planID];
    self.textorg.text = mainplan.construct_org;
    self.texttel.text =mainplan.tel_number;
    self.textdirection.text = @"";
    self.textinspector.text = @"";
    self.TextViewRemark.text = @"";
    self.textdate.text = @"";
    self.textcheck_station.text = @"";
    self.textproject_code.text = @"";
    
    [self.textconstr_nature1 setSelected:NO];
    [self.textconstr_nature2 setSelected:NO];
    [self.textconstr_nature3 setSelected:NO];
    [self.textconstr_nature4 setSelected:NO];
    [self.textconstr_are1 setSelected:NO];
    [self.textconstr_are2 setSelected:NO];
    [self.textconstr_are3 setSelected:NO];
    [self.textconstr_are4 setSelected:NO];
    [self.textconstr_are5 setSelected:NO];
    [self.constr_content1 setSelected:NO];
    [self.constr_content2 setSelected:NO];
    [self.constr_content3 setSelected:NO];
    [self.constr_content4 setSelected:NO];
    [self.constr_content5 setSelected:NO];
    [self.constr_content6 setSelected:NO];
    [self.constr_content7 setSelected:NO];
    [self.person_saft_mark1 setSelected:NO];
    [self.person_saft_mark2 setSelected:NO];
    [self.work_length_require1 setSelected:NO];
    [self.work_length_require2 setSelected:NO];
    [self.constr_car_light1 setSelected:NO];
    [self.constr_car_light2 setSelected:NO];
    [self.night_light1 setSelected:NO];
    [self.night_light2 setSelected:NO];
    [self.notice1 setSelected:NO];
    [self.notice2 setSelected:NO];
    [self.approval1 setSelected:NO];
    [self.approval2 setSelected:NO];
    [self.traffic_cone1 setSelected:NO];
    [self.traffic_cone2 setSelected:NO];
    [self.sign_lay1 setSelected:NO];
    [self.sign_lay2 setSelected:NO];
    [self.material_stack1 setSelected:NO];
    [self.material_stack2 setSelected:NO];
    [self.have_safe_person1 setSelected:NO];
    [self.have_safe_person2 setSelected:NO];
    [self.canalization1 setSelected:NO];
    [self.canalization2 setSelected:NO];
    [self.have_supervise1 setSelected:NO];
    [self.have_supervise2 setSelected:NO];
    [self.have_against1 setSelected:NO];
    [self.have_against2 setSelected:NO];
//    置空
    self.dailyCheckID = @"";
    self.dailyCheck = nil;
    [self.tableViewList deselectRowAtIndexPath:self.selectedindexpath animated:NO];
}
- (IBAction)BtnSaveClick:(id)sender {
    if(self.textdate.text.length>0){
        
    }else{
        __weak typeof(self)weakself = self;
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择检查时间，再保存！"  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [weakself.navigationController presentViewController:ac animated:YES completion:nil];
        return;
    }
    if (self.dailyCheckID.length>0) {
        //修改 已有检查
        [self btnSAveDailyChcek];
        [self.tableViewList reloadData];
        [self tableView:self.tableViewList didSelectRowAtIndexPath:self.selectedindexpath];
        return;
    }else{
        //新增 保存
        self.dailyCheck = [MaintainCheckDaily newDataObjectWithEntityName:@"MaintainCheckDaily"];
        self.dailyCheckID = self.dailyCheck.myid;
        self.dailyCheck.maintain_plan_id = self.planID;
        [self btnSAveDailyChcek];
//        NSDateFormatter *formator =[[NSDateFormatter alloc]init];
//        [formator setLocale:[NSLocale currentLocale]];
//        [formator setDateFormat:@"yyyy年MM月dd日HH时mm分"];
//        self.dailyCheck.date = [formator dateFromString:self.textdate.text];
//        [self.dataarray insertObject:self.dailyCheck atIndex:0];
        self.dataarray =[NSMutableArray arrayWithArray:[MaintainCheckDaily allMaintainCheckDailyforMaintain_planid:self.planID]];
        [[AppDelegate App]saveContext];
    }
    [self.tableViewList reloadData];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableViewList didSelectRowAtIndexPath:indexPath];
}
- (void)btnSAveDailyChcek{
    if (self.textinspector.text.length >0) {
        self.dailyCheck.inspector = self.textinspector.text;
    }
    self.dailyCheck.check_station = self.textcheck_station.text;
    self.dailyCheck.project_code = self.textproject_code.text;
    self.dailyCheck.direction = self.textdirection.text;
    NSDateFormatter *formator =[[NSDateFormatter alloc]init];
    [formator setLocale:[NSLocale currentLocale]];
    [formator setDateFormat:@"yyyy年MM月dd日HH时"];
    self.dailyCheck.date = [formator dateFromString:self.textdate.text];
    if ([self.textconstr_nature1 isSelected]) {
        self.dailyCheck.constr_nature = @"长期作业";
    }else if ([self.textconstr_nature2 isSelected]) {
        self.dailyCheck.constr_nature = @"短期作业";
    } else if ([self.textconstr_nature3 isSelected]) {
        self.dailyCheck.constr_nature = @"临时作业";
    } else if ([self.textconstr_nature4 isSelected]) {
        self.dailyCheck.constr_nature = @"移动作业";
    }   // 施工区域
    if([self.textconstr_are1 isSelected]){
        self.dailyCheck.constr_are = @"主车道";
    }else if([self.textconstr_are2 isSelected]){
        self.dailyCheck.constr_are = @"超车道";
    }else if([self.textconstr_are3 isSelected]){
        self.dailyCheck.constr_are = @"慢车道";
    }else if([self.textconstr_are4 isSelected]){
        self.dailyCheck.constr_are = @"路肩";
    }else if([self.textconstr_are5 isSelected]){
        self.dailyCheck.constr_are = @"收费广场、匝道";
    }           //施工内容
    if([self.constr_content1 isSelected]){
        self.dailyCheck.constr_content = @"修复钢板";
    }else if([self.constr_content2 isSelected]){
            self.dailyCheck.constr_content = @"路面";
    }else if([self.constr_content3 isSelected]){
        self.dailyCheck.constr_content = @"隧道";
    }else if([self.constr_content4 isSelected]){
        self.dailyCheck.constr_content = @"边坡";
    }else if([self.constr_content5 isSelected]){
        self.dailyCheck.constr_content = @"桥梁";
    }else if([self.constr_content6 isSelected]){
        self.dailyCheck.constr_content = @"伸缩缝";
    }else if([self.constr_content7 isSelected]){
        self.dailyCheck.constr_content = @"其他";
    }    //是否穿安全标志服
    if([self.person_saft_mark1 isSelected]){
        self.dailyCheck.person_saft_mark = @(1);
    }else if([self.person_saft_mark2 isSelected]){
        self.dailyCheck.person_saft_mark = @(0);
    }     //作业区长度是否符合要求
    if([self.work_length_require1 isSelected]){
        self.dailyCheck.work_length_require = @(1);
    }else if([self.work_length_require2 isSelected]){
        self.dailyCheck.work_length_require = @(0);
    }       //施工车辆是否会开启危险警示灯
    if([self.constr_car_light1 isSelected]){
        self.dailyCheck.constr_car_light = @(1);
    }else if([self.constr_car_light2 isSelected]){
        self.dailyCheck.constr_car_light = @(0);
    }       //夜间）是否不舍照明设备和警示频闪灯
    if([self.night_light1 isSelected]){
        self.dailyCheck.night_light = @(1);
    }else if([self.night_light2 isSelected]){
        self.dailyCheck.night_light = @(0);
    }       //是否开具《施工整改通知书》
    if([self.notice1 isSelected]){
        self.dailyCheck.notice = @(1);
    }else if([self.notice2 isSelected]){
        self.dailyCheck.notice = @(0);
    }     //办理施工审批
    if([self.approval1 isSelected]){
        self.dailyCheck.approval = @(1);
    }else if([self.approval2 isSelected]){
        self.dailyCheck.approval = @(0);
    }      //交通锥摆放是否规范
    if([self.traffic_cone1 isSelected]){
        self.dailyCheck.traffic_cone = @(1);
    }else if([self.traffic_cone2 isSelected]){
        self.dailyCheck.traffic_cone = @(0);
    }      //标志牌 布设是否规范
    if([self.sign_lay1 isSelected]){
        self.dailyCheck.sign_lay = @(1);
    }else if([self.sign_lay2 isSelected]){
        self.dailyCheck.sign_lay = @(0);
    }      //施工材料堆放是否规范
    if([self.material_stack1 isSelected]){
        self.dailyCheck.material_stack = @(1);
    }else if([self.material_stack2 isSelected]){
        self.dailyCheck.material_stack = @(0);
    }     //是否配备安全管理员
    if([self.have_safe_person1 isSelected]){
        self.dailyCheck.have_safe_person = @(1);
    }else if([self.have_safe_person2 isSelected]){
        self.dailyCheck.have_safe_person = @(0);
    }      //施工区域是否渠化
    if([self.canalization1 isSelected]){
        self.dailyCheck.canalization = @(1);
    }else if([self.canalization2 isSelected]){
        self.dailyCheck.canalization = @(0);
    }      //是否配合路政现场监督检查
    if([self.have_supervise1 isSelected]){
        self.dailyCheck.have_supervise = @(1);
    }else if([self.have_supervise2 isSelected]){
        self.dailyCheck.have_supervise = @(0);
    }     //是否有其他违规行为
    if([self.have_against1 isSelected]){
        self.dailyCheck.have_against = @(1);
    }else if([self.have_against2 isSelected]){
        self.dailyCheck.have_against = @(0);
    }
    if (self.TextViewRemark.text.length>0) {
        self.dailyCheck.summary = self.TextViewRemark.text;
    }
    [[AppDelegate App]saveContext];
}
- (IBAction)fujianBtnClick:(id)sender {
    if(self.dailyCheck.myid.length >0){
        
    }else{
        __weak typeof(self)weakself = self;
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择检查记录，再选择附件"  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [weakself.navigationController presentViewController:ac animated:YES completion:nil];
        return;
    }
    UIStoryboard *board            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    [next setValue:self.dailyCheck.myid forKey:@"constructionId"];
    [self.navigationController pushViewController:next animated:YES];
}
- (IBAction)selectDate:(id)sender {
    UITextField * textfield = (UITextField *)sender;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *dsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        dsVC.delegate = self;
        dsVC.pickerType = 1;
        dsVC.datePicker.maximumDate = [NSDate date];
        [dsVC showdate:self.textdate.text];
        self.pickerPopover = [[UIPopoverController alloc] initWithContentViewController:dsVC];
        [self.pickerPopover presentPopoverFromRect:textfield.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        dsVC.dateselectPopover = self.pickerPopover;
    }
}
-(void)setDate:(NSDate *)date forcheckdate:(NSString *)check{
    self.dailyCheck.date = date;
    NSDateFormatter *formator =[[NSDateFormatter alloc]init];
    [formator setLocale:[NSLocale currentLocale]];
    [formator setDateFormat:@"yyyy年MM月dd日HH时"];
    self.textdate.text = [formator stringFromDate:date];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    CGFloat navigationitemheight  = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view setFrame:CGRectMake(0, navigationitemheight, self.view.frame.size.width, self.view.frame.size.height)];
    return YES;
}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    CGFloat moveheight  = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
//    [self.view setFrame:CGRectMake(0, -moveheight, self.view.frame.size.width, self.view.frame.size.height)];
//    return YES;
//}
- (void)keyboardDidShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    CGFloat navigationitemheight  = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (firstResponder == self.TextViewRemark) {
        [self.view setFrame:CGRectMake(0, -height + navigationitemheight+20, self.view.frame.size.width, self.view.frame.size.height)];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)createInspectionRecordforShiGongCheck{

    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    //        //要把交通事故的照片带过来
    inspectionRecord.myid           = self.dailyCheck.myid;
    inspectionRecord.roadsegment_id = @"0";
    inspectionRecord.fix            = self.dailyCheck.direction;
    inspectionRecord.inspection_id  = self.inspectionID;
    inspectionRecord.relationid     = @"0";
    inspectionRecord.start_time     = self.dailyCheck.date;
    inspectionRecord.station        = @(0);
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH时mm分"];
    NSString * timestring = [dateformatter stringFromDate:self.dailyCheck.date];
    if([self maintainCheckDailyforDemand]){
        inspectionRecord.remark = [NSString stringWithFormat:@"%@巡查至S32%@%@时，检查广东省路路通有限公司取消省界收费站工程施工点，施工证号：%@，现场有人（无人）施工，现场封闭%@，作业区的布控及各交安设施符合规范。",timestring,self.dailyCheck.direction,self.dailyCheck.check_station,self.dailyCheck.project_code,self.close_desc];
    }else{
        inspectionRecord.remark = [NSString stringWithFormat:@"%@巡查至S32%@%@时，检查广东省路路通有限公司取消省界收费站工程施工点，施工证号：%@，现场有人（无人）施工，现场封闭%@，作业区的布控及各交安设施不符合规范，已现场开具《广东西部沿海高速公路涉路施工整改通知书》或《广东西部沿海高速公路涉路施工停工通知书》或《广东西部沿海高速公路涉路施工安全保证金扣除通知书》。",timestring,self.dailyCheck.direction,self.dailyCheck.check_station,self.dailyCheck.project_code,self.close_desc];
    }
    [[AppDelegate App] saveContext];
}
- (BOOL)maintainCheckDailyforDemand{
    if ([self.dailyCheck.person_saft_mark intValue] && [self.dailyCheck.work_length_require intValue] && [self.dailyCheck.constr_car_light intValue] && [self.dailyCheck.night_light intValue] && [self.dailyCheck.notice intValue] && [self.dailyCheck.approval intValue] && [self.dailyCheck.traffic_cone intValue] && [self.dailyCheck.sign_lay intValue] && [self.dailyCheck.material_stack intValue] && [self.dailyCheck.have_safe_person intValue] && [self.dailyCheck.canalization intValue] && [self.dailyCheck.have_supervise intValue] && [self.dailyCheck.have_against intValue]) {
        return YES;
    }
    return NO;
}


@end
