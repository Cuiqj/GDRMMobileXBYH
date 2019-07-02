//
//  EveryShiftViewController.m
//  GDRMXBYHMobile
//
//  Created by admin on 2019/6/17.
//

#import "Inspection_Main.h"
#import "EveryShiftViewController.h"
#import "Inspection.h"

@interface EveryShiftViewController ()

@property (nonatomic,retain) Inspection_Main * inspectioneveryshift;

@end

@implementation EveryShiftViewController

- (void)viewDidLoad {
    //    scrollview未设置   故事板里含有
    [super viewDidLoad];
    self.title = @"本班次巡查信息汇总";
    //    scrollview.contentSize =   CGSizeMake(900, );
    //显示时间
    self.inspectioneveryshift = [Inspection_Main Inspection_MainForinspection_id:self.InspectionID];
    [self setdateforinspectioneveryshift];
    if (self.inspectioneveryshift == nil) {
        
    }else{
        [self loadinitdata];
    }

    
    
//    "date_inspection" = "2019-06-19 18:49:00 +0000";
//    myid = 190618153511617;
//    "time_start" = "2019-06-19 18:49:00 +0000";
    

    // Do any additional setup after loading the view.
}

- (void)setdateforinspectioneveryshift{
    if (self.inspectioneveryshift.date_inspection) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        //        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.textdate_inspection.text = [dateFormatter stringFromDate:self.inspectioneveryshift.date_inspection];
    }else if (self.InspectionID.length >0) {
        Inspection * inspection = [Inspection oneDatainspectionForID:self.InspectionID];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.textdate_inspection.text = [dateFormatter stringFromDate:inspection.date_inspection];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)DeleteDataClick:(id)sender {
    //删除表中 的某一项 指定数据   删除数据
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    if(self.inspectioneveryshift != nil){
        [context deleteObject:self.inspectioneveryshift];
    }else{
        
    }
    [[AppDelegate App] saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)BtnSaveDataClick:(id)sender {
    if (self.inspectioneveryshift == nil) {
        self.inspectioneveryshift = [Inspection_Main newDataObjectWithEntityName:@"Inspection_Main"];
        self.inspectioneveryshift.inspection_id = self.InspectionID;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.inspectioneveryshift.date_inspection = [dateFormatter dateFromString:self.textdate_inspection.text];
    }
    //保存除日期之外的所有显示数据
    [self btnSaveeveryshiftdata];
}

- (void)loadinitdata{
    //展示除日期外的所有数据
    self.textinspection_mile.text = self.inspectioneveryshift.inspection_mile;
    self.textinspection_man_num.text = self.inspectioneveryshift.inspection_man_num;
    self.textaccident_num.text = self.inspectioneveryshift.accident_num;
    self.textdeal_accident_num.text = self.inspectioneveryshift.deal_accident_num;
    self.textdeal_bxlp_num.text  = self.inspectioneveryshift.deal_bxlp_num;
    self.textfxqx.text = self.inspectioneveryshift.fxqx;
    self.textfxwfxw.text = self.inspectioneveryshift.fxwfxw;
    self.textjzwfxw.text = self.inspectioneveryshift.jzwfxw;
    self.textcllmzaw.text = self.inspectioneveryshift.cllmzaw;
    self.textbzgzc.text = self.inspectioneveryshift.bzgzc;
    self.textjcsgd.text = self.inspectioneveryshift.jcsgd;
    self.textgzzfj.text = self.inspectioneveryshift.gzzfj;
    self.textfcflws.text = self.inspectioneveryshift.fcflws;
    self.textqlxr.text = self.inspectioneveryshift.qlxr;
}

- (void)btnSaveeveryshiftdata{
    self.inspectioneveryshift.inspection_mile = self.textinspection_mile.text;
    self.inspectioneveryshift.inspection_man_num = self.textinspection_man_num.text;
    self.inspectioneveryshift.accident_num =  self.textaccident_num.text;
    self.inspectioneveryshift.deal_accident_num = self.textdeal_accident_num.text;
    self.inspectioneveryshift.deal_bxlp_num = self.textdeal_bxlp_num.text;
    self.inspectioneveryshift.fxqx = self.textfxqx.text;
    self.inspectioneveryshift.fxwfxw = self.textfxwfxw.text;
    self.inspectioneveryshift.jzwfxw = self.textjzwfxw.text;
    self.inspectioneveryshift.cllmzaw = self.textcllmzaw.text;
    self.inspectioneveryshift.bzgzc = self.textbzgzc.text;
    self.inspectioneveryshift.jcsgd = self.textjcsgd.text;
    self.inspectioneveryshift.gzzfj = self.textgzzfj.text;
    self.inspectioneveryshift.fcflws = self.textfcflws.text;
    self.inspectioneveryshift.qlxr = self.textqlxr.text;
    
}
@end
