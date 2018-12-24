#import "ShiGongCheckViewController.h"
#import "UserInfo.h"
#import "InspectionConstructionCell.h"
#import "AttachmentViewController.h"
#import "InspectionConstructionPDFViewController.h"
#import "CaseDocumentsViewController.h"
#import "MaintainPlanCheck.h"
#import "OrgInfo.h"
#import "ListSelectViewController.h"
#import "Systype.h"
static NSString *inspectionConstructionTable = @"InspectionConstructionTable";
static NSString *inspectionConstruction      = @"InspectionConstruction";

typedef enum {
    kStartTime1 = 0,
    kEndTime1,
    kStartTime2,
    kEndTime2,
    kInspectionDate
} TimeState;

@interface ShiGongCheckViewController ()
@property (retain, nonatomic) NSMutableArray      *constructionList;
@property (retain, nonatomic) UIPopoverController *pickerPopover;
@property (copy, nonatomic  ) NSString            *constructionID;
@property (assign, nonatomic) TimeState           timeState;

@property (copy, nonatomic) NSString *maintainPlanID;

//设定文书查看状态，编辑模式或者PDF查看模式
@property (nonatomic,assign) DocPrinterState docPrinterState;

@property (assign,nonatomic) BOOL      isWeatherFirstOrWeatherSecond;
@property (assign,nonatomic) NSInteger touchTextTag;

-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;
-(BOOL)checkInspectionConstructionInfo;
@end

@implementation ShiGongCheckViewController{
    NSIndexPath *notDeleteIndexPath;
    
    NSString *currentFileName;
    //弹窗标识，为0弹出天气选择，为1弹出车型选择，为2弹出损坏程度选择
    NSInteger touchedTag;
    NSDate *proveDate;
    
}
@synthesize uiBtnSave;
@synthesize tableCloseList;
@synthesize scrollContent;
@synthesize constructionList;
@synthesize pickerPopover;
@synthesize constructionID  = _constructionID;
@synthesize maintainPlanID  = _maintainPlanID;
@synthesize docPrinterState = _docPrinterState;

@synthesize inspectionID  = _inspectionID;
@synthesize roadInspectVC = _roadInspectVC;

@synthesize firstView;
@synthesize secondView;
@synthesize isWeatherFirstOrWeatherSecond;
@synthesize pdfFormatFileURL;
@synthesize pdfFileURL;
- (NSString *)constructionID{
    if (_constructionID==nil) {
        _constructionID=@"";
    }
    return _constructionID;
}
- (IBAction)btnTongzhishu:(UIButton *)sender{
    
    if(sender.tag ==1001){
        currentFileName=@"整改通知书";
        self.docPrinterState = 1;
    }
    else{
        currentFileName=@"停工通知书";
        self.docPrinterState = 1;
    }
    if(self.constructionID == nil || [self.constructionID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先保存记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    [self performSegueWithIdentifier:@"toCaseDocument" sender:sender];
}

- (IBAction)btnPhoto:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"toPhoto" sender:sender];
    if(self.constructionID == nil || [self.constructionID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一条记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    UIStoryboard *board            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    [next setValue:self.constructionID forKey:@"constructionId"];
    [self.navigationController pushViewController:next animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"toCaseDocument"]){
        CaseDocumentsViewController *documentsVC = segue.destinationViewController;
        documentsVC.fileName                     = currentFileName;
        documentsVC.caseID                       = self.constructionID;//nil;//self.caseID;
        documentsVC.maintainplanID               = self.maintainPlanID;
        documentsVC.docPrinterState              = self.docPrinterState;
        documentsVC.docReloadDelegate            = self;
    }else if ([segueIdentifier isEqualToString:@"toPhoto"]){
        AttachmentViewController *attach = segue.destinationViewController;
        [attach setValue: self.constructionID forKey:@"constructionId"];
    }
}
- (void)viewDidLoad
{
    self.constructionList=[[InspectionConstruction inspectionConstructionInfoForID:@""] mutableCopy];
    self.constructionList=[[ MaintainPlanCheck maintainCheckForID:@""] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSwitch:) name:@"refreshSwitch" object:nil];
    /*
     
     firstView.layer.cornerRadius  = 8;
     firstView.layer.masksToBounds = YES;
     firstView.layer.borderWidth   = 1;
     firstView.layer.borderColor   = [[UIColor blackColor] CGColor];
     
     
     secondView.layer.cornerRadius  = 8;
     secondView.layer.masksToBounds = YES;
     secondView.layer.borderWidth   = 1;
     secondView.layer.borderColor   = [[UIColor blackColor] CGColor];
     */
    [self.btnsendNotice setHidden:YES];
    
    self.scrollContent.showsVerticalScrollIndicator = NO;
    //进入界面 默认显示第一条
    /*if([self.constructionList count]> 0){
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
     }*/
    
    self.textZhengGai.alpha  = 0;
    self.textTingGong.alpha  = 0;
    self.textZhengGai.tag    = 109;
    self.textTingGong.tag    = 110;
    self.labelTingGong.alpha = 0;
    self.labelZhengGai.alpha = 0;
    self.navigationItem.title=@"施工检查";
    [super viewDidLoad];
    [self.textZhengGai addTarget:self action:@selector(selectZhengGaiXM:) forControlEvents:UIControlEventTouchDown];
}

- (void)viewWillDisappear:(BOOL)animated{
    //生成巡查记录
    if (self.roadInspectVC && [[self.navigationController visibleViewController] isEqual:self.roadInspectVC]) {
        if (![self.inspectionID isEmpty]) {
            NSString *remark;
            NSArray *users=[[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
            NSString*usersname=[[NSString alloc]init];
            for (NSString *name in users) {
                if([usersname isEmpty])
                    usersname = name;
                else
                    usersname = [usersname stringByAppendingFormat:@",%@",name];
            }
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
            NSDate * check_date=[formatter dateFromString:self.check_date.text];
            [formatter setDateFormat:@"HH:mm"];
            NSString*time=[formatter stringFromDate:check_date];
            /*
            10:14，当班巡至（粤高速）S32往西K06+600M与K08+500M，恒建进行XXX施工，封闭XX车道，现场有/无人员施工，标志标牌摆放符合规范。
            10:14，当班巡至（粤高速）S32往西K06+600M与K08+500M，恒建进行XXX施工，封闭XX车道，现场有/无人员施工，标志标牌摆放不符合规范/施工人员不穿反光衣/上游封闭区过短/未封闭施工区域，已现场开具整改通知书/停工通知书/已通知现场负责人整改，已现场整改完毕/已限期X天整改/已停工。
*/
            if(self.weiguiSwitch.isOn)
                remark =[NSString stringWithFormat:@"%@ 当班巡至%@，%@进行%@施工，封闭%@车道，现场有人员施工，标志标牌摆放不符合规范/施工人员不穿反光衣/上游封闭区过短/未封闭施工区域，已现场开具整改通知书/停工通知书/已通知现场负责人整改，已现场整改完毕/已限期X天整改/已停工。",time, self.textDidian.text,self.textShiGongDanWei.text,self.textProject.text,self.textchedao.text];
            else
                remark =[NSString stringWithFormat:@"%@ 当班巡至%@，%@进行%@施工，封闭%@车道，现场有人员施工，标志标牌摆放符合规范。",time, self.textDidian.text,self.textShiGongDanWei.text,self.textProject.text,self.textchedao.text];
            [self.roadInspectVC  createRecodeByShiGongCheck:self.constructionID withRemark:remark];
            [self setInspectionID:nil];
            [self setRoadInspectVC:nil];
        }
    }
    
    [super viewWillDisappear:animated];
}
- (IBAction)userSelect:(UITextField *)sender {
    if ((self.touchTextTag == sender.tag) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag   = sender.tag;
        UserPickerViewController *userPicker=[[UserPickerViewController alloc] init];
        //UserPickerViewController *userPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"userPicker"];
        userPicker.delegate = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:userPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        userPicker.pickerPopover = self.pickerPopover;
    }
}
- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    //[(UITextField *)[self.view viewWithTag:self.touchTextTag] setText:name];
    if([self.textchecker.text isEmpty])
        self.textchecker.text = name;
    else{
        self.textchecker.text = [NSString stringWithFormat:@"%@,%@",self.textchecker.text,name];
    }
}
- (IBAction)textTouch:(UITextField *)sender {
    self.touchTextTag = sender.tag;
    switch (sender.tag) {
            //巡查时间 tag=1
        case 1:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate   = self;
                datePicker.pickerType = 1;
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                NSDate *temp=[dateFormatter dateFromString:self.check_date.text];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [datePicker showdate:[dateFormatter stringFromDate:temp]];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover = self.pickerPopover;
            }
        }
            self.timeState = kInspectionDate;
            break;
            //巡查项目名称tag=3
        case 3:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                MaintainPlanPickerViewController *MaintainPlanPicker=[[ MaintainPlanPickerViewController alloc]init];
                MaintainPlanPicker.pickerType = 1;
                MaintainPlanPicker.delegate   = self;
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:MaintainPlanPicker];
                [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                MaintainPlanPicker.pickerPopover = self.pickerPopover;
            }
        }
            //self.timeState = kStartTime1;
            break;
        case 2:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                MaintainPlanPickerViewController *MaintainPlanPicker=[[ MaintainPlanPickerViewController alloc]init];
                MaintainPlanPicker.pickerType = 2;
                MaintainPlanPicker.delegate   = self;
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:MaintainPlanPicker];
                [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                MaintainPlanPicker.pickerPopover = self.pickerPopover;
            }
            
        }
            //self.timeState = kEndTime1;
            break;
        default:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                MaintainPlanPickerViewController *MaintainPlanPicker=[[ MaintainPlanPickerViewController alloc]init];
                MaintainPlanPicker.pickerType = 3;
                MaintainPlanPicker.delegate   = self;
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:MaintainPlanPicker];
                [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                MaintainPlanPicker.pickerPopover = self.pickerPopover;
            }
            
        }
            break;
    }
}
- (void)setDate:(NSString *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *temp=[dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *dateString=[dateFormatter stringFromDate:temp];
    self.check_date.text = dateString;
}
-(void)setMaintainPlan:(NSString *)name andID:(NSString *)PlanID{
    
    self.maintainPlanID         = PlanID;
    self.textProject.text       = name;
    MaintainPlan *plan =[MaintainPlan maintainPlanInfoForID:PlanID];
    self.textDidian.text        = plan.project_address;
    self.textShiGongDanWei.text = plan.construct_org;
    NSArray *inspectorArray     = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    NSString *inspectorName     = @"";
    for (NSString *name in inspectorArray) {
        if ([inspectorName isEmpty]) {
            inspectorName = name;
        } else {
            inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
        }
    }
    self.textchecker.text = inspectorName;
    
}

- (IBAction)btnAddNew:(UIButton *)sender {
    for (UITextField *textField in [self.scrollContent subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text=@"";
        }
    }
    self.textcheck_remark.text=@"";
    [self.weiguiSwitch setOn:NO];
    [self refeshsomething];
    self.constructionID=@"";
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.check_date.text=[dateFormatter stringFromDate:[NSDate date]];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    NSString *inspectorName = @"";
    for (NSString *name in inspectorArray) {
        if ([inspectorName isEmpty]) {
            inspectorName = name;
        } else {
            inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
        }
    }
    self.textchecker.text = inspectorName;
    
}

- (IBAction)btnSave:(UIButton *)sender {
    //    if(![self checkInspectionConstructionInfo]){
    //        return;
    //    }
    MaintainPlanCheck *checkInfo;
    NSIndexPath *indexPath;
    if ([self.constructionID isEmpty]) {
        //constructionInfo=[InspectionConstruction newDataObjectWithEntityName:inspectionConstruction];
        checkInfo           = [MaintainPlanCheck newDataObjectWithEntityName:@"MaintainPlanCheck"];
        self.constructionID = checkInfo.myid;
        indexPath           = [NSIndexPath indexPathForRow:[self.constructionList count] inSection:0];
    } else {
        //constructionInfo=[[InspectionConstruction inspectionConstructionInfoForID:self.constructionID] objectAtIndex:0];
        NSArray * checkarray=[MaintainPlanCheck maintainCheckForID:self.constructionID];
        checkInfo = [checkarray objectAtIndex:0];
    }
    checkInfo.myid = self.constructionID;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    checkInfo.check_date=[formatter dateFromString:self.check_date.text];
    //checkInfo.checktype=self.textchecktype.text;
    checkInfo.checker         = self.textchecker.text;
    checkInfo.maintainPlan_id = self.maintainPlanID;
    checkInfo.have_stopwork   = self.weiguiSwitch.isOn?@"1":@"0";
    checkInfo.have_rectify    = self.weiguiSwitch.isOn?@"1":@"0";
    checkInfo.check_remark    = self.textcheck_remark.text;
    checkInfo.closed_roadway  = self.textchedao.text;
    checkInfo.jiancha_didian  = self.textDidian.text;
    //    if([self.textcheckitem1.text isEqualToString:@"是"]){checkInfo.checkitem1 = @"1" ;} else {checkInfo.checkitem1=@"0";}
    //    if([self.textcheckitem2.text isEqualToString:@"是"]){checkInfo.checkitem2 = @"1" ;} else {checkInfo.checkitem2=@"0";}
    //    if([self.textcheckitem3.text isEqualToString:@"是"]){checkInfo.checkitem3 = @"1" ;} else {checkInfo.checkitem3=@"0";}
    //    if([self.textcheckitem4.text isEqualToString:@"是"]){checkInfo.checkitem4 = @"1" ;} else {checkInfo.checkitem4=@"0";}
    //checkInfo.checkitem1= [self.textcheckitem1.text isEqualToString:@"是"? @"1":@"0"  ];
    // checkInfo.checkitem2=self.textcheckitem2.text;
    // checkInfo.checkitem3=self.textcheckitem3.text;
    // checkInfo.checkitem4=self.textcheckitem4.text;
    //    checkInfo.have_stopwork=self.switchisTingGong.isOn?@"1":@"0";
    //    checkInfo.have_rectify=self.switchisZhengGai.isOn?@"1":@"0";
    //    checkInfo.rectify_no=self.textrectify_no.text;
    //    checkInfo.stopwork_no=self.textstopwork_no.text;
    //    checkInfo.check_remark=self.textcheck_remark.text;
    //    checkInfo.duty_opinion=self.textduty_opinion.text;
    //    checkInfo.safety = self.textsafety.text;
    checkInfo.org_id=[[OrgInfo orgInfoForSelected] valueForKey:@"myid"];
    checkInfo.inspection_id=@"0";//不录入巡查iDinspection_id
    checkInfo.stopwork_items  = self.textTingGong.text;
    checkInfo.rectify_items   = self.textZhengGai.text;
    checkInfo.maintain_cer=self.textmaintain_cer.text;
    [[AppDelegate App] saveContext];
    //self.constructionList=[[InspectionConstruction inspectionConstructionInfoForID:@""] mutableCopy];
    self.constructionList=[[ MaintainPlanCheck maintainCheckForID:@""] mutableCopy];
    [self.tableCloseList reloadData];
    
    //当新增的时候，会在左侧的列表中添加一条新的记录，所以这条新的记录必须高亮
    if(indexPath){
        [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    for (NSInteger i = 0; i < [self.constructionList count]; i++) {
        MaintainPlanCheck *check=[self.constructionList objectAtIndex:i];
        if([check.myid isEqualToString:self.constructionID]){
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
        }
    }
}

//弹出框不调出软键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==1 || textField.tag==2 || textField.tag == 4 || textField.tag == 3 || textField.tag == 5 || textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 17) {
        return YES;
    } else {
        return YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.constructionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier  = @"MaintainCheckCell";
    InspectionConstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MaintainPlanCheck *constructionInfo=[self.constructionList objectAtIndex:indexPath.row];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    // cell.textLabel.text=[formatter stringFromDate:constructionInfo.inspectiondate];
    cell.textLabel.text=[formatter stringFromDate:constructionInfo.check_date];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    NSString *local=@"";
    /*
     [formatter setDateFormat:@"HH:mm"];
     local = [local stringByAppendingString:@"检查时间:"];
     if(constructionInfo.timestart1 != nil){
     local = [local stringByAppendingString:[formatter stringFromDate: constructionInfo.timestart1]];
     }
     local = [local stringByAppendingString:@"至"];
     if(constructionInfo.timeend1 != nil){
     local = [local stringByAppendingString:[formatter stringFromDate: constructionInfo.timeend1]];
     }
     local = [local stringByAppendingString:@" 桩号:K"];
     if(constructionInfo.stationstart1 != nil){
     local = [local stringByAppendingString:[NSString stringWithFormat:@"%d", constructionInfo.stationstart1.integerValue/1000]];
     }
     local = [local stringByAppendingString:@"+"];
     if(constructionInfo.stationstart1 != nil){
     local = [local stringByAppendingString:[NSString stringWithFormat:@"%d",constructionInfo.stationstart1.integerValue%1000]];
     }
     local = [local stringByAppendingString:@"至"];
     if(constructionInfo.stationend1 != nil){
     local = [local stringByAppendingString:[NSString stringWithFormat:@"%d",constructionInfo.stationend1.integerValue/1000]];
     }
     local = [local stringByAppendingString:@"+"];
     if(constructionInfo.stationend1 != nil){
     local = [local stringByAppendingString:[NSString stringWithFormat:@"%d",constructionInfo.stationend1.integerValue%1000]];
     }
     */
    cell.detailTextLabel.text = local;
    
    
    
    cell.textLabel.backgroundColor=[UIColor clearColor];
    if (constructionInfo.isuploaded.boolValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*id obj;
     if(indexPath){
     obj=[self.constructionList objectAtIndex:indexPath.row];
     }else{
     if(notDeleteIndexPath){
     obj=[self.constructionList objectAtIndex:notDeleteIndexPath.row];
     indexPath = notDeleteIndexPath;
     }
     }
     if(obj){
     [self selectFirstRow:indexPath];
     }else{
     [self selectFirstRow:nil];
     }*/
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    notDeleteIndexPath = nil;
    return @"删除";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        id obj=[self.constructionList objectAtIndex:indexPath.row];
        BOOL isPromulgated=[[obj isuploaded] boolValue];
        if (isPromulgated) {
            notDeleteIndexPath = indexPath;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:@"已上传信息，不能直接删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            
            
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            [context deleteObject:obj];
            [self.constructionList removeObject:obj];
            
            // InspectionConstruction *inspection = (InspectionConstruction *)obj;
            MaintainPlanCheck *inspection =(MaintainPlanCheck *)obj;
            NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[pathArray objectAtIndex:0];
            NSString *photoPath=[NSString stringWithFormat:@"InspectionConstruction/%@",inspection.myid];
            photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            [[NSFileManager defaultManager]removeItemAtPath:photoPath error:nil];
            
            [[AppDelegate App] saveContext];
            
            
            
            self.constructionID = @"";
            NSArray* indeAray=[NSArray arrayWithObjects:indexPath, nil] ;
            [tableView deleteRowsAtIndexPaths:indeAray withRowAnimation:UITableViewRowAnimationFade];
            for (id sub in self.view.subviews) {
                if ([sub isKindOfClass:[UITextField class]]) {
                    UITextField *textf=(UITextField*)sub;
                    textf.text=@"";
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MaintainPlanCheck *checkInfo = [self.constructionList objectAtIndex:indexPath.row];
    self.constructionID          = checkInfo.myid;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.check_date.text =[formatter stringFromDate:checkInfo.check_date];
    self.constructionID         = checkInfo.myid;
    self.textchecker.text       = checkInfo.checker;
    self.textmaintain_cer.text  = checkInfo.maintain_cer;
    self.maintainPlanID         = checkInfo.maintainPlan_id;
    self.textProject.text       = [MaintainPlan maintainPlanNameForID:checkInfo.maintainPlan_id ];
    self.textcheck_remark.text  = checkInfo.check_remark;
    MaintainPlan *plan =[MaintainPlan maintainPlanInfoForID:checkInfo.maintainPlan_id];
    self.textDidian.text        = checkInfo.jiancha_didian;//plan.project_address;
    self.textShiGongDanWei.text = plan.construct_org;
    [checkInfo.have_stopwork isEqualToString:@"1" ]? [self.weiguiSwitch setOn:YES]:[self.weiguiSwitch setOn:NO] ;
    [checkInfo.have_rectify isEqualToString:@"1" ]? [self.weiguiSwitch setOn:YES]:[self.weiguiSwitch setOn:NO] ;
    self.textTingGong.text = checkInfo.stopwork_items;
    self.textZhengGai.text = checkInfo.rectify_items;
    self.textchedao.text   = checkInfo.closed_roadway;
    
    //    if([checkInfo.checkitem1 isEqualToString:@"1"]){self.textcheckitem1.text=@"是";}else{ self.textcheckitem1.text=@"否";}
    //    if([checkInfo.checkitem2 isEqualToString:@"1"]){self.textcheckitem2.text=@"是";}else{ self.textcheckitem2.text=@"否";}
    //    if([checkInfo.checkitem3 isEqualToString:@"1"]){self.textcheckitem3.text=@"是";}else{ self.textcheckitem3.text=@"否";}
    //    if([checkInfo.checkitem4 isEqualToString:@"1"]){self.textcheckitem4.text=@"是";}else{ self.textcheckitem4.text=@"否";}
    //    self.textcheckitem1.text = checkInfo.checkitem1;
    //    self.textcheckitem2.text = checkInfo.checkitem2;
    //    self.textcheckitem3.text = checkInfo.checkitem3;
    //    self.textcheckitem4.text = checkInfo.checkitem4;
    
    //    self.textrectify_no.text = checkInfo.rectify_no;
    //    self.textstopwork_no.text = checkInfo.stopwork_no;
    
    
    //    self.textduty_opinion.text = checkInfo.duty_opinion;
    //    self.textsafety.text = checkInfo.safety ;
    [self refeshsomething];
    //所有控制表格中行高亮的代码都只在这里
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
    [self.tableCloseList selectRowAtIndexPath:indexPath animated:nil scrollPosition:nil];
}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
}
-(void)selectFirstRow:(NSIndexPath *)indexPath{
    //当UITableView没有内容的时候，选择第一行会报错
    if([self.constructionList count]> 0){
        if (!indexPath) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        [self performSelector:@selector(selectRowAtIndexPath:)
                   withObject:indexPath
                   afterDelay:0];
    }else{
        [self btnAddNew:nil];
    }
}
- (void)refreshSwitch:(NSNotification *)notify{
    CGFloat alpha  = self.switchisTingGong.isOn?1.0:0.0;
    CGFloat pingbi = 0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelTingGong.alpha   = pingbi;
                        self.textstopwork_no.alpha = pingbi;
                        self.buttonTingGong.alpha  = alpha;
                        
                    }
                    completion:nil];
    
    CGFloat alpha2 = self.switchisZhengGai.isOn?1.0:0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelZhengGai.alpha  = pingbi;
                        self.textrectify_no.alpha = pingbi;
                        self.buttonZhengGai.alpha = alpha2;
                    }
                    completion:nil];
}
-(void)refeshsomething{
    CGFloat alpha  = self.weiguiSwitch.isOn?1.0:0.0;
    CGFloat pingbi = 0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelZhengGai.alpha = alpha;
                        self.labelTingGong.alpha = alpha;
                        self.textZhengGai.alpha  = alpha;
                        self.textTingGong.alpha  = alpha;
                    }
                    completion:nil];
}
//键盘出现和消失时，变动ScrollContent的contentSize;
-(void)keyboardWillShow:(NSNotification *)aNotification{
    for ( id view in self.scrollContent.subviews) {
        if ([view isFirstResponder]) {
            if ([view tag] >= 100) {
                [self.scrollContent setContentOffset:CGPointMake(0, 300) animated:YES];
            }
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    [self.scrollContent setContentOffset:CGPointMake(0, 0) animated:YES];
}

/*
 
 
 */
- (IBAction)SwitchChanged:(id)sender {
    UISwitch* iswitch =(UISwitch*)sender;
    CGFloat alpha = iswitch.isOn?1.0:0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelZhengGai.alpha = alpha;
                        self.labelTingGong.alpha = alpha;
                        self.textZhengGai.alpha  = alpha;
                        self.textTingGong.alpha  = alpha;
                    }
                    completion:nil];
}
- (IBAction)selectProject:(UITextField *)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        MaintainPlanPickerViewController *MaintainPlanPicker=[[ MaintainPlanPickerViewController alloc]init];
        MaintainPlanPicker.pickerType = 1;
        MaintainPlanPicker.delegate   = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:MaintainPlanPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(300, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        MaintainPlanPicker.pickerPopover = self.pickerPopover;
    }
}

- (IBAction)selectChedao:(UITextField *)sender {
    
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        ListSelectViewController *listselectervc=[[ListSelectViewController alloc] init];
        listselectervc.delegate = self;
        listselectervc.data     = [ Systype sysTypeArrayForCodeName:@"封闭车道"];
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:listselectervc];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        listselectervc.pickerPopover = self.pickerPopover;
    }
    
}
-(void) selectZhengGaiXM:(UITextField*)sender{
    if([self.pickerPopover isPopoverVisible]){
        [self.pickerPopover dismissPopoverAnimated:YES];
    }else{
    ListSelectViewController *listselectervc=[[ListSelectViewController alloc] init];
        listselectervc.delegate = self;
        listselectervc.data     = @[@"标志标牌摆放不整齐",@"限速牌摆放不合理"];
        listselectervc.setSelectedData = ^(NSString * data  ) {
            self.textZhengGai.text=data;
        };
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:listselectervc];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(240, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        listselectervc.pickerPopover = self.pickerPopover;

    }
}
- (void)setSelectData:(NSString *)data{
    self.textchedao.text = data;
}
@end
