//
//  TrafficRecordViewController.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-9.
//
//

#import "TrafficRecordViewController.h"
#import "TrafficRecord.h"
#import "InspectionConstructionCell.h"
#import "OrgInfo.h"

typedef enum{
    KNULL    = 0,
    KTextCar = 100,
    KTextInfocom,
    KTextFix,
    KTextProperty,
    KTextType,
    KTextCaseType,
    KTextHappentime,
    KTextStartKM,
    KTextStartM,
    KTextRoadsituation,
    KTextZjend,
    KTextZjstart,
    KTextLost,
    KTextIsend,
    KTextPaytype,
    KTextRemark,
    KTextClstart,
    KTextClend,
    KTextWdsituation,
} KUITextFieldTag;

enum kUISwitchTag {
    kUISwitchTagZJCLDate,     //拯救处理
    kUISwitchTagSGCLDate      //事故处理
};

@interface TrafficRecordViewController ()
@property (nonatomic,retain ) UIPopoverController *pickerPopover;
@property (retain, nonatomic) NSMutableArray      *accidentList;
@property (copy, nonatomic  ) NSString            *accidentID;
@end

@implementation TrafficRecordViewController {
    NSIndexPath *notDeleteIndexPath;
}

@synthesize accidentListTableView;
@synthesize textCar;
@synthesize textInfocom;
@synthesize textFix;
@synthesize textProperty;
@synthesize textType;
@synthesize textcase_type;
@synthesize textHappentime;
@synthesize textRoadsituation;
@synthesize textZjend;
@synthesize textZjstart;
@synthesize textLost;
@synthesize textIsend;
@synthesize textPaytype;
@synthesize textRemark;
@synthesize textClstart;
@synthesize textClend;
@synthesize textWdsituation;
@synthesize rel_id;
@synthesize pickerPopover;
@synthesize scrollView;
@synthesize accidentID = _accidentID;

@synthesize roadVC;

KUITextFieldTag KSelectedField = KNULL;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload{
    [self setTextStartM:nil];
    [self setTextStartKM:nil];
    [self setSwitchSGCLDate:nil];
    [self setSwitchZJCLDate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //text fields tag
    self.textCar.tag           = KTextCar;
    self.textInfocom.tag       = KTextInfocom;
    self.textFix.tag           = KTextFix;
    self.textStartKM.tag       = KTextStartKM;self.textStartKM.keyboardType= UIKeyboardTypeNumberPad;
    self.textStartM.tag        = KTextStartM;self.textStartM.keyboardType=UIKeyboardTypeNumberPad;
    self.textProperty.tag      = KTextProperty;
    self.textType.tag          = KTextType;         //事故分类
    self.textcase_type.tag     = KTextCaseType;     //事故类型
    self.textHappentime.tag    = KTextHappentime;
    self.textRoadsituation.tag = KTextRoadsituation;
    self.textZjend.tag         = KTextZjend;
    self.textZjstart.tag       = KTextZjstart;
    self.textLost.tag          = KTextLost;
    self.textIsend.tag         = KTextIsend;
    self.textPaytype.tag       = KTextPaytype;
    self.textRemark.tag        = KTextRemark;
    self.textClstart.tag       = KTextClstart;
    self.textClend.tag         = KTextClend;
    self.textWdsituation.tag   = KTextWdsituation;
    
    
    
    [self.switchZJCLDate setTag:kUISwitchTagZJCLDate];
    [self.switchSGCLDate setTag:kUISwitchTagSGCLDate];
    [self.switchZJCLDate setOn:NO];
    [self.switchSGCLDate setOn:NO];
    [self switchValueChanged:self.switchZJCLDate];
    [self switchValueChanged:self.switchSGCLDate];
    
    
    self.accidentList = [[TrafficRecord allTrafficRecord] mutableCopy];
    self.accidentID   = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationItem.title=@"交通事故登记";
    
    self.ShuntSwitch.on = NO;
    self.ShuntPlacetext.enabled = NO;
    self.ShutDownPlacetext.enabled = NO;
    [self.ShuntPlacetext setBackgroundColor:[UIColor lightGrayColor]];
    [self.ShutDownPlacetext setBackgroundColor:[UIColor lightGrayColor]];
    [self.CarDragontext setBackgroundColor:[UIColor lightGrayColor]];
    self.CarTypetext.tag = 333;
    [self initLabelText:nil];
     
//    [self.Loadmoney setHidden:YES];
    [self.accidentDieinjury setHidden:YES];
    [self.textWdsituation setHidden:YES];
    
    self.fleshwound.tag = 777;
    self.badwound.tag = 778;
    self.die.tag = 779;
    self.badcar.tag = 780;
    self.fleshwound.keyboardType = UIKeyboardTypeNumberPad;
    self.badwound.keyboardType = UIKeyboardTypeNumberPad;
    self.die.keyboardType = UIKeyboardTypeNumberPad;
    self.badcar.keyboardType = UIKeyboardTypeNumberPad;
}
- (void)initLabelText:(NSString *)data{
    if ([data length] == 0) {
        self.FirstDateLabel.text = @"现场封道开始时间";
        self.SecondDateLabel.text = @"现场封道结束时间";
        self.ThirdDateLabel.text = @"事故处理开始时间";
    }else if (![data isEqualToString:@"路政"]) {
        self.FirstDateLabel.text = @"路政人员出发时间";
        self.SecondDateLabel.text = @"路政人员到场时间";
        self.ThirdDateLabel.text = @"事故处理开始时间";
    }else{
        if (self.ShuntSwitch.on) {
            self.FirstDateLabel.text = @"现场交通中断时间";
            self.SecondDateLabel.text = @"现场封道结束时间";
            self.ThirdDateLabel.text = @"站台分流开始时间";
        }else if (self.ShuntSwitch.on == NO){
            self.FirstDateLabel.text = @"现场封道开始时间";
            self.SecondDateLabel.text = @"现场封道结束时间";
            self.ThirdDateLabel.text = @"事故处理开始时间";
        }
    }
}


-(void) viewWillDisappear:(BOOL)animated{
    //    if(![self.rel_id isEmpty]){
    //        TrafficRecord *tr =[TrafficRecord trafficRecordForID:self.accidentID];
    //        tr.rel_id=self.rel_id;
    //        [[AppDelegate App] saveContext];
    //
    //    }
//    [self TrafficRecordSave];
    //生成巡查记录
    TrafficRecord *tr =[TrafficRecord trafficRecordForID:self.accidentID];
    if (![self.rel_id isEmpty]&&self.roadVC && [[self.navigationController visibleViewController] isEqual:self.roadVC]) {
        if (![self.rel_id isEmpty]) {
            [self.roadVC createRecodeByTrafficRecord:tr];
            [self setRel_id:nil];
            [self setRoadVC:nil];
        }
    }
    
    [super viewWillDisappear:animated];
}
//弹出框不调出软键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==1 || textField.tag==2 || textField.tag == 4 || textField.tag == 3 || textField.tag == 5 || textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 17 ||textField.tag == 333) {
        return NO;
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
    return self.accidentList.count;
}


//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"TrafficCell";InspectionListCell
    static NSString *CellIdentifier  = @"TrafficCell";
    InspectionConstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        ;// cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    
    TrafficRecord  *constructionInfo=[self.accidentList objectAtIndex:indexPath.row];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    // cell.textLabel.text=[formatter stringFromDate:constructionInfo.inspectiondate];
    cell.textLabel.text=[formatter stringFromDate:constructionInfo.clstart];
    cell.textLabel.text = constructionInfo.car;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    NSString *local=[NSString stringWithFormat:@"K%d+%d,%@",constructionInfo.station.integerValue/1000,constructionInfo.station.integerValue%1000,constructionInfo.fix];
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
    
    //  [self initWithStyle:UITableViewCellStyleSubtitle];
    
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    if (constructionInfo.isuploaded.boolValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     id obj;
     if(indexPath){
     obj=[self.accidentList objectAtIndex:indexPath.row];
     }else{
     if(notDeleteIndexPath){
     obj=[self.accidentList objectAtIndex:notDeleteIndexPath.row];
     indexPath = notDeleteIndexPath;
     }
     }
     if(obj){
     [self selectFirstRow:indexPath];
     }else{
     [self selectFirstRow:nil];
     }
     */
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
        id obj=[self.accidentList objectAtIndex:indexPath.row];
        BOOL isPromulgated=[[obj isuploaded] boolValue];
        if (isPromulgated) {
            notDeleteIndexPath = indexPath;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:@"已上传信息，不能直接删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            
            
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            [context deleteObject:obj];
            [self.accidentList removeObject:obj];
            
            // InspectionConstruction *inspection = (InspectionConstruction *)obj;
            TrafficRecord *inspection =(TrafficRecord *)obj;
            NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[pathArray objectAtIndex:0];
            NSString *photoPath=[NSString stringWithFormat:@"交通事故照片/%@",inspection.myid];
            photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            [[NSFileManager defaultManager]removeItemAtPath:photoPath error:nil];
            
            [[AppDelegate App] saveContext];
            
            
            
            self.accidentID = @"";
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}


//xianshi    展示。显示
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TrafficRecord *accidentInfo = [self.accidentList objectAtIndex:indexPath.row];
    self.accidentID             = accidentInfo.myid;
    [self initLabelText:accidentInfo.infocome];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.textCar.text           = accidentInfo.car;
    self.textInfocom.text       = accidentInfo.infocome;
    self.textFix.text           = accidentInfo.fix;;
    self.textStartKM.text       = [ NSString stringWithFormat:@"%d", accidentInfo.station.integerValue/1000];
    self.textStartM.text        = [ NSString stringWithFormat:@"%3d", accidentInfo.station.integerValue%1000];
    self.textProperty.text      = accidentInfo.property;
    self.textType.text          = accidentInfo.type;
    self.textcase_type.text     = accidentInfo.case_type;
    
    self.textHappentime.text    = [formatter stringFromDate: accidentInfo.happentime];
    self.textRoadsituation.text = accidentInfo.roadsituation;
    self.textZjend.text         = [ formatter stringFromDate: accidentInfo.zjend];
    self.textZjstart.text =[ formatter stringFromDate: accidentInfo.zjstart ];
    self.textLost.text          = accidentInfo.lost;
    self.textIsend.text         = accidentInfo.isend;
    self.textPaytype.text       = accidentInfo.paytype;
    self.textRemark.text        = accidentInfo.remark;
    self.textlocation.text      = accidentInfo.location;
    self.textClstart.text       = [ formatter stringFromDate: accidentInfo.clstart];
    self.textClend.text         = [ formatter stringFromDate: accidentInfo.clend];
    self.textWdsituation.text   = accidentInfo.wdsituation;
    
    self.fleshwound.text = [NSString stringWithFormat:@"%ld",[accidentInfo.fleshwound_sum integerValue]];
    self.badwound.text = [NSString stringWithFormat:@"%ld",[accidentInfo.badwound_sum integerValue]];
    self.die.text = [NSString stringWithFormat:@"%ld",[accidentInfo.death_sum integerValue]];
    self.badcar.text = [NSString stringWithFormat:@"%ld",[accidentInfo.badcar_sum integerValue]];
    
    NSArray * array = [[NSUserDefaults standardUserDefaults]objectForKey:accidentInfo.myid];
    if([array count]>0){
        self.CarTypetext.text = [array objectAtIndex:0];
        if ([array count]>1) {
            self.TrafficLanestext.text = [array objectAtIndex:1];
//            self.ShuntSwitch.on = NO;

            if ([array count]>2) {
                NSString * shuntplace = [array objectAtIndex:2];
                if(shuntplace.length>0){
                    self.ShuntSwitch.on = YES;
                    [self ShuntSwitchClick:self.ShuntSwitch];
                }
                self.ShuntPlacetext.text = [array objectAtIndex:2];
                if ([array count]>3) {
                    self.ShutDownPlacetext.text = [array objectAtIndex:3];
                }
                if ([array count] >4) {
                    self.CarDragontext.text = [array objectAtIndex:4];
                }
            }
        }
    }
    
    //[self.switchZJCLDate setTag:kUISwitchTagZJCLDate];
    //[self.switchSGCLDate setTag:kUISwitchTagSGCLDate];
    if(accidentInfo.iszj){
        [self.switchZJCLDate setOn:YES];
    }else{
        [self.switchZJCLDate setOn:NO];
    }
    if(accidentInfo.issg){
        [self.switchSGCLDate setOn:YES];
    }else{
        [self.switchSGCLDate setOn:NO];
    }
    
    [self switchValueChanged:self.switchZJCLDate];
    [self switchValueChanged:self.switchSGCLDate];
    //    self.check_date.text =[formatter stringFromDate:checkInfo.check_date];
    //    self.constructionID=checkInfo.myid;
    //    self.textchecktype.text=checkInfo.checktype;
    //    self.textchecker.text=checkInfo.checker;
    //    self.maintainPlanID = checkInfo.maintainPlan_id;
    //    self.textMaintain.text = [MaintainPlan maintainPlanNameForID:checkInfo.maintainPlan_id ];
    //    if([checkInfo.checkitem1 isEqualToString:@"1"]){self.textcheckitem1.text=@"是";}else{ self.textcheckitem1.text=@"否";}
    //    if([checkInfo.checkitem2 isEqualToString:@"1"]){self.textcheckitem2.text=@"是";}else{ self.textcheckitem2.text=@"否";}
    //    if([checkInfo.checkitem3 isEqualToString:@"1"]){self.textcheckitem3.text=@"是";}else{ self.textcheckitem3.text=@"否";}
    //    if([checkInfo.checkitem4 isEqualToString:@"1"]){self.textcheckitem4.text=@"是";}else{ self.textcheckitem4.text=@"否";}
    //    self.textcheckitem1.text = checkInfo.checkitem1;
    //    self.textcheckitem2.text = checkInfo.checkitem2;
    //    self.textcheckitem3.text = checkInfo.checkitem3;
    //    self.textcheckitem4.text = checkInfo.checkitem4;
    //    [checkInfo.have_stopwork isEqualToString:@"1" ]? [self.switchisTingGong setOn:YES]:[self.switchisTingGong setOn:NO] ;
    //    [checkInfo.have_rectify isEqualToString:@"1" ]? [self.switchisZhengGai setOn:YES]:[self.switchisZhengGai setOn:NO] ;
    //    self.textrectify_no.text = checkInfo.rectify_no;
    //    self.textstopwork_no.text = checkInfo.stopwork_no;
    //    self.textcheck_remark.text = checkInfo.check_remark;
    //    self.textduty_opinion.text = checkInfo.duty_opinion;
    //    self.textsafety.text = checkInfo.safety ;
    //    [self refeshsomething];
    //所有控制表格中行高亮的代码都只在这里
    [self.accidentListTableView deselectRowAtIndexPath:[self.accidentListTableView indexPathForSelectedRow] animated:YES];
    [self.accidentListTableView selectRowAtIndexPath:indexPath animated:nil scrollPosition:nil];
}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:accidentListTableView didSelectRowAtIndexPath:indexPath];
}
-(void)selectFirstRow:(NSIndexPath *)indexPath{
    //当UITableView没有内容的时候，选择第一行会报错
    if([self.accidentList count]> 0){
        if (!indexPath) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        [self performSelector:@selector(selectRowAtIndexPath:)
                   withObject:indexPath
                   afterDelay:0];
    }else{
        //[self btnAddNew:nil];
    }
}
//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView setContentSize:self.self.scrollView.frame.size];
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    UIResponder *firstResponder = nil;
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isFirstResponder] && [subView isKindOfClass:[UITextField class]]) {
            firstResponder = subView;
        }
    }
    if (firstResponder) {
        CGRect firstResponderFrame = [(UIView *)firstResponder frame];
        CGRect keyboardFrame       = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGSize viewSize            = [self.view bounds].size;
        int realkbH                = keyboardFrame.size.height;
        if ((self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) && keyboardFrame.size.width < keyboardFrame.size.height) {
            realkbH                    = keyboardFrame.size.width;
        }
        int realkbY = viewSize.height - realkbH - self.scrollView.frame.origin.y;
        if (firstResponderFrame.size.height+firstResponderFrame.origin.y > realkbY) {
            int offset = firstResponderFrame.size.height+firstResponderFrame.origin.y - realkbY;
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+offset)];
            [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    if (sender.tag == kUISwitchTagZJCLDate) {
        [self.textZjstart setEnabled:sender.on];
        [self.textZjend setEnabled:sender.on];
        [self.textZjstart setBackgroundColor:sender.on?[UIColor whiteColor]:[UIColor lightGrayColor]];
        [self.textZjend setBackgroundColor:sender.on?[UIColor whiteColor]:[UIColor lightGrayColor]];
    } else if (sender.tag == kUISwitchTagSGCLDate) {
        [self.textClstart setEnabled:sender.on];
        [self.textClend setEnabled:sender.on];
        [self.textClstart setBackgroundColor:sender.on?[UIColor whiteColor]:[UIColor lightGrayColor]];
        [self.textClend setBackgroundColor:sender.on?[UIColor whiteColor]:[UIColor lightGrayColor]];
    }
}

- (IBAction)CarType:(id)sender {
    [self showListSelect:sender WithData:[Systype typeValueForCodeName:@"车型"]];
}

- (IBAction)ShuntSwitchClick:(id)sender {
    NSArray * array ;
    if(self.accidentID){
        array = [[NSUserDefaults standardUserDefaults]objectForKey:self.accidentID];
    }
    NSMutableArray * nsmuarray = [NSMutableArray arrayWithArray:array];
    [self initLabelText:self.textInfocom.text];
    if (self.ShuntSwitch.on) {
        self.ShuntPlacetext.enabled = YES;
        self.ShutDownPlacetext.enabled = YES;
        self.CarDragontext.enabled = YES;
        [self.ShuntPlacetext setBackgroundColor:[UIColor whiteColor]];
        [self.ShutDownPlacetext setBackgroundColor:[UIColor whiteColor]];
        [self.CarDragontext setBackgroundColor:[UIColor whiteColor]];
    } else {
        self.ShuntPlacetext.enabled = NO;
        self.ShutDownPlacetext.enabled = NO;
        self.CarDragontext.enabled = NO;
        [self.ShuntPlacetext setBackgroundColor:[UIColor lightGrayColor]];
        [self.ShutDownPlacetext setBackgroundColor:[UIColor lightGrayColor]];
        [self.CarDragontext setBackgroundColor:[UIColor lightGrayColor]];
        if([nsmuarray count] >4){
            [nsmuarray replaceObjectAtIndex:2 withObject:@""];
            [nsmuarray replaceObjectAtIndex:3 withObject:@""];
            [nsmuarray replaceObjectAtIndex:4 withObject:@""];
            NSArray * endArray = [ NSArray arrayWithArray:nsmuarray];
            [[NSUserDefaults standardUserDefaults] setObject:endArray forKey:self.accidentID];
            self.ShuntPlacetext.text = @"";
            self.ShutDownPlacetext.text = @"";
            self.CarDragontext.text = @"";
        }
        
    }
}

- (IBAction)btnSave:(id)sender{
    [self TrafficRecordSave];
}

- (void)TrafficRecordSave{
    if ([self isAllRequiredFieldDone] == NO) {
        return;
    }
    NSIndexPath *indexPath;
    TrafficRecord *tr = nil;
    if (self.accidentID ==nil) {
        tr                = [TrafficRecord newDataObjectWithEntityName:@"TrafficRecord"];
        self.accidentID   = tr.myid;
        indexPath         = [NSIndexPath indexPathForRow:[self.accidentList count] inSection:0];
    }
    else{
        tr = [TrafficRecord trafficRecordForID:self.accidentID];
        
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    tr.org_id=[[OrgInfo orgInfoForSelected] valueForKey:@"myid"];
    tr.location      = self.textlocation.text;
    tr.rel_id        = @"0";
    tr.car           = self.textCar.text.uppercaseString;
    tr.infocome      = self.textInfocom.text;
    tr.fix           = self.textFix.text;
    tr.property      = self.textProperty.text;
    tr.type          = self.textType.text;
    tr.case_type     = self.textcase_type.text;
    tr.happentime    = [dateFormatter dateFromString:self.textHappentime.text];
    tr.station       = @(self.textStartKM.text.integerValue*1000 + self.textStartM.text.integerValue);
    tr.roadsituation = self.textRoadsituation.text;
    
    tr.fleshwound_sum = self.fleshwound.text ? @([self.fleshwound.text integerValue]) : @(0);
    tr.badwound_sum = self.badwound.text ? @([self.badwound.text integerValue]) : @(0);
    tr.death_sum = self.die.text ? @([self.die.text integerValue]) : @(0);
    tr.badcar_sum = self.badcar.text ? @([self.badcar.text integerValue]) : @(0);
    
    
    if (self.switchZJCLDate.on) {
        tr.zjstart = [dateFormatter dateFromString:self.textZjstart.text];
        tr.zjend   = [dateFormatter dateFromString:self.textZjend.text];
        tr.iszj    = @(1);
    } else {
        tr.iszj = @(0);
    }
    tr.lost    = self.textLost.text;
    tr.isend   = self.textIsend.text;
    tr.paytype = self.textPaytype.text;
    tr.remark  = self.textRemark.text;
    if (self.switchSGCLDate.on) {
        tr.clstart = [dateFormatter dateFromString:self.textClstart.text];
        tr.clend   = [dateFormatter dateFromString:self.textClend.text];
        tr.issg    = @(1);
    } else {
        tr.issg = @(0);
    }
    tr.wdsituation = self.textWdsituation.text;
    NSLog(@"TrafficRecord saved:%@", tr);
    [[AppDelegate App] saveContext];
    NSMutableArray * nsmuarray = [[NSMutableArray alloc] init];
    NSString * cartype = self.CarTypetext.text.length ? self.CarTypetext.text:@"";
    [nsmuarray addObject:cartype];           //车辆类型
    NSString * TrafficLanes = self.TrafficLanestext.text.length ? self.TrafficLanestext.text:@"无";
    [nsmuarray addObject:TrafficLanes];        //可通行车道
    NSString * Shuntplace = self.ShuntPlacetext.text.length ? self.ShuntPlacetext.text : @"";
    [nsmuarray addObject:Shuntplace];           //分流地点
    NSString * ShutDownplace = self.ShutDownPlacetext.text.length ? self.ShutDownPlacetext.text : @"";
    [nsmuarray addObject:ShutDownplace];        //关闭入口
    NSString * Cardragon = self.CarDragontext.text.length ? self.CarDragontext.text :@"0";
    [nsmuarray addObject:Cardragon];
    NSArray * array = [NSArray arrayWithArray:nsmuarray];
    if (!self.ShuntSwitch.on) {
        [nsmuarray replaceObjectAtIndex:2 withObject:@""];
        [nsmuarray replaceObjectAtIndex:3 withObject:@""];
        [nsmuarray replaceObjectAtIndex:4 withObject:@""];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:tr.myid];
    
    //改到willdissapplear中处理
    //    if (![self.rel_id isEmpty] && self.roadVC) {
    //        [self.roadVC createRecodeByTrafficRecord:tr];
    //    }
    self.accidentList=[[ TrafficRecord allTrafficRecord] mutableCopy];
    [self.accidentListTableView reloadData];
    
    //当新增的时候，会在左侧的列表中添加一条新的记录，所以这条新的记录必须高亮
    if(indexPath){
        [self tableView:accidentListTableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    for (NSInteger i = 0; i < [self.accidentList count]; i++) {
        TrafficRecord *check=[self.accidentList objectAtIndex:i];
        if([check.myid isEqualToString:self.accidentID]){
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:accidentListTableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)btnCancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnNew:(UIButton *)sender {
    if(![self.accidentID isEmpty]){
        [self btnSave:nil];
    }
    self.accidentID             = nil;
    self.textCar.text           = @"";
    self.textInfocom.text       = @"";
    self.textFix.text           = @"";
    self.textStartKM.text =@"";//[ NSString stringWithFormat:@"%d", accidentInfo.station.integerValue/1000];
    self.textStartM.text =@"";// [ NSString stringWithFormat:@"%3d", accidentInfo.station.integerValue%1000];
    self.textProperty.text      = @"";
    self.textType.text          = @"";
    self.textcase_type.text     = @"";
    self.textHappentime.text    = @"";
    self.textRoadsituation.text = @"";
    self.textZjend.text         = @"";
    self.textZjstart.text =@"";
    self.textLost.text          = @"";
    self.textIsend.text         = @"";
    self.textPaytype.text       = @"";
    self.textRemark.text        = @"";
    self.textClstart.text       = @"";
    self.textClend.text         = @"";
    self.textWdsituation.text   = @"";
    
    self.CarTypetext.text = @"";
    self.TrafficLanestext.text = @"";
    self.ShuntPlacetext.text = @"";
    self.ShutDownPlacetext.text = @"";
    self.CarDragontext.text = @"";
    
    [self.switchZJCLDate setTag:kUISwitchTagZJCLDate];
    [self.switchSGCLDate setTag:kUISwitchTagSGCLDate];
    [self.switchZJCLDate setOn:NO];
    [self.switchSGCLDate setOn:NO];
    [self switchValueChanged:self.switchZJCLDate];
    [self switchValueChanged:self.switchSGCLDate];
    
    
}

- (IBAction)btnPhoto:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"toPhoto" sender:sender];
    if(self.accidentID == nil || [self.accidentID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一条记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    UIStoryboard *board            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    [next setValue:self.accidentID forKey:@"constructionId"];
    [self.navigationController pushViewController:next animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // 删除时
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (textField.tag == KTextStartKM || textField.tag == KTextStartM) {
        if (string.integerValue == 0 && ![string isEqualToString:@"0"]) {
            [[[UIAlertView alloc] initWithTitle:@"提醒" message:@"只允许输入数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == KTextStartKM || textField.tag == KTextStartM) {
        textField.text = [NSString stringWithFormat:@"%d",textField.text.integerValue];
    }else if(textField.tag == KTextCar){
        textField.text = textField.text.uppercaseString;
    }
}

- (IBAction)textTouch:(UITextField *)sender {
    NSLog(@"textTouch");
    if (sender.tag == KSelectedField) {
        if (self.pickerPopover && [self.pickerPopover isPopoverVisible]) {
            [self.pickerPopover dismissPopoverAnimated:YES];
            KSelectedField = KNULL;
            return;
        }
    }else{
        if (self.pickerPopover && [self.pickerPopover isPopoverVisible]) {
            [self.pickerPopover dismissPopoverAnimated:YES];
        }
    }
    KSelectedField = sender.tag;
    switch (sender.tag) {
        case KTextClstart:
        case KTextClend:
        case KTextHappentime:
        case KTextZjstart:
        case KTextZjend:
            [self showDateSelect:sender];
            break;
        case KTextInfocom:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"交警", @"监控", @"路政", nil]];
            break;
        case KTextFix:
            [self showRoadSideSelect:sender];
            break;
        case KTextProperty:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"简易程序", @"轻微", @"一般", @"重大" , @"特大", nil]];
            break;
        case KTextType:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"碰撞", @"碾压", @"刮擦", @"翻车", @"坠落", @"爆炸", @"着火", nil]];
            break;
        case KTextCaseType:
            [self showListSelect:sender WithData:[Systype typeValueForCodeName:@"事故类型"]];
            break;
//        case 444:
//            [self showListSelect:sender WithData:[Systype sysTypeArrayForCodeName:@"事故原因"]];
//            break;
        case KTextPaytype:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"直接赔偿", @"保险理赔", nil]];
            break;
        case  333:
            [self showListSelect:sender WithData:[Systype typeValueForCodeName:@"车型"]];
        default:
            break;
    }
}

-(void)showRoadSideSelect:(UITextField *)sender{
    RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
    icPicker.tableView.frame = CGRectMake(0, 0, 150, 243);
    icPicker.pickerState     = kRoadSide;
    icPicker.delegate        = self;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
    [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
    CGRect rect = sender.frame;
    [self.pickerPopover presentPopoverFromRect:rect inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    icPicker.pickerPopover = self.pickerPopover;
}

-(void)showListSelect:(UITextField *)sender WithData:(NSArray *)data{
    ListSelectViewController *listPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPoPover"];
    listPicker.delegate = self;
    listPicker.data     = data;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:listPicker];
    CGRect rect         = sender.frame;
    [self.pickerPopover presentPopoverFromRect:rect inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    listPicker.pickerPopover = self.pickerPopover;
}

-(void)showDateSelect:(UITextField *)sender{
    DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate   = self;
    datePicker.pickerType = 1;
    [datePicker showdate:sender.text];
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    CGRect rect = sender.frame;
    self.pickerPopover.popoverContentSize = CGSizeMake(200, 150);
    [self.pickerPopover presentPopoverFromRect:rect inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    datePicker.dateselectPopover = self.pickerPopover;
}

-(void)setDate:(NSString *)date{
    NSString *dateString = @"";
    if (![date isEmpty]) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        dateString=[dateFormatter stringFromDate:temp];
    }
    switch (KSelectedField) {
        case KTextClstart:
            self.textClstart.text = dateString;
            break;
        case KTextClend:
            self.textClend.text = dateString;
            break;
        case KTextHappentime:
            self.textHappentime.text = dateString;
            break;
        case KTextZjstart:
            self.textZjstart.text = dateString;
            break;
        case KTextZjend:
            self.textZjend.text = dateString;
            break;
        default:
            break;
    }
}

- (void)setSelectData:(NSString *)data{
    switch (KSelectedField) {
        case KTextInfocom:
            self.textInfocom.text = data;
            [self initLabelText:data];
            break;
        case KTextProperty:
            self.textProperty.text = data;
            break;
        case KTextType:
            self.textType.text = data;
            break;
        case KTextCaseType:
            self.textcase_type.text = data;
            break;
        case KTextPaytype:
            self.textPaytype.text = data;
            break;
        case 333:
            self.CarTypetext.text  = data;
            break;
        default:
            break;
    }
}

- (void)setRoadSide:(NSString *)side{
    self.textFix.text = side;
}

- (BOOL)isAllRequiredFieldDone{
    
    if ([self.textInfocom.text isEmpty]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"事故消息来源不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    }
    if ([self.textHappentime.text isEmpty]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"事故发生时间不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    }
    if (self.switchZJCLDate.on) {
        if ([self.textZjstart.text isEmpty]) {
            [[[UIAlertView alloc] initWithTitle:@"" message: [NSString  stringWithFormat:@"%@不可为空",self.FirstDateLabel.text] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return NO;
        }
//        if ([self.textZjstart.text isEmpty]) {
//            [[[UIAlertView alloc] initWithTitle:@"拯救处理已选择" message:@"拯救处理开始时间不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//            return NO;
//        }
        if ([self.textZjend.text isEmpty]) {
            [[[UIAlertView alloc] initWithTitle:@"" message:[NSString  stringWithFormat:@"%@不可为空",self.SecondDateLabel.text] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return NO;
        }
    }
    if (self.switchSGCLDate.on) {
        if ([self.textClstart.text isEmpty]) {
            [[[UIAlertView alloc] initWithTitle:@"" message:[NSString  stringWithFormat:@"%@不可为空",self.ThirdDateLabel.text] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return NO;
        }
        if ([self.textClend.text isEmpty]) {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"事故处理结束时间不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return NO;
        }
    }
    
    //必填字段的tag放进这个数组
    KUITextFieldTag requiredFields[] = {
        KTextCar
        //       ,
        //        KTextInfocom,
        //        KTextFix,
        //        KTextStartKM,
        //        KTextStartM,
        //        KTextHappentime,
        //        KTextProperty,
        //        KTextType,
        //        KTextWdsituation,
        //        KTextLost,
        //        KTextIsend,
        //        KTextPaytype
    };
    
    //必填字段对应的字段名字放进这个数组
    NSString *requiredFieldTitles[] = {
        @"肇事车辆",
        @"事故消息来源",
        @"事故方向",
        @"事故发生地点（桩号）",
        @"事故发生地点（桩号）",
        @"事故发生时间",
        @"事故性质",
        @"事故分类",
        @"事故伤亡情况",
        @"路产损失金额",
        @"是否结案",
        @"索赔方式"
    };
    
    NSString *textFieldTitle = nil;
    BOOL isAllDone           = YES;
    
    for (int i      = 0; i < sizeof(requiredFields)/sizeof(requiredFields[0]); i++) {
        UIView *subView = [self.view viewWithTag:requiredFields[i]];
        if ([subView isKindOfClass:[UITextField class]]){
            if ([[(UITextField*)subView text] isEmpty]) {
                textFieldTitle = requiredFieldTitles[i];
                isAllDone      = NO;
                break;
            }
        }
    }
    
    if (isAllDone == NO) {
        NSString *message = [NSString stringWithFormat:@"%@ 不可为空", textFieldTitle];
        [[[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    
    return isAllDone;
}

@end
