//
//  RoadInspectViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TrafficRemark.h"

#import "RoadInspectViewController.h"
#import "InspectionPath.h"
#import "Global.h"
#import "CaseConstructionChangeBackViewController.h"
#import "TrafficRecordViewController.h"
#import "CaseViewController.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"
#import "CaseDeformation.h"
#import "InspectionRecord.h"
#import "LawbreakingAction.h"
#import "MaintainPlanCheck.h"
#import "ShiGongCheckViewController.h"
#import "Times+CoreDataClass.h"
@class ServicesCheckViewController;
@interface RoadInspectViewController ()
@property (nonatomic,retain) NSMutableArray      *data;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,retain) NSString            * RecordID;
@property (nonatomic,retain) NSIndexPath         * selectedRecordIndex;

//巡查时过站记录和巡查记录关联中间值
@property (nonatomic,retain) NSString * infpectionpath_id;

@property (nonatomic,retain) NSString * inspectionrecordroadsegement;
@property (nonatomic,retain) UILabel * label;

//判断当前显示的巡查是否是正在进行的巡查
@property (nonatomic,assign) BOOL isCurrentInspection;
- (void)loadInspectionInfo;
- (void)saveRemark;
@end

@implementation RoadInspectViewController
@synthesize pathView            = _pathView;
@synthesize labelInspectionInfo = _labelInspectionInfo;
@synthesize textViewRemark      = _textViewRemark;
@synthesize tableRecordList     = _tableRecordList;
@synthesize labelRemark         = _labelRemark;
@synthesize inspectionSeg       = _inspectionSeg;
@synthesize textCheckTime       = _textCheckTime;
@synthesize textStationName     = _textStationName;
@synthesize inspectionID        = _inspectionID;
//@synthesize inspectRecordID = _inspectRecordID;
@synthesize isCurrentInspection = _isCurrentInspection;
@synthesize state               = _state;
@synthesize pickerPopover       = _pickerPopover;
@synthesize textCheckStatus     = _textCheckStatus;
@synthesize mysegue             = _mysegue;

InspectionCheckState inspectionState;

- (void)viewDidLoad
{
    self.state               = kRecord;
    UIFont *segFont          = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.inspectionSeg setTitleTextAttributes:attributes
                                      forState:UIControlStateNormal];
    
//    self.textViewRemark.delegate = self;
    
    [super viewDidLoad];
    self.textViewRemark.editable = YES;
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
    
    ServicesCheckViewController *servicesCheckVC = [secondStoryboard instantiateViewControllerWithIdentifier:@"servicesCheckVC"];
    self.mysegue =[[UIStoryboardSegue alloc] initWithIdentifier:@"toServicesCheck" source:self destination:servicesCheckVC];
    // Do any additional setup after loading the view.
    
//    self.inspectionRecordtext.enabled = NO;
    self.label = [[UILabel alloc] initWithFrame:self.inspectionRecordtext.frame];
    [self.pathView addSubview:self.label];
    [self.inspectionRecordtext setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    self.inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    self.isCurrentInspection = YES;
    BOOL isJiangzhong        = [[[AppDelegate App].projectDictionary objectForKey:@"projectname"] isEqualToString:@"zhongjiang"];
    if (([self.inspectionID isEmpty] || self.inspectionID==nil) && !isJiangzhong) {
        [self performSegueWithIdentifier:@"toNewInspection" sender:nil];
    } else {
        [self loadInspectionInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [self setTextViewRemark:nil];
    [self setTableRecordList:nil];
    [self setLabelRemark:nil];
    [self setLabelInspectionInfo:nil];
    [self setPathView:nil];
    [self setUiButtonAddNew:nil];
    [self setUiButtonSave:nil];
    [self setUiButtonDeliver:nil];
    [self setPickerPopover:nil];
    [self setInspectionSeg:nil];
    [self setTextCheckTime:nil];
    [self setTextStationName:nil];
    [self setTextCheckStatus:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *segueIdentifer=[segue identifier];
    if ([segueIdentifer isEqualToString:@"toAddNewInspectionRecord"]) {
        AddNewInspectRecordViewController *newRCVC = segue.destinationViewController;
        newRCVC.inspectionID                       = self.inspectionID;
        newRCVC.delegate                           = self;
    } else if ([segueIdentifer isEqualToString:@"toNewInspection"]) {
        NewInspectionViewController *niVC=[segue destinationViewController];
        niVC.delegate = self;
    } else if ([segueIdentifer isEqualToString:@"toInspectionOut"]) {
        InspectionOutViewController *ioVC=[segue destinationViewController];
//        ioVC.inspectionID = self.inspectionID;
        ioVC.delegate = self;
    } else if ([segueIdentifer isEqualToString:@"toCounstructionChangeBack"]){
        CaseConstructionChangeBackViewController *caseVC = segue.destinationViewController;
        [caseVC setRel_id:self.inspectionID];
    } else if ([segueIdentifer isEqualToString:@"toTrafficRecord"]){
        TrafficRecordViewController *trVC = segue.destinationViewController;
        [trVC setRel_id:self.inspectionID];
        [trVC setRoadVC:self];
    } else if ([segueIdentifer isEqualToString:@"inspectToCaseView"]){
        CaseViewController *caseVC = segue.destinationViewController;
        [caseVC setInspectionID:self.inspectionID];
        [caseVC setRoadInspectVC:self];
    }else if ([segue.identifier isEqualToString:@"toUnderBridgeCheck"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        AttachmentViewController *receive = segue.destinationViewController;
        //receive.name = @"Garvey";
        //receive.age = 110;
        InspectionRecord *record          = [InspectionRecord lastRecordsForInspection:self.inspectionID];
        // NSString *constructionId= self.RecordID;
        [receive setValue:record.myid forKey:@"constructionId"];
    }else if ([segueIdentifer isEqualToString:@"insepectToAdminisCaseView"]){
        CaseViewController *caseVC = segue.destinationViewController;
        [caseVC setInspectionID:self.inspectionID];
        [caseVC setRoadInspectVC:self];
    }else if ([segueIdentifer isEqualToString:@"inspectToShiGongCheck"]){
        ShiGongCheckViewController *ShiGongVC = segue.destinationViewController;
        [ShiGongVC setInspectionID:self.inspectionID];
        [ShiGongVC setRoadInspectVC:self];
    }else if ([segueIdentifer isEqualToString:@"inspectToBaoxianCase"]){
        BaoxianCaseViewController *baoxiancase = segue.destinationViewController;
        [baoxiancase setInspectionID:self.inspectionID];
        [baoxiancase setRoadInspectVC:self];
    }
}
-(void) setxxx:(NSString *)inspectRecordID{
    //return nil;
    self.RecordID = inspectRecordID;
}
#pragma mark - TableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer=@"InspectionRecordCell";
    InspectionRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (self.state == kRecord) {
        InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
        self.RecordID            = record.myid;
        cell.labelRemark.text    = record.remark;
        NSInteger stationStartM  = record.station.integerValue%1000;
        NSInteger stationStartKM = record.station.integerValue/1000;
        NSString *stationString=[NSString stringWithFormat:@"K%02d+%03d处",stationStartKM,stationStartM];
        cell.labelStation.hidden = NO;
        if(record.station.integerValue>0){
            cell.labelStation.text = stationString;
        }else{
            cell.labelStation.text=@"";
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        cell.labelTime.text=[dateFormatter stringFromDate:record.start_time];
    } else {
        self.RecordID         = nil;
        InspectionPath * path  = [self.data objectAtIndex:indexPath.row];
        cell.labelRemark.text = path.stationname;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        cell.labelTime.text      = [dateFormatter stringFromDate:path.checktime];
        cell.labelStation.text   = @"";
        cell.labelStation.hidden = YES;
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj=[self.data objectAtIndex:indexPath.row];
    InspectionRecord * record;
    if (self.state == kPath) {
        InspectionPath * path = (InspectionPath *)obj;
        record = [InspectionRecord RecordsForInspection_relationid:path.myid];
    }
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    if (record) {
        [context deleteObject:record];
    }
    [context deleteObject:obj];
    [self.data removeObjectAtIndex:indexPath.row];
    [[AppDelegate App] saveContext];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];
    
    //add by lxm
    //清除巡查描述内容
    self.textViewRemark.text=@"";
    self.RecordID = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.state == kRecord) {
        InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
        self.textViewRemark.text = record.remark;
        self.RecordID            = record.myid;
        self.selectedRecordIndex = indexPath;
    } else {
        InspectionPath *path = [self.data objectAtIndex:indexPath.row];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textCheckTime.text = [dateFormatter stringFromDate:path.checktime];
        
        NSString *tmp         = [path.stationname substringToIndex:2];
        NSString *stationName = path.stationname;
        if ([tmp isEqualToString:@"经过"] || [tmp isEqualToString:@"回到"]) {
            self.textCheckStatus.text = tmp;
            stationName               = [path.stationname substringFromIndex:[tmp length]];
        }
        NSRange found = [stationName rangeOfString:@"沿途状况正常"];
        if (found.location != NSNotFound) {
            stationName   = [stationName substringToIndex:found.location];
        }
        self.textStationName.text = stationName;
    }
}

#pragma mark - InspectionHandler

- (void)reloadRecordData{
    if (self.state == kRecord) {
        self.data=[[InspectionRecord recordsForInspection:self.inspectionID] mutableCopy];
        [self.pathView setHidden:YES];
        [self.view sendSubviewToBack:self.pathView];
    } else {
        self.data=[[InspectionPath pathsForInspection:self.inspectionID] mutableCopy];
        [self.pathView setHidden:NO];
        [self.view bringSubviewToFront:self.pathView];
        self.label.text = [self InspectionPathStationRoadline];
    }
    [self.tableRecordList reloadData];
//    self.inspectionRecordtext.text = [self InspectionPathStationRoadline];
    
}

- (void)setInspectionDelegate:(NSString *)aInspectionID{
    self.inspectionID = aInspectionID;
    [self loadInspectionInfo];
}

- (void)popBackToMainView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addObserverToKeyBoard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - own methods
//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (self.state == kRecord) {
        CGRect newFrame           = self.textViewRemark.frame;
        newFrame.origin.y         = 454;
        newFrame.size.height      = 230;
        //    CGFloat offset=self.textViewRemark.frame.origin.y-newFrame.origin.y;
        self.textViewRemark.frame = newFrame;
        
        CGRect viewFrame   = self.view.frame;
        viewFrame.origin.y = 60;
        self.view.frame    = viewFrame;
    }
    if (!self.selectedRecordIndex.row) {
       
    }else{
        [self saveRemark];
    }
    [UIView commitAnimations];
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (self.state == kRecord) {
        NSValue *keyboardRectAsObject=[[aNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect;
        [keyboardRectAsObject getValue:&keyboardRect];
        
        CGRect newFrame    = self.textViewRemark.frame;
        CGRect viewFrame   = self.view.frame;
        viewFrame.origin.y = keyboardEndFrame.size.height*-1+100;
        newFrame.origin.y  = 66;
        //newFrame.size.height = self.view.frame.size.height - (self.view.frame.origin.y + newFrame.origin.y) - keyboardEndFrame.size.width-5;
        //CGFloat offset=self.textViewRemark.frame.origin.y-newFrame.origin.y;
        NSLog(@"gao :%f;kuan:%f",newFrame.size.height,newFrame.size.width );
        CGFloat shadw             = 0.0;
        //self.inspectionSeg.alpha=shadw;
        // self.view.frame=viewFrame;
        self.textViewRemark.frame = newFrame;
        [self.view bringSubviewToFront:self.textViewRemark];
    }
    [UIView commitAnimations];
}

//保存并在过站记录里生成巡查描述
- (IBAction)btnSaveRemark:(UIButton *)sender {
    if (self.state == kRecord) {
        [self saveRemark];
    } else {
        if (![self.textCheckTime.text isEmpty] && ![self.textStationName.text isEmpty] && ![self.textCheckStatus.text isEmpty]) {
            
            NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
            InspectionPath *newPath;
            if (index==nil) {
                newPath = [InspectionPath newDataObjectWithEntityName:@"InspectionPath"];
                [self.data addObject:newPath];
            } else {
                newPath = [self.data objectAtIndex:index.row];
            }
            NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            newPath.checktime    = [dateFormatter dateFromString:self.textCheckTime.text];
            newPath.stationname  = self.textStationName.text;
            newPath.inspectionid = self.inspectionID;
            self.infpectionpath_id = newPath.myid;
            [[AppDelegate App] saveContext];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否生成巡查记录?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert show];
            
        }
        [self reloadRecordData];
    }
    [self.view endEditing:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //过站记录生成巡查记录
        InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
        inspectionRecord.relationid     = self.infpectionpath_id;
        inspectionRecord.inspection_id  = self.inspectionID;
        inspectionRecord.roadsegment_id = @"0";
        inspectionRecord.relationType = @"过站记录";
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        inspectionRecord.start_time=[dateFormatter dateFromString:self.textCheckTime.text];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        
        NSString * timeString = [dateFormatter stringFromDate:inspectionRecord.start_time];
        
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Systype" inManagedObjectContext:context];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@ && type_value == %@",@"过站状况", self.textCheckStatus.text]];
        NSArray *result     = [context executeFetchRequest:fetchRequest error:nil];
        NSString *strFormat = @"%@ %@";
        if (result && [result count]>0) {
            NSString *remark = [[result objectAtIndex:0] remark];
            if (![remark isEmpty]) {
                strFormat = [NSString stringWithFormat:@"%@ %@", @"%@", [remark stringByReplacingOccurrencesOfString:@"[站]" withString:@"%@"]];
            }
        }
        NSString *remark=[NSString stringWithFormat:strFormat, timeString, self.textStationName.text];
        inspectionRecord.remark = remark;
        [[AppDelegate App] saveContext];
        [self reloadRecordData];
    }else{
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    self.infpectionpath_id = @"0";
}
- (IBAction)btnToFujian:(id)sender{
    
    /*if(self.constructionID == nil || [self.constructionID isEmpty]){
     UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一条物料检查记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alter show];
     return;
     }*/
    UIStoryboard *board            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    [next setValue:self.RecordID forKey:@"constructionId"];
    [self.navigationController pushViewController:next animated:YES];
    
    
}

- (void)saveRemark{
    if (![self.textViewRemark.text isEmpty]) {
        //通过tv 确定选择项
        /*
         NSIndexPath *indexPath=[self.tableRecordList indexPathForSelectedRow];
         if (indexPath!=nil) {
         InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
         record.remark = self.textViewRemark.text;
         [[AppDelegate App] saveContext];
         [self.tableRecordList beginUpdates];
         [self.tableRecordList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
         [self.tableRecordList endUpdates];
         }RecordID
         */
        //通过记录选择项       输入闪退
        InspectionRecord * record = [self.data objectAtIndex:self.selectedRecordIndex.row];
//        InspectionRecord * record = [InspectionRecord  recordsForInspection:_RecordID];
        record.remark = self.textViewRemark.text;
        [[AppDelegate App] saveContext];
        [self.tableRecordList beginUpdates];
        [self.tableRecordList reloadRowsAtIndexPaths:@[self.selectedRecordIndex] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableRecordList endUpdates];
    }
}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    if (self.selectedRecordIndex.row) {
//        return YES;
//    }else{
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择想要修改的描述" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    return NO;
//
//}
- (IBAction)btnInpectionList:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        InspectionListViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionList"];
        acPicker.delegate = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(270, 352)];
        [self.pickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        acPicker.popover = self.pickerPopover;
    }
}
- (IBAction)btnAddNew:(id)sender {
    if (self.state == kRecord) {
        [self performSegueWithIdentifier:@"toAddNewInspectionRecord" sender:nil];
    } else {
        for (UITextField *textField in self.pathView.subviews) {
            if ([textField isKindOfClass:[UITextField class]]) {
                textField.text = @"";
            }
        }
        NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
        if (index) {
            [self.tableRecordList deselectRowAtIndexPath:index animated:YES];
        }
    }
}
 //交班
- (IBAction)btnDeliver:(UIButton *)sender {
    if (self.isCurrentInspection) {
        [self performSegueWithIdentifier:@"toInspectionOut" sender:nil];
    } else {
        self.isCurrentInspection = YES;
        [UIView transitionWithView:self.view
                          duration:0.3
                           options:UIViewAnimationCurveLinear
                        animations:^{
                            CGRect rect     = self.uiButtonDeliver.frame;
                            rect.size.width = 72;
                            [self.uiButtonDeliver setFrame:rect];
                            [sender setTitle:@"交班" forState:UIControlStateNormal];
                            [self.uiButtonAddNew setAlpha:1.0];
                            [self.uiButtonSave setAlpha:1.0];
                        }
                        completion:^(BOOL finish){
                            [self.uiButtonSave setEnabled:YES];
                            [self.uiButtonAddNew setEnabled:YES];
                        }];
        self.inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
        [self loadInspectionInfo];
    }
}
//选择过站记录
- (IBAction)segSwitch:(id)sender {
    //add by 李晓明 2013.05.09
    //选择switch的时候，取消焦点
    [self.textViewRemark resignFirstResponder];
    if (self.inspectionSeg.selectedSegmentIndex == 0) {//巡查记录
        self.state = kRecord;
    } else {          //过站记录
        self.state    = kPath;
        self.RecordID = nil;
        
        self.roadsegmentText.text = self.inspectionrecordroadsegement;
//        [self.inspectionRecordtext setHidden:YES];
//        [self.inspectionRecordlabel setHidden:YES];
//        [self.inspectionRecordtextButton setHidden:YES];
//        [self.roadsegmentText setHidden:YES];
    }
    [self reloadRecordData];
}

- (NSString *)InspectionPathStationRoadline{
    NSString * roadline = @"";
    NSString* station = @"";
    if ([self.data count] >0) {
        InspectionPath * temp = (InspectionPath * )self.data[0];
        roadline = [self selectStationforNSString:temp.stationname];
        station = temp.stationname;
        for (NSInteger i = 0; i<[self.data count]; i++){
            InspectionPath * path  = [self.data objectAtIndex:i];
            NSLog(@"%@",path.stationname);
            if(![path.stationname isEqualToString:station]){
                if ([path.stationname containsString:@"服务区"] ||[path.stationname isEqualToString:@"镇海湾大桥"]) {
                    continue;
                }
                roadline = [NSString stringWithFormat:@"%@-%@",roadline,[self selectStationforNSString:path.stationname]];
                station = path.stationname;
//                NSLog(@"传值数据%@",station);
            }
        }
        return roadline;
    }
    return nil;
    
    
}

-(NSString *)selectStationforNSString:(NSString *)station{
    NSString * returnStation;
    returnStation = [[[[station stringByReplacingOccurrencesOfString:@"收费站" withString:@""] stringByReplacingOccurrencesOfString:@"入口站" withString:@""] stringByReplacingOccurrencesOfString:@"管理所" withString:@""] stringByReplacingOccurrencesOfString:@"d" withString:@""];
    return returnStation;
}
//出发站点
- (IBAction)selectionStation:(id)sender {//  站点选择
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        InspectionCheckPickerViewController *icPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState = kStation;
        inspectionState      = kStation;
        icPicker.delegate    = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover presentPopoverFromRect:[sender frame] inView:self.pathView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover = self.pickerPopover;
    }
}
//过站时间
- (IBAction)selectTime:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate   = self;
        datePicker.pickerType = 1;
        [datePicker showdate:self.textCheckTime.text];
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        CGRect rect = [self.view convertRect:[sender frame] fromView:self.pathView];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover = self.pickerPopover;
    }
}
//往站点方向巡查
- (IBAction)selectCheckStatus:(id)sender{
    //过站
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState = kStationCheckStatus;
        inspectionState      = kStationCheckStatus;
        icPicker.delegate    = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover presentPopoverFromRect:[sender frame] inView:self.pathView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover = self.pickerPopover;
    }
}

- (void)loadInspectionInfo{
    NSArray *temp=[Inspection inspectionForID:self.inspectionID];
    if (temp.count>0) {
        Inspection *inspection=[temp objectAtIndex:0];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        self.labelInspectionInfo.text=[[NSString alloc] initWithFormat:@"%@   %@   巡查车辆:%@   巡查人:%@   记录人:%@",[formatter stringFromDate:inspection.date_inspection],inspection.weather,inspection.carcode,inspection.inspectionor_name,inspection.recorder_name];
    }
    for (UITextField *textField in self.pathView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text = @"";
        }
    }
    NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
    if (index) {
        [self.tableRecordList deselectRowAtIndexPath:index animated:YES];
    }
    self.textViewRemark.text = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self reloadRecordData];
}

- (void)setCurrentInspection:(NSString *)inspectionID{
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationCurveLinear
                    animations:^{
                        CGRect rect     = self.uiButtonDeliver.frame;
                        rect.size.width = 126;
                        [self.uiButtonDeliver setFrame:rect];
                        [self.uiButtonDeliver setTitle:@"返回当前巡查" forState:UIControlStateNormal];
                        [self.uiButtonAddNew setAlpha:0.0];
                        [self.uiButtonSave setAlpha:0.0];
                    }
                    completion:^(BOOL finish){
                        [self.uiButtonSave setEnabled:NO];
                        [self.uiButtonAddNew setEnabled:NO];
                    }];
    self.isCurrentInspection = NO;
    self.inspectionID        = inspectionID;
    [self loadInspectionInfo];
}

- (void)setCheckText:(NSString *)checkText{
    if (self.state == kPath) {
        if (inspectionState == kStationCheckStatus) {
            self.textCheckStatus.text = checkText;
        }else{
            self.textStationName.text = checkText;
        }
    }
}

- (void)setDate:(NSString *)date{
    self.textCheckTime.text = date;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}


- (void) createRecodeByCaseID:(NSString *)caseID{
    if ([caseID isEmpty]) {
        return;
    }
    CaseInfo *caseInfo              = [CaseInfo caseInfoForID:caseID];
    CaseProveInfo *proveInfo        = [CaseProveInfo proveInfoForCase:caseID];
    NSArray* times=[Times  TimesByParent_id:caseID];
    
    NSString *desc                  = [LawbreakingAction LawbreakingActionCaptionForID:proveInfo.case_desc_id];
    //CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    Citizen *citizen                = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:caseID];
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    inspectionRecord.roadsegment_id = caseInfo.roadsegment_id;
    inspectionRecord.location       = caseInfo.place;
    inspectionRecord.station        = caseInfo.station_start;
    inspectionRecord.inspection_id  = self.inspectionID;
    inspectionRecord.relationid     = @"0";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    inspectionRecord.start_time = caseInfo.happen_date;
    
    [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
    NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
    NSMutableString *remark=[[NSMutableString alloc] initWithFormat:@"%@ 巡至%@%@方向K%@+%@m处时，发现%@驾驶%@%@在%@发生交通事故，",timeString, [RoadSegment roadNameFromSegment:caseInfo.roadsegment_id], caseInfo.side, [caseInfo station_start_km], [caseInfo station_start_m], citizen.party, citizen.automobile_number, citizen.automobile_pattern, caseInfo.place];
    [remark appendFormat:@"%@接报，%@到场，",timeString,timeString];
    //[remark appendFormat:@"经现场勘验检查认定%@的事实为,",desc]; //NSString [alloc stringByAppendingFormat:@"经现场勘验检查认定（案由）的事实为,"
    [remark appendString:@"经现场勘验检查认定"];
    [remark appendString:desc];
    [remark appendString:@"的事实为,"];
    if ([caseInfo.fleshwound_sum intValue]==0 && [caseInfo.badwound_sum intValue]==0 && [caseInfo.death_sum intValue]==0) {
        [remark appendString:@"无人员伤亡，"];
    }else{
        [remark appendFormat:@"轻伤%@人，重伤%@人，死亡%@人，", caseInfo.fleshwound_sum, caseInfo.badwound_sum, caseInfo.death_sum];
    }
    NSArray *deformArray=[CaseDeformation deformationsForCase:caseID forCitizen:citizen.automobile_number];
    if (deformArray.count>0) {
        NSString *deformsString=@"";
        float   all = 0;
        for (CaseDeformation *deform in deformArray) {
            NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([roadSizeString isEmpty]) {
                roadSizeString=@"";
            } else {
                roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
            }
            NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([remarkString isEmpty]) {
                remarkString=@"";
            } else {
                remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
            }
            NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
//            NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
            all += deform.total_price.floatValue;
//            quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
            deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
        }
        NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
        deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
        //[deformsString appendFormat:@",%@。",[[NSString alloc] initWithFormat:@"%.2f",all]];
        [remark appendFormat:@"损坏路产如下：%@。",deformsString];
        [remark appendFormat:@"共计金额%@元。",[[NSString alloc] initWithFormat:@"%.2f",all]];
        
        // [remark stringByAppendingFormat:@"%@接报，%@到场，",timeString,timeString];
    } else {
        [remark appendString:@"无路产损坏。"];
    }
    [remark appendFormat:@"现场开具路产文书由事主签认。"];
    for (Times *atime in times) {
        NSDateFormatter *formator=[[NSDateFormatter alloc]init];
        formator.locale=[NSLocale currentLocale];
        formator.dateFormat=@"hh:mm";
        if ([atime.name isEqualToString:@"tuocheTime"]) {
            if ([dateFormatter stringFromDate:atime.time].length>0) {
                [remark appendFormat:@"%@拖车到场，",[dateFormatter stringFromDate:atime.time]];
            }
        }
        if ([atime.name isEqualToString:@"jiaojingTime"]) {
            if ([dateFormatter stringFromDate:atime.time].length>0) {
                [remark appendFormat:@"%@交警到场，",[dateFormatter stringFromDate:atime.time]];
            }
        }
        if ([atime.name isEqualToString:@"overTime"]) {
            if ([dateFormatter stringFromDate:atime.time].length>0) {
                [remark appendFormat:@"%@处理完毕，",[dateFormatter stringFromDate:atime.time]];
            }    
        }
    }
    //[remark appendFormat:@"现场开具路产文书由事主签认。%@拖车到场，%@交警到场，%@处理完毕，已拍照，已报监控。",timeString,timeString,timeString];
     [remark appendFormat:@"已拍照，已报监控。"];
    [remark appendFormat:@"已立案处理（案号：%@高赔（%@）第（%@）号）。", [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.case_mark2, [caseInfo full_case_mark3]];
    
    
    NSMutableString *adminis_remark=[[NSMutableString alloc] initWithFormat:@"%@,%@发现%@%@%@%@在%@%@K%@+%@m %@处%@%@。现场已制作法律文书由施工负责人签认，已拍照取证，已报监控中心。",timeString, caseInfo.case_type, citizen.address,citizen.org_name,citizen.org_principal_duty,citizen.party,  [RoadSegment roadNameFromSegment:caseInfo.roadsegment_id], caseInfo.side, [caseInfo station_start_km], [caseInfo station_start_m],caseInfo.place, desc,caseInfo.peccancy_type];
    //[adminis_remark appendFormat:@"已立案处理（案号：%@高赔（%@）第（%@）号）。", [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.case_mark2, [caseInfo full_case_mark3]];
    if(caseInfo.case_type_id.intValue==11){
        
        inspectionRecord.remark = remark;
    }else{
        inspectionRecord.remark = adminis_remark;
    }
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
}
- (void) createRecodeByShiGongCheckID:(NSString *)shiGongCheckID{
    if ([shiGongCheckID isEmpty]) {
        return;
    }
    CaseInfo *caseInfo       = [CaseInfo caseInfoForID:shiGongCheckID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:shiGongCheckID];
    NSString *desc           = [LawbreakingAction LawbreakingActionCaptionForID:proveInfo.case_desc_id];
    //CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    Citizen *citizen         = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:shiGongCheckID];
    MaintainPlanCheck *checkInfo=[[MaintainPlanCheck maintainCheckForID:shiGongCheckID] objectAtIndex:0];
    
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    /*
     inspectionRecord.roadsegment_id = caseInfo.roadsegment_id;
     inspectionRecord.location       = caseInfo.place;
     inspectionRecord.station        = caseInfo.station_start;
     inspectionRecord.inspection_id  = self.inspectionID;
     inspectionRecord.relationid     = @"0";
     
     
     NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
     [dateFormatter setLocale:[NSLocale currentLocale]];
     inspectionRecord.start_time = caseInfo.happen_date;
     
     [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
     NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
     NSMutableString *remark=[[NSMutableString alloc] initWithFormat:@"%@巡至%@往%@方向K%@+%@m处时，发现%@驾驶%@%@在%@发生交通事故，",timeString, [RoadSegment roadNameFromSegment:caseInfo.roadsegment_id], caseInfo.side, [caseInfo station_start_km], [caseInfo station_start_m], citizen.party, citizen.automobile_number, citizen.automobile_pattern, caseInfo.place];
     [remark appendFormat:@"%@接报，%@到场，",timeString,timeString];
     inspectionRecord.remark = remark;
     */
    inspectionRecord.start_time = checkInfo.check_date;
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setLocale:[NSLocale currentLocale]];
    formater.dateFormat=@"hh:mm";
    NSString * remark=[formater stringFromDate:checkInfo.check_date];
    remark=[ NSString stringWithFormat:@"%@ 检查%@",  remark  ,checkInfo.checkitem1];
    inspectionRecord.remark        = remark ;
    inspectionRecord.inspection_id = self.inspectionID;
    inspectionRecord.relationid    = @"0";
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
}
- (void) createRecodeByTrafficRecord:(TrafficRecord *)trafficRecord{
    if(trafficRecord.infocome.length){
        InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
        //要把交通事故的照片带过来
        inspectionRecord.myid           = trafficRecord.myid;
        inspectionRecord.roadsegment_id = @"0";
        inspectionRecord.fix            = trafficRecord.fix;
        inspectionRecord.inspection_id  = self.inspectionID;
        inspectionRecord.relationid     = @"0";
        inspectionRecord.start_time     = trafficRecord.happentime;
        inspectionRecord.station        = trafficRecord.station;
        //    [Remark createTrafficwithRemark:trafficRecord];
        NSString * remark = [TrafficRemark createTrafficRecordForRemark:trafficRecord];
        inspectionRecord.remark = remark;
        [[AppDelegate App] saveContext];
        [self reloadRecordData];
    }
}
- (void) createRecodeByDynamicInfo:(RoadWayClosed *)DynamicInfo{
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    inspectionRecord.roadsegment_id = DynamicInfo.roadsegment_id;    inspectionRecord.fix = DynamicInfo.fix;
    inspectionRecord.inspection_id  = self.inspectionID;
    inspectionRecord.relationid     = DynamicInfo.myid;//@"0";
    inspectionRecord.start_time     = DynamicInfo.time_start;
    inspectionRecord.station        = DynamicInfo.station_start;
    //NSString* stationString = [NSString stringWithFormat:@"K%d+%dM", DynamicInfo.station_start.integerValue/1000, DynamicInfo.station_start.integerValue%1000];
    NSString *remark                = DynamicInfo.closed_reason;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    
    inspectionRecord.remark = remark;
    
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
}
- (void) createRecodeByBaoxianCase:(NSString *)caseID{
    if ([caseID isEmpty]) {
        return;
    }
    CaseInfo *caseInfo              = [CaseInfo caseInfoForID:caseID];
    CaseProveInfo *proveInfo        = [CaseProveInfo proveInfoForCase:caseID];
    NSString *desc                  = [LawbreakingAction LawbreakingActionCaptionForID:proveInfo.case_desc_id];
    //CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    Citizen *citizen                = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:caseID];
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    inspectionRecord.roadsegment_id = caseInfo.roadsegment_id;
    inspectionRecord.location       = caseInfo.place;
    inspectionRecord.station        = caseInfo.station_start;
    inspectionRecord.inspection_id  = self.inspectionID;
    inspectionRecord.relationid     = @"0";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    inspectionRecord.start_time = caseInfo.happen_date;
    
    [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
    NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
    NSMutableString *remark=[[NSMutableString alloc] initWithFormat:@"%@ 巡至%@%@方向K%@+%@m处时，发现发生",timeString, [RoadSegment roadNameFromSegment:caseInfo.roadsegment_id], caseInfo.side, [caseInfo station_start_km], [caseInfo station_start_m]];
    //[remark appendFormat:@"%@接报，%@到场，",timeString,timeString];
    //[remark appendFormat:@"经现场勘验检查认定%@的事实为,",desc]; //NSString [alloc stringByAppendingFormat:@"经现场勘验检查认定（案由）的事实为,"
    //[remark appendString:@"经现场勘验检查认定"];
    [remark appendString:desc];
    NSArray *deformArray=[CaseDeformation deformationsForCase:caseID forCitizen:@"保险案件"];
    if (deformArray.count>0) {
        NSString *deformsString=@"";
        float   all = 0;
        for (CaseDeformation *deform in deformArray) {
            NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([roadSizeString isEmpty]) {
                roadSizeString=@"";
            } else {
                roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
            }
            NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([remarkString isEmpty]) {
                remarkString=@"";
            } else {
                remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
            }
            NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
//            NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
            all += deform.total_price.floatValue;
//            quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
            deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
        }
        NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
        deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
        //[deformsString appendFormat:@",%@。",[[NSString alloc] initWithFormat:@"%.2f",all]];
        [remark appendFormat:@"路产损失如下：%@。",deformsString];
        [remark appendFormat:@"共计金额%@元。",[[NSString alloc] initWithFormat:@"%.2f",all]];
        
        // [remark stringByAppendingFormat:@"%@接报，%@到场，",timeString,timeString];
    } else {
        [remark appendString:@"无路产损坏。"];
    }
    //[remark appendFormat:@"现场开具路产文书由事主签认。%@拖车到场，%@交警到场，%@处理完毕，已拍照，已报监控。",timeString,timeString,timeString];
    //[remark appendFormat:@"已立案处理（案号：%@高赔（%@）第（%@）号）。", [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.case_mark2, [caseInfo full_case_mark3]];
    
    
    //NSMutableString *adminis_remark=[[NSMutableString alloc] initWithFormat:@"%@,%@发现%@%@%@%@在%@%@K%@+%@m %@处%@%@。现场已制作法律文书由施工负责人签认，已拍照取证，已报监控中心。",timeString, caseInfo.case_type, citizen.address,citizen.org_name,citizen.org_principal_duty,citizen.party,  [RoadSegment roadNameFromSegment:caseInfo.roadsegment_id], caseInfo.side, [caseInfo station_start_km], [caseInfo station_start_m],caseInfo.place, desc,caseInfo.peccancy_type];
    //[adminis_remark appendFormat:@"已立案处理（案号：%@高赔（%@）第（%@）号）。", [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.case_mark2, [caseInfo full_case_mark3]];
    inspectionRecord.remark = remark;
    
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
    
}
- (void) createRecodeByServicesCheck:(ServiceCheck  *)ServicesCheck{
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    inspectionRecord.roadsegment_id = @"0";//DynamicInfo.roadsegment_id;
    inspectionRecord.fix            = @"";//DynamicInfo.fix;
    inspectionRecord.inspection_id  = self.inspectionID;
    inspectionRecord.relationid     = @"0";//DynamicInfo.myid;//@"0";
    inspectionRecord.start_time     = ServicesCheck.checkdate;
    inspectionRecord.station        = 0;//DynamicInfo.station_start;
    //NSString* stationString = [NSString stringWithFormat:@"K%d+%dM", DynamicInfo.station_start.integerValue/1000, DynamicInfo.station_start.integerValue%1000];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *remark=[NSString stringWithFormat:@"%@ 当班巡至（粤高速）S32往西%@，服务区加油站、停车场、卫生间卫生良好。",[dateFormatter stringFromDate:ServicesCheck.checkdate],ServicesCheck.servicename];
    inspectionRecord.remark = remark;
    
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
    
}
- (void) createRecodeByShiGongCheck:(NSString *)shiGongCheckID withRemark:(NSString *)Remark{
    if ([shiGongCheckID isEmpty]) {
        return;
    }
    CaseInfo *caseInfo       = [CaseInfo caseInfoForID:shiGongCheckID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:shiGongCheckID];
    NSString *desc           = [LawbreakingAction LawbreakingActionCaptionForID:proveInfo.case_desc_id];
    //CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    Citizen *citizen         = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:shiGongCheckID];
    MaintainPlanCheck *checkInfo=[[MaintainPlanCheck maintainCheckForID:shiGongCheckID] objectAtIndex:0];
    
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    
    inspectionRecord.start_time    = checkInfo.check_date;
    inspectionRecord.remark        = Remark;
    inspectionRecord.inspection_id = self.inspectionID;
    inspectionRecord.relationid    = @"0";
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
}
- (IBAction)inspectionRecordtextButtonClick:(id)sender {
    if(self.textCheckTime.text.length <= 0 || self.roadsegmentText.text.length <= 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择过站时间或路段" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if(self.roadsegmentText.text.length && self.label.text.length){
        InspectionRecord * inspectionRecord =[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
//        inspectionRecord.myid           = trafficRecord.myid;
        inspectionRecord.roadsegment_id = @"0";
//        inspectionRecord.fix            = trafficRecord.fix;
        inspectionRecord.inspection_id  = self.inspectionID;
        inspectionRecord.relationid     = @"0";
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setLocale:[NSLocale currentLocale]];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        inspectionRecord.start_time = [dateformatter dateFromString:self.textCheckTime.text];
//        inspectionRecord.station        = trafficRecord.station;
        //    [Remark createTrafficwithRemark:trafficRecord];
        NSString * remark = [NSString stringWithFormat:@"本次实际巡查路线:%@ %@",self.roadsegmentText.text,self.label.text];
        inspectionRecord.remark = remark;
        [[AppDelegate App] saveContext];
        [self reloadRecordData];
    }
}
- (IBAction)roadsegmentTextClick:(id)sender {
    UITextField * textfield = (UITextField *)sender;
    RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
    icPicker.tableView.frame    = CGRectMake(0, 0, 200, 250);
    icPicker.pickerState        = 0;
    icPicker.delegate           = self;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
    [self.pickerPopover setPopoverContentSize:CGSizeMake(200, 250)];
    [self.pickerPopover presentPopoverFromRect:textfield.frame inView:self.pathView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    icPicker.pickerPopover = self.pickerPopover;
}
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    //    self.roadSegmentID        = aRoadSegmentID;
    self.roadsegmentText.text = roadName;
    self.inspectionrecordroadsegement = roadName;
}
@end
