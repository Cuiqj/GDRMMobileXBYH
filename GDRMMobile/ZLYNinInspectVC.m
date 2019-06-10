//
//  ZLYNinInspectVC.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/4.
//
//

#import "ZLYNinInspectVC.h"
#import "InspectionRecord.h"
#import "CaseInfoPickerViewController.h"
#import "RoadSegmentPickerViewController.h"
#import "DateSelectController.h"
typedef enum {
    kStartTime = 0,
    kEndTime
} TimeState;

@interface ZLYNinInspectVC ()<CaseIDHandler,DatetimePickerHandler>
@property (nonatomic,strong) NSString            *roadSegmentID;
@property (nonatomic,strong) UIPopoverController * caseInfoPickerpopover;
@property (nonatomic,assign) TimeState           timetype;
@end

@implementation ZLYNinInspectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissBtn:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
    
}
- (IBAction)saveBtn:(id)sender {
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
    inspectionRecord.fix           = self.textSide.text;
    inspectionRecord.station       = [NSNumber numberWithInteger: [self.textSKM.text intValue]*1000+[self.textSM.text intValue]];
    inspectionRecord.inspection_id = self.inspectionID;
    inspectionRecord.relationid    = @"0";
    inspectionRecord.relationType=@"丈量沿海";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate=[dateFormatter dateFromString:self.textStartTime.text];
    NSDate *endDate=[dateFormatter dateFromString:self.textEndTime.text];
    inspectionRecord.start_time = startDate ;
    inspectionRecord.end_time   = endDate ;
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString* timeString=[dateFormatter stringFromDate: inspectionRecord.start_time  ];
    NSString * remark = [NSString stringWithFormat:@"%@ 当班人员开展“青春足迹.丈量沿海”，徒步检查%@%@%@K%2d+%@M至K%2d+%@M路产设施、桥下空间及控制区，%@",timeString,self.textRoad.text,self.textFix.text,self.textSide.text,[self.textSKM.text intValue],self.textSM.text,[self.textEKM.text intValue],self.textEM.text,self.textRemark.text];
    if(self.textRemark.text.length>0){
        
    }else{
        remark = [NSString stringWithFormat:@"%@未发现异常情况。",remark];
    }
    inspectionRecord.remark= remark;
    [[AppDelegate App] saveContext];
    
    [[AppDelegate App]saveContext];
    [self.delegate reloadRecordData];
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setup{
    self.textStartTime.tag = 1;
    self.textEndTime.tag   = 2;
    [self.textStartTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchDown];
    [self.textEndTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchDown];
}
//选择起止时间
- (IBAction)selectTime:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    DateSelectController *datePicker=[main instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate   = self;
    datePicker.pickerType = 1;
    if ([sender tag]==1) {
        [datePicker showdate:self.textStartTime.text];
        self.timetype = kStartTime;
    } else if ([sender tag]==2) {
        [datePicker showdate:self.textEndTime.text];
        self.timetype = kEndTime;
    }
    self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    [self.caseInfoPickerpopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    datePicker.dateselectPopover = self.caseInfoPickerpopover;
}

-(void)setDate:(NSString *)date{
    if (self.timetype==kStartTime) {
        self.textStartTime.text = date;
       /* if ([self.textEndTime.text isEmpty]) {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:7];
            NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *endDate=[calendar dateByAddingComponents:components toDate:[dateFormatter dateFromString:date] options:0];
            self.textStartTime.text=[dateFormatter stringFromDate:endDate];
        }*/
    } else {
        self.textEndTime.text = date;
    }
}
//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    {
        
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame = CGRectMake(0, 0, 150, 243);
        icPicker.pickerState     = state;
        icPicker.delegate        = self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(150, 243)];
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover = self.caseInfoPickerpopover;
    }
}
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    self.roadSegmentID = aRoadSegmentID;
    self.textRoad.text = roadName;
}
- (void)setRoadPlace:(NSString *)place{
    self.textSide.text = place;
}

- (void)setRoadSide:(NSString *)side{
    self.textFix.text = side;
}

- (IBAction)selectRoad:(id)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:((UIButton*)sender).frame];
}

- (IBAction)selectFix:(id)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:((UIButton*)sender).frame];
}

- (IBAction)selectSide:(id)sender {
    [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:((UIButton*)sender).frame];
}
@end
