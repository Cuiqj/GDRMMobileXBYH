//
//  AdminstrativePenaltyMapTableViewController.m
//  GDRMXBYHMobile
//
//  Created by admin on 2019/6/21.
//

#import "AdminstrativePenaltyMapTableViewController.h"
#import "CaseMap.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"

static NSString * const xmlName = @"AdminstrativePenaltyMapTable";

@interface AdminstrativePenaltyMapTableViewController ()

@end

@implementation AdminstrativePenaltyMapTableViewController
@synthesize caseDesclabel = _caseDesclabel;
@synthesize datetimelabel = _datetimelabel;
@synthesize placeadresslabel = _placeadresslabel;
@synthesize weatherlabel = _weatherlabel;
@synthesize imageview = _imageview;
@synthesize remarktextview = _remarktextview;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 900, 590);
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:@"CaseMapTable"];
    [self loadPageInfo];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload{
    [self setCaseDesclabel:nil];
    [self setDatetimelabel:nil];
    [self setPlaceadresslabel:nil];
    [self setWeatherlabel:nil];
    [self setImageview:nil];
    [self setRemarktextview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)loadPageInfo{
    CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
    if (caseMap) {
        //说明
        self.remarktextview.text = caseMap.remark;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        //绘图时间
//        self.datetimelabel.text = [dateFormatter stringFromDate:caseMap.draw_time];
        NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath=[pathArray objectAtIndex:0];
        NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseID];
        mapPath = [documentPath stringByAppendingPathComponent:mapPath];
        NSString * mapName = @"casemap.jpg";
        NSString * filePath=[mapPath stringByAppendingPathComponent:mapName];
        //现场平面图。 图片路径
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            UIImage *imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
            self.imageview.image = imageFile;
        }
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        self.datetimelabel.text = [dateFormatter stringFromDate:caseInfo.happen_date];
        NSString *locality ;
        if(caseInfo.sfz_id.integerValue>0)
            locality= [[NSString alloc] initWithFormat:@"%@高速%@%@",[[AppDelegate App].projectDictionary objectForKey:@"cityname"] ,caseInfo.side,caseInfo.place];
        else
            locality= [[NSString alloc] initWithFormat:@"%@高速%@%02dKm+%03dm%@",[[AppDelegate App].projectDictionary objectForKey:@"cityname"] ,caseInfo.side,caseInfo.station_start.integerValue/1000,caseInfo.station_start.integerValue%1000,caseInfo.place];
        //地点
        self.placeadresslabel.text = locality;
        //天气
        self.weatherlabel.text = caseInfo.weater;
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        //案由
        self.caseDesclabel.text = caseProveInfo.case_short_desc;
        //无   违章的  无路政勘查员及绘图员
//        if (caseProveInfo) {
//            self.labelProver.text = caseProveInfo.prover;
//        }
//        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
//        self.labelCitizen.text = citizen.automobile_number;
    }
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseMap];
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseProveInfo];
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
        [self drawDateTable:xmlName withDataModel:citizen];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseMap];
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseProveInfo];
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
        [self drawDateTable:xmlName withDataModel:citizen];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)pageSaveInfo{
    CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
    caseMap.remark=self.remarktextview.text ;
    [[AppDelegate App] saveContext];
    
}
- (void)deleteCurrentDoc{
    [self deletedata];
}
- (void)deletedata{
    if (![self.caseID isEmpty]){
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        if (caseMap) {
            NSManagedObjectContext * context = [[AppDelegate App] managedObjectContext];
            [context deleteObject:caseMap];
            [[AppDelegate App] saveContext];
        }
    }
}
@end
