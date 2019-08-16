//
//  AddNewInspectRecordViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define AddNewInspectTitle @"新增巡查记录"
#import "AddNewInspectRecordViewController.h"
#import "Global.h"
#import "RoadInspectViewController.h"
#import "BridgePickerViewController.h"
#import "ServicesCheckViewController.h"
#import "ListSelectViewController.h"
#import "Systype.h"
#import "ListMutiSelectViewController.h"
#import "UserInfo.h"
#import "HelpWork.h"
#import "OrgInfo.h"
#import "NSString+MyStringProcess.h"
#import "ZLYHRoadAssetCheckViewController.h"
#import "ZLYNinInspectVC.h"
#import "ShiGongCheckViewController.h"
#import "RoadSegment.h"

@interface AddNewInspectRecordViewController ()
@property (nonatomic,retain) NSString *roadSegmentID;
@property (nonatomic,retain) NSString *bridgeID;
@property (nonatomic,retain) NSString *inspectRecordID;



- (void)keyboardWillHide:(NSNotification *)aNotification;

- (void)keyboardWillShow:(NSNotification *)aNotification;

@property (nonatomic, assign) BOOL isStartTime;

@end

@implementation AddNewInspectRecordViewController
@synthesize contentView;
@synthesize textCheckType;
@synthesize textCheckReason;
@synthesize textCheckHandle;
@synthesize textCheckStatus;
@synthesize textSide;
//@synthesize textWeather;
@synthesize textDate;
@synthesize textSegement;
//@synthesize textSide;
@synthesize textPlace;
@synthesize textStationStartKM;
@synthesize textStationStartM;
@synthesize viewNormalDesc;
@synthesize viewUnderBridgeCheck;
@synthesize textTimeStart;
//@synthesize textTimeEnd;
@synthesize textRoad;
@synthesize textPlaceNormal;
@synthesize textDescNormal;
@synthesize textViewNormalDesc;
@synthesize descState;
@synthesize isStartTime;
//@synthesize textStationEndKM;
//@synthesize textStationEndM;
@synthesize textBridgeStartTime;
@synthesize textBridgeEndTime;
@synthesize textBridgeName;
@synthesize textBridgeInspectDesc;

@synthesize textBridgeDesc;
@synthesize yzdnShiJian;
@synthesize YZDNView;
@synthesize yzdnBtn;
@synthesize yzdnBeiZhu;
@synthesize yzdnCanYuRenYuan;
@synthesize yzdnGangWei;
@synthesize yzdnGongZuoNeiRong;



- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.contentView setDelaysContentTouches:NO];
    self.descState = kAddNewRecord;
    [self.viewNormalDesc setHidden:YES];
    [self.viewUnderBridgeCheck setHidden:YES];
    [self.yzdnBtn addTarget:self action:@selector(btnYiZhuanDuoNeng:) forControlEvents:UIControlEventTouchUpInside];
    [self.YZDNView setHidden:YES];
    
    //    [self.yzdnShiJian addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventAllTouchEvents];
    //    [self.yzdnGangWei addTarget:self action:@selector(selectGangwei:) forControlEvents:UIControlEventTouchDown];
    //    [self.yzdnCanYuRenYuan addTarget: self action:@selector(selectMutiPeople:) forControlEvents:UIControlEventTouchDown];
    //[self.yzdnShiJian setTag:100];
    //[self.yzdnShiJian addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // NSDate *temp=[dateFormatter dateFromString:date];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.textDate.text=[dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.textTimeStart.text =[dateFormatter stringFromDate:[NSDate date]];
    self.textBridgeStartTime.text = [dateFormatter stringFromDate:[NSDate date]];
    self.textBridgeEndTime.text=[dateFormatter stringFromDate:[NSDate date]];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.contentView setContentSize:self.contentView.frame.size];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect    = [aValue CGRectValue];
    int height             = keyboardRect.size.height;
    if (self.descState == kAddNewRecord) {
        [self.contentView setContentSize:CGSizeMake(self.contentView.frame.size.width,self.contentView.frame.size.height+height)];
    }
    if (self.descState == kYiZhuanDuoNeng) {
        [self.YZDNView setContentSize:CGSizeMake(self.contentView.frame.size.width,self.contentView.frame.size.height+height)];
    }
}


- (void)viewDidUnload
{
    [self setTextCheckType:nil];
    [self setTextCheckReason:nil];
    [self setTextCheckHandle:nil];
    [self setTextCheckStatus:nil];
    [self setPickerPopover:nil];
    [self setCheckTypeID:nil];
    //    [self setTextWeather:nil];
    [self setTextDate:nil];
    [self setTextSegement:nil];
    [self setTextPlace:nil];
    [self setTextStationStartKM:nil];
    [self setTextStationStartM:nil];
    //    [self setTextStationEndKM:nil];
    //    [self setTextStationEndM:nil];
    [self setRoadSegmentID:nil];
    [self setContentView:nil];
    [self setViewNormalDesc:nil];
    [self setTextTimeStart:nil];
    //    [self setTextTimeEnd:nil];
    [self setTextRoad:nil];
    [self setTextPlaceNormal:nil];
    [self setTextDescNormal:nil];
    [self setTextViewNormalDesc:nil];
    [self setTextSide:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//无异常情况按钮事件
- (IBAction)btnSwitch:(UIButton *)sender {
    if (self.descState != kNormalDesc)   {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonSwitch setTitle:@"返回" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"返回" forState:UIControlStateHighlighted];
                             self.navigationController.title=@"无异常情况";
                             [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateNormal];
                             [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateHighlighted];
                             [self.yzdnBtn setTitle:@"一专多能" forState:UIControlStateNormal];
                             
                             [self.viewNormalDesc setHidden:NO];
                             [self.view bringSubviewToFront:self.viewNormalDesc];
                             [self.contentView setHidden:YES];
                             [self.viewUnderBridgeCheck setHidden:YES];
                         }
                         completion:nil];
        self.descState = kNormalDesc;
    } else  {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             self.navigationController.title = AddNewInspectTitle;
                             [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateNormal];
                             [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateHighlighted];
                             [self.contentView setHidden:NO];
                             [self.view bringSubviewToFront:self.contentView];
                             [self.viewNormalDesc setHidden:YES];
                             [self.viewUnderBridgeCheck setHidden:YES];
                         }
                         completion:nil];
        self.isStartTime = YES;
        self.descState   = kAddNewRecord;
    }
}
//桥下检查 按钮事件
- (IBAction)btntoUnderBridgeCheck:(UIButton *)sender {
    if (self.descState !=kUnderBridgeCheck) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonToUnderBridgeCheck setTitle:@"返回" forState:UIControlStateNormal];
                             [self.uibuttonToUnderBridgeCheck setTitle:@"返回" forState:UIControlStateHighlighted];
                             self.navigationController.title=@"桥下检查";
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             [self.yzdnBtn setTitle:@"一专多能" forState:UIControlStateNormal];
                             [self.viewUnderBridgeCheck setHidden:NO];
                             [self.view bringSubviewToFront:self.viewUnderBridgeCheck];
                             [self.contentView setHidden:YES];
                             [self.viewNormalDesc setHidden:YES];
                         }
                         completion:nil];
        self.descState = kUnderBridgeCheck;
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateNormal];
                             [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateHighlighted];
                             
                             self.navigationController.title = AddNewInspectTitle;
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             [self.contentView setHidden:NO];
                             [self.view bringSubviewToFront:self.contentView];
                             [self.viewUnderBridgeCheck setHidden:YES];
                             [self.viewNormalDesc setHidden:YES];
                         }
                         completion:nil];
        self.isStartTime = YES;
        self.descState   = kAddNewRecord;
    }
}
//一专多能 按钮事件
- (IBAction)btnYiZhuanDuoNeng:(UIButton *)sender{
    if(self.descState!=kYiZhuanDuoNeng){
        self.descState = kYiZhuanDuoNeng;
        [UIView animateWithDuration:0.3 animations:^{
            [self.yzdnBtn setTitle:@"返回" forState:UIControlStateNormal];
            [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
            [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateNormal];
            [self.contentView setHidden:YES];
            [self.viewUnderBridgeCheck setHidden:YES];
            [self.viewNormalDesc setHidden:YES];
            [self.YZDNView setHidden:NO];
            self.navigationController.title=@"一专多能  ";
        } completion:nil];
    }else{
        self.descState                  = kAddNewRecord;
        self.navigationController.title = AddNewInspectTitle;
        [self.yzdnBtn setTitle:@"一专多能" forState:UIControlStateNormal];
        [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
        [self.uibuttonToUnderBridgeCheck setTitle:@"桥下检查" forState:UIControlStateNormal];
        [self.contentView setHidden:NO];
        [self.viewUnderBridgeCheck setHidden:YES];
        [self.viewNormalDesc setHidden:YES];
        [self.YZDNView setHidden:YES];
    }
    
}

- (IBAction)btnDismiss:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSave:(id)sender {
    if (self.descState == kAddNewRecord) {
        BOOL isBlank = NO;
        //        for (id obj in self.contentView.subviews) {
        //            if ([obj isKindOfClass:[UITextField class]]) {
        //                if ([[(UITextField *)obj text] isEmpty]) {
        //
        //                    if ([obj tag] < 111 ) {
        //                        isBlank=YES;
        //                    }
        //                }
        //            }
        //        }
        if ([self.textDate.text isEmpty]
            || [self.textStationStartM.text isEmpty]
            || [self.textSide.text isEmpty]
            || [self.textStationStartKM.text isEmpty]
            || [self.textCheckType.text isEmpty]
            || [self.textSegement.text isEmpty]
            || [self.textPlace.text isEmpty]
            ) {
            isBlank = YES;
        }
        if (!isBlank) {
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            inspectionRecord.fix             = self.textSide.text;
            inspectionRecord.inspection_type = self.textCheckType.text;
            inspectionRecord.inspection_item = self.textCheckReason.text;
            inspectionRecord.location        = self.textPlace.text;
            inspectionRecord.measure         = self.textCheckHandle.text;
            inspectionRecord.status          = self.textCheckStatus.text;
            inspectionRecord.inspection_id   = self.inspectionID;
            inspectionRecord.relationid      = @"0";
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            inspectionRecord.start_time=[dateFormatter dateFromString:self.textDate.text];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            
            NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
            NSString *remark=@"";
            if([self.textStationEndKM.text isEmpty]&&[self.textStationEndM.text isEmpty]){
                remark=[[NSString alloc] initWithFormat:@"%@ 巡至%@%@K%02d+%03dM处时，在公路%@%@，巡逻班组%@。",timeString,self.textSegement.text,self.textSide.text,self.textStationStartKM.text.integerValue,self.textStationStartM.text.integerValue,self.textPlace.text,self.textCheckReason.text,self.textCheckStatus.text];
            }
            else{
                remark=[[NSString alloc] initWithFormat:@"%@ 巡至%@%@K%02d+%03dM与K%02d+%03dM之间时，在公路%@%@，巡逻班组%@。",timeString,self.textSegement.text,self.textSide.text,self.textStationStartKM.text.integerValue,self.textStationStartM.text.integerValue,self.textStationEndKM.text.integerValue,self.textStationEndM.text.integerValue,self.textPlace.text,self.textCheckReason.text,self.textCheckStatus.text];
            }
            self.textCheckHandle.text=[self.textCheckHandle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![self.textCheckHandle.text isEmpty]) {
                remark=[remark stringByAppendingFormat:@"%@。",self.textCheckHandle.text];
            }
            inspectionRecord.station=@(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue);
            inspectionRecord.remark = remark;
            [[AppDelegate App] saveContext];
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if(self.descState == kNormalDesc) {
        BOOL isBlank = NO;
        for (id obj in self.viewNormalDesc.subviews) {
            if ([obj isKindOfClass:[UITextField class]]) {
                if ([[(UITextField *)obj text] isEmpty]) {
                    isBlank = YES;
                }
            }
        }
        if (!isBlank) {
            if ([self.textViewNormalDesc.text isEmpty]) {
                self.textViewNormalDesc.text = [NSString stringWithFormat:@"%@ 巡查%@%@，%@",self.textTimeStart.text,self.textRoad.text,self.textPlaceNormal.text,self.textDescNormal.text];
            }
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            inspectionRecord.fix             = self.textPlaceNormal.text;
            inspectionRecord.inspection_type=@"日常巡查";
            inspectionRecord.inspection_item = @"无异常";
            inspectionRecord.location        = self.textPlaceNormal.text;
            inspectionRecord.measure=@"";
            inspectionRecord.status=@"";
            inspectionRecord.inspection_id   = self.inspectionID;
            inspectionRecord.relationid      = @"0";
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            inspectionRecord.start_time = [dateFormatter dateFromString:self.textTimeStart.text];
            inspectionRecord.remark     = [self.textViewNormalDesc.text stringByReplacingOccurrencesOfString:[self.textViewNormalDesc.text substringToIndex:11] withString:@"" ];
            [[AppDelegate App] saveContext];
            self.inspectRecordID = inspectionRecord.myid;
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
        }
    }else if(self.descState==kUnderBridgeCheck){
        BOOL isBlank = NO;
        if (//[self.textBridgeDesc.text isEmpty]||
            [self.textBridgeEndTime.text isEmpty]
            || [self.textBridgeInspectDesc.text isEmpty]
            || [self.textBridgeName.text isEmpty]
            || [self.textBridgeStartTime.text isEmpty]
            ) {
            isBlank = YES;
        }
        if (!isBlank) {
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            inspectionRecord.inspection_id = self.inspectionID;
            inspectionRecord.relationid    = self.bridgeID;
            inspectionRecord.relationType=@"桥下检查";
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            inspectionRecord.start_time = [dateFormatter dateFromString:self.textBridgeStartTime.text];
            inspectionRecord.end_time=[dateFormatter dateFromString:self.textBridgeEndTime.text];;
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString*startTimeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
            NSString*endTimeString=[dateFormatter stringFromDate:inspectionRecord.end_time];
            
            inspectionRecord.remark     =[NSString stringWithFormat:@"%@至%@ 当班人员巡查%@，%@",startTimeString,endTimeString,self.textBridgeName.text,self.textBridgeDesc.text];
//            inspectionRecord.remark     =[NSString stringWithFormat:@"%@至%@ 当班人员巡查%@%@",startTimeString,endTimeString,self.textBridgeName.text,self.textBridgeInspectDesc.text];
            //[self.textBridgeInspectDesc.text stringByReplacingOccurrencesOfString:[self.textBridgeInspectDesc.text substringToIndex:11] withString:@"" ];
            [[AppDelegate App] saveContext];
            self.inspectRecordID = inspectionRecord.myid;
            //[self setxxx:self.inspectRecordID];
            //[self setInspectionRecordID:self.inspectRecordID];
            // self
            //NSLog(self.setInspectionRecordId: self.inspectionRecordID);
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
            // [self dismissModalViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    else if (self.descState==kYiZhuanDuoNeng){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        
        HelpWork *hw  = [HelpWork newDataObjectWithEntityName:@"HelpWork"];
        hw.duty       = self.yzdnGangWei.text;
        hw.happen_date=[dateFormatter dateFromString:self.yzdnShiJian.text];
        hw.isuploaded=@(0);
        hw.org_id=[[OrgInfo orgInfoForSelected] valueForKey:@"myid"];
        hw.username   = self.yzdnCanYuRenYuan.text;
        hw.do_content = self.yzdnGongZuoNeiRong.text;
        hw.remark     = self.yzdnBeiZhu.text;
        hw.myid=[NSString randomID];
        [[AppDelegate App] saveContext];
        
        InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
        inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
        inspectionRecord.inspection_id = self.inspectionID;
        inspectionRecord.relationid    = hw.myid;
        inspectionRecord.relationType=@"一专多能";
        
        inspectionRecord.start_time = hw.happen_date;
        
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString* timeString=[dateFormatter stringFromDate: hw.happen_date  ];
        inspectionRecord.remark=[NSString stringWithFormat:@"%@ 当班人员%@开展“岗位互动.一专多能”，在%@%@工作。%@",timeString,self.yzdnCanYuRenYuan.text,self.yzdnGangWei.text,self.yzdnGongZuoNeiRong.text,self.yzdnBeiZhu.text];         [[AppDelegate App] saveContext];
        self.inspectRecordID = inspectionRecord.myid;
        
        //[self setxxx:self.inspectRecordID];
        //[self setInspectionRecordID:self.inspectRecordID];
        // self
        //NSLog(self.setInspectionRecordId: self.inspectionRecordID);
        [self.delegate reloadRecordData];
        [self.delegate addObserverToKeyBoard];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

//弹窗
- (void)pickerPresentPickerState:(InspectionCheckState)state fromRect:(CGRect)rect{
    if ((state==self.pickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.pickerState     = state;
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState = state;
        icPicker.checkTypeID = self.checkTypeID;
        icPicker.delegate    = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        if (self.descState == kAddNewRecord) {
            rect                 = [self.view convertRect:rect fromView:self.contentView];
        } else {
            rect = [self.view convertRect:rect fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        icPicker.pickerPopover = self.pickerPopover;
    }
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState = state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame    = CGRectMake(0, 0, 150, 243);
        icPicker.pickerState        = state;
        icPicker.delegate           = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:rect fromView:self.contentView];
        } else {
            rect = [self.view convertRect:rect fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover = self.pickerPopover;
    }
}

//桥梁选择弹窗
- (void)BridgePickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.bridgePickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.bridgePickerState   = state;
        BridgePickerViewController *icPicker=[[BridgePickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame = CGRectMake(0, 0, 250, 243);
        icPicker.pickerState     = state;
        icPicker.delegate        = self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(250, 243)];
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:rect fromView:self.contentView];
        } else {
            rect = [self.view convertRect:rect fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover = self.pickerPopover;
    }
}

- (IBAction)textTouch:(UITextField *)sender {
    switch (sender.tag) {
        case 100:{
            //时间选择
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate   = self;
                datePicker.pickerType = 1;
                // [datePicker showdate:self.textDate.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                CGRect rect;
                if (self.descState == kAddNewRecord) {
                    rect = [self.view convertRect:sender.frame fromView:self.contentView];
                } else {
                    rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
                }
                [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover = self.pickerPopover;
            }
        }
            break;
        case 102:
            [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:sender.frame];
            break;
        case 103:
            [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:sender.frame];
            break;
        case 104:
            [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:sender.frame];
            break;
        case 109:
            [self pickerPresentPickerState:kCheckType fromRect:sender.frame];
            break;
        case 110:
            [self pickerPresentPickerState:kCheckReason fromRect:sender.frame];
            break;
        case 111:
            [self pickerPresentPickerState:kCheckStatus fromRect:sender.frame];
            break;
        case 112:
            [self pickerPresentPickerState:kCheckHandle fromRect:sender.frame];
            break;
        default:
            break;
    }
}
- (IBAction)BridgeTouch:(UITextField *)sender{
    //桥下检查
    if (sender.tag == 101) {
        self.isStartTime = YES;
    }
    if (sender.tag == 102) {
        self.isStartTime = NO;
    }
    switch (sender.tag) {
        case 101:{
            //时间选择
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate   = self;
                datePicker.pickerType = 1;
                [datePicker showdate:self.textBridgeStartTime.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                CGRect rect;
                if (self.descState == kAddNewRecord) {
                    rect = [self.view convertRect:sender.frame fromView:self.contentView];
                } else {
                    rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
                }
                [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover = self.pickerPopover;
            }
        }
            break;
        case 102:{
            //时间选择
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate   = self;
                datePicker.pickerType = 1;
                [datePicker showdate:self.textBridgeEndTime.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                CGRect rect;
                if (self.descState == kAddNewRecord) {
                    rect = [self.view convertRect:sender.frame fromView:self.contentView];
                } else {
                    rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
                }
                [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover = self.pickerPopover;
            }
        }
            break;
        case 103:
            [self BridgePickerPresentPickerState:kBridgeName fromRect:sender.frame];
            break;
        case 104:
            [self BridgePickerPresentPickerState:kBridgeDesc fromRect:sender.frame];
            break;
        case 109:
            [self pickerPresentPickerState:kCheckType fromRect:sender.frame];
            break;
        case 110:
            [self pickerPresentPickerState:kCheckReason fromRect:sender.frame];
            break;
        case 111:
            [self pickerPresentPickerState:kCheckStatus fromRect:sender.frame];
            break;
        case 112:
            [self pickerPresentPickerState:kCheckHandle fromRect:sender.frame];
            break;
        default:
            break;
    }
    
}


- (IBAction)toCaseView:(id)sender {
    //UIViewController *caseView = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseView"];
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
    [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"inspectToCaseView" sender:self];
}
-(void)btnToShiGongCheck:(UIButton *)sender{
    //施工检查 施工检查跳转
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ShiGongCheckViewController * ShiGongCheck = [mainstoryboard instantiateViewControllerWithIdentifier:@"shigongcheck"];
//        ShiGongCheck.roadInspectVC = ((RoadInspectViewController*)self.delegate);
        ShiGongCheck.inspectionID = self.inspectionID;
        [((RoadInspectViewController*)self.delegate).navigationController pushViewController:ShiGongCheck animated:YES];
    }];
}
- (IBAction)toUnderBridgeCheck:(id)sender {
    //UIViewController *caseView = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseView"];
    if(self.inspectRecordID == nil || [self.inspectRecordID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先保存" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    
    /*UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
     [next setValue:self.inspectRecordID forKey:@"constructionId"];
     [self.navigationController pushViewController:next animated:YES]; */
    
    
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
    [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toUnderBridgeCheck" sender:self];
    
    
    //
    //    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    //    [next setValue:self.inspectRecordID forKey:@"constructionId"];
    //    [self.navigationController pushViewController:next animated:YES];
    
    
}
//-(NSString*) setInspectionRecordId {
//    return self.inspectRecordID;
//}insepectToAdminisCaseView
- (IBAction)toAdminidtrativeCaseView:(id)sender{
    //UIViewController *caseView = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseView"];
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
    [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"insepectToAdminisCaseView" sender:self];
}
- (IBAction)toAttachmentView:(id)sender {
    if(self.inspectRecordID == nil || [self.inspectRecordID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先保存" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    UIStoryboard *board            = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    [next setValue:self.inspectRecordID forKey:@"constructionId"];
    [self.navigationController pushViewController:next animated:YES];
}

- (IBAction)selectGangwei:(UITextField *)sender {
    ListSelectViewController *listselectervc=[[ListSelectViewController alloc]init];
    listselectervc.data=[Systype typeValueForCodeName:@"一专多能岗位"];
    listselectervc.delegate = self;
    if([self.pickerPopover isPopoverVisible]){
        [self.pickerPopover dismissPopoverAnimated:YES];
        self.pickerPopover = nil;
        
    }else{
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:listselectervc];
        listselectervc.pickerPopover = self.pickerPopover;
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.YZDNView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}
- (void)setSelectData:(NSString *)data{
    self.yzdnGangWei.text = data;
}

- (IBAction)selectMutiPeople:(UITextField *)sender {
    if([self.pickerPopover isPopoverVisible]){
        [self.pickerPopover dismissPopoverAnimated:YES];
        self.pickerPopover = nil;
    }else{
        /*
         ListMutiSelectViewController *mutiselectvc=[[ListMutiSelectViewController alloc]init];
         //UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:mutiselectvc];
         mutiselectvc.data=[[UserInfo allUserInfo] valueForKey:@"username"];
         mutiselectvc.setDataCallback=^(NSArray*dataArray){
         NSString *resultString=@"";
         int leng = dataArray.count;
         if(leng>0){
         for (int i   = 0; i<leng; i++) {
         UserInfo *user=[dataArray objectAtIndex:i];
         if(i==0){
         resultString = [resultString stringByAppendingString: user.username];
         }
         else{
         resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@",%@", user.username]];
         }
         }
         }
         self.yzdnCanYuRenYuan.text = resultString;
         };
         
         */
        
        CaseDescListViewController *mutiselectvc=[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"caseDescListPicker"];
        mutiselectvc.delegate = self;
        
        self.pickerPopover   = [[UIPopoverController alloc]initWithContentViewController:mutiselectvc];
        mutiselectvc.popOver = self.pickerPopover;
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.YZDNView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}
-(NSArray *)getCaseDescArrayDelegate{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    NSArray* names = [[UserInfo allUserInfo] valueForKey:@"username"];
    for( NSString *adesc in names){
        CaseDescString *cds = [[CaseDescString alloc] init];
        cds.caseDesc        = adesc;
        cds.caseDescID      = adesc;
        cds.isSelected      = NO;
        [tempArray addObject:cds];
    }
    return  tempArray;
}
-(void)setCaseDescArrayDelegate:(NSArray *)aCaseDescArray{
    // self.caseDescArray=aCaseDescArray;
    NSString *caseFullDesc=@"";
    for (CaseDescString *temp in aCaseDescArray) {
        if (temp.isSelected) {
            if ([caseFullDesc isEmpty]) {
                caseFullDesc=[caseFullDesc stringByAppendingString:temp.caseDesc];
            } else {
                caseFullDesc=[caseFullDesc stringByAppendingFormat:@"，%@",temp.caseDesc];
            }
        }
    }
    self.yzdnCanYuRenYuan.text = caseFullDesc;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"toUnderBridgeCheck"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        AttachmentViewController *receive = segue.destinationViewController;
        [receive setValue:self.inspectRecordID forKey:@"constructionId"];
        // 这里不需要指定跳转了，因为在按扭的事件里已经有跳转的代码
        //		[self.navigationController pushViewController:receive animated:YES];
    }
    if ([segue.identifier isEqualToString:@"inspectToShiGongCheck"]) {
        //施工检查跳转
        UIViewController * destvc = segue.destinationViewController;
        destvc.navigationItem.title=@"施工检查";
    }
}

#pragma mark - Delegate Implement

- (void)setCheckType:(NSString *)typeName typeID:(NSString *)typeID{
    self.checkTypeID        = typeID;
    self.textCheckType.text = typeName;
}

- (void)setCheckText:(NSString *)checkText{
    switch (self.pickerState) {
        case kCheckStatus:
            self.textCheckStatus.text = checkText;
            break;
        case kCheckHandle:
            self.textCheckHandle.text = checkText;
            break;
        case kCheckReason:
            self.textCheckReason.text = checkText;
            break;
        case kDescription:
            self.textDescNormal.text = checkText;
            break;
        default:
            break;
    }
}

- (void)setDate:(NSString *)date{
    if (self.descState == kAddNewRecord) {
        self.textDate.text = date;
    } else if(self.descState == kNormalDesc) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString=[dateFormatter stringFromDate:temp];
        if (self.isStartTime) { self.textTimeStart.text = dateString;}
        //else { self.textTimeEnd.text = dateString;}
    }
    else if(self.descState==kUnderBridgeCheck){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString=[dateFormatter stringFromDate:temp];
        if (self.isStartTime) {
            self.textBridgeStartTime.text = dateString;
            
        }
        else {
            self.textBridgeEndTime.text = dateString;
        }
        //else { self.textTimeEnd.text = dateString;}
    }
    else if (self.descState==kYiZhuanDuoNeng){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString=[dateFormatter stringFromDate:temp];
        self.yzdnShiJian.text = dateString;
    }
}

- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    if (self.descState == kAddNewRecord) {
        self.roadSegmentID     = aRoadSegmentID;
        roadName =  [RoadSegment roadNameFromSegment:aRoadSegmentID];
        self.textSegement.text = roadName;
    } else {
        self.roadSegmentID = aRoadSegmentID;
        roadName =  [RoadSegment roadNameFromSegment:aRoadSegmentID];
        self.textRoad.text = roadName;
    }
}

//无用代码。 无调用
- (void)setRoad:(NSString *)aRoadID roadName:(NSString *)roadName{
    if (self.descState == kAddNewRecord) {
        self.roadSegmentID     = aRoadID;
        roadName =  [RoadSegment roadNameFromSegment:aRoadID];
        self.textSegement.text = roadName;
    } else {
        self.roadSegmentID = aRoadID;
        roadName =  [RoadSegment roadNameFromSegment:aRoadID];
        self.textRoad.text = roadName;
    }
}
-(void) setBridge:(NSString *)aBridgeID roadName:(NSString *)raBridgeName{
    self.bridgeID            = aBridgeID;
    self.textBridgeName.text = raBridgeName;
    
}
-(void) setBridgeDesc:(NSString *)aBridgeDesc{
    self.textBridgeDesc.text        = aBridgeDesc;
    self.textBridgeInspectDesc.text = [NSString stringWithFormat:@"%@ 至 %@ 巡查%@,%@",self.textBridgeStartTime.text,self.textBridgeEndTime.text,self.textBridgeName.text,self.textBridgeDesc.text];
}

- (void)setRoadPlace:(NSString *)place{
    if (self.descState == kAddNewRecord) {
        self.textPlace.text = place;
    }
}

- (void)setRoadSide:(NSString *)side{
    if (self.descState == kAddNewRecord) {
        self.textSide.text = side;
    } else {
        self.textPlaceNormal.text = side;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==100 || textField.tag == 1001 || textField.tag == 1002) {
        return NO;
    } else
        return YES;
}

- (IBAction)btnToZlyh:(UIButton *)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        ZLYHRoadAssetCheckViewController *zlyhVC=[[ZLYHRoadAssetCheckViewController alloc]init];
        zlyhVC.inspectionID=(RoadInspectViewController*)self.inspectRecordID;
        zlyhVC.roadinspectVC=(RoadInspectViewController*)self.delegate;
        //[((RoadInspectViewController*)self.delegate).navigationController pushViewController:zlyhVC animated:YES];
        ZLYNinInspectVC *vc2=[[ZLYNinInspectVC alloc]init];
        //[((RoadInspectViewController*)self.delegate) presentViewController: vc2 animated:YES completion:nil];// vc2 animated:YES];
        //[ ((RoadInspectViewController*)self.delegate) presentModalViewController:vc2 animated:YES] ;
        //UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc2];
        vc2.inspectionID=self.inspectionID;
        vc2.modalPresentationStyle = UIModalPresentationFormSheet;
        vc2.preferredContentSize = CGSizeMake(600, 500);
        vc2.popoverPresentationController.sourceView =((RoadInspectViewController*)self.delegate).inspectionSeg;
        vc2.popoverPresentationController.sourceRect =((RoadInspectViewController*)self.delegate).view.bounds;
        vc2.delegate=self.delegate;
        [((RoadInspectViewController*)self.delegate) presentViewController:vc2 animated:YES completion:^{
            
        }];
        
    }];
}

- (IBAction)btnFormNormalDesc:(id)sender {
    self.textViewNormalDesc.text = [NSString stringWithFormat:@"%@ 巡查%@%@，%@",self.textTimeStart.text,self.textRoad.text,self.textPlaceNormal.text,self.textDescNormal.text];
}
- (IBAction)btnGenerateBridgeInspectDesc:(id)sender {
    //self.textBridgeInspectDesc.text = [NSString stringWithFormat:@"%@-%@ 巡查%@,%@",self.textBridgeStartTime.text,self.textBridgeEndTime.text,self.textBridgeName.text,self.textBridgeDesc];
}

- (IBAction)btnFuwuquJiancha:(UIButton *)sender {
    
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIStoryboard *secondStoryboard               = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
        ServicesCheckViewController *servicesCheckVC = [secondStoryboard instantiateViewControllerWithIdentifier:@"servicesCheckVC"];
        servicesCheckVC.inspectionID=(RoadInspectViewController*)self.inspectRecordID;
        servicesCheckVC.roadinspectVC=(RoadInspectViewController*)self.delegate;
        [((RoadInspectViewController*)self.delegate).navigationController pushViewController:servicesCheckVC animated:YES];
        
        
    }];/*
        [self.delegate addObserverToKeyBoard];
        [self dismissViewControllerAnimated:YES completion:^{
        // [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toCounstructionChangeBack" sender:self];
        [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toServicesCheck" sender:self];
        }];v*/
}

- (IBAction)viewNormalTextTouch:(UITextField *)sender {
    if (sender.tag == 1001) {
        self.isStartTime = YES;
    }
    if (sender.tag == 1002) {
        self.isStartTime = NO;
    }
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate   = self;
        datePicker.pickerType = 1;
        if (self.isStartTime) {
            [datePicker showdate:self.textBridgeStartTime.text];
            //[datePicker showdate:self.textTimeStart.text];
        } else {
            [datePicker showdate:self.textBridgeEndTime.text];
        }
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        CGRect rect;
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:sender.frame fromView:self.contentView];
        } else {
            rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover = self.pickerPopover;
    }
}

- (IBAction)viewNormalRoadTouch:(id)sender {
    if ([sender tag] == 1003) {
        [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:[(UITextField *)sender frame]];
    }
    if ([sender tag] == 1004) {
        [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:[(UITextField *)sender frame]];
    }
}

- (IBAction)pickerNormalDesc:(id)sender {
    [self pickerPresentPickerState:kDescription fromRect:[(UITextField *)sender frame]];
}

- (IBAction)addCounstructionChangeBack:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        // [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toCounstructionChangeBack" sender:self];
        [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"inspectToBaoxianCase" sender:self];
    }];
}

- (IBAction)addTrafficRecord:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toTrafficRecord" sender:self];
    }];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.preferredContentSize = CGSizeMake(540.0, 620.0);
}

@end
