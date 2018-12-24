//
//  TrafficRecordViewController.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-9.
//
//

#import "TrafficRecordViewController.h"
#import "RoadWayClosed.h"
#import "RoadWayClosedViewController.h"
#import "InspectionConstructionCell.h"
typedef enum{
    KNULL = 0,
    KTextCar = 100,
    KTextInfocom,
    KTextFix,
    KTextProperty,
    KTextType,
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

@interface RoadWayClosedViewController ()
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (retain, nonatomic) NSMutableArray *roadWayClosedList;
@property (copy, nonatomic) NSString *roadWayClosedID;
@end

@implementation RoadWayClosedViewController {
    NSIndexPath *notDeleteIndexPath;
}
@synthesize roadWayClosedListTableView ;

- (IBAction)btnNew:(id)sender {
}

- (IBAction)btnPhoto:(id)sender {
}

- (IBAction)btnSave:(id)sender {
}
-(void) textTouch:(UITextField *)sender{}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roadWayClosedList.count;
}


//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"TrafficCell";InspectionListCell
    static NSString *CellIdentifier = @"RoadWayClosedCell";
    InspectionConstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        ;// cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    
    TrafficRecord  *constructionInfo=[self.roadWayClosedList objectAtIndex:indexPath.row];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    // cell.textLabel.text=[formatter stringFromDate:constructionInfo.inspectiondate];
    cell.textLabel.text=[formatter stringFromDate:constructionInfo.clstart];
    cell.textLabel.text=constructionInfo.car;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    NSString *local=[NSString stringWithFormat:@"K%d+%d,%@",constructionInfo.station.integerValue/1000,constructionInfo.station.integerValue%1000,constructionInfo.fix];
    /*
     [formatter setDateFormat:@"HH:mm"];
     local = [local stringByAppendingString:@"检查时间:"];
     
     */
    cell.detailTextLabel.text=local;
    
    //  [self initWithStyle:UITableViewCellStyleSubtitle];
    
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    if (constructionInfo.isuploaded.boolValue) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj;
    if(indexPath){
        obj=[self.roadWayClosedList objectAtIndex:indexPath.row];
    }else{
        if(notDeleteIndexPath){
            obj=[self.roadWayClosedList objectAtIndex:notDeleteIndexPath.row];
            indexPath = notDeleteIndexPath;
        }
    }
    if(obj){
        [self selectFirstRow:indexPath];
    }else{
        [self selectFirstRow:nil];
    }
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
        id obj=[self.roadWayClosedList objectAtIndex:indexPath.row];
        BOOL isPromulgated=[[obj isuploaded] boolValue];
        if (isPromulgated) {
            notDeleteIndexPath = indexPath;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:@"已上传信息，不能直接删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            
            
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            [context deleteObject:obj];
            [self.roadWayClosedList removeObject:obj];
            
            // InspectionConstruction *inspection = (InspectionConstruction *)obj;
            TrafficRecord *inspection =(TrafficRecord *)obj;
            NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[pathArray objectAtIndex:0];
            NSString *photoPath=[NSString stringWithFormat:@"交通事故照片/%@",inspection.myid];
            photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            [[NSFileManager defaultManager]removeItemAtPath:photoPath error:nil];
            
            [[AppDelegate App] saveContext];
            
            
            
            self.roadWayClosedID = @"";
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}


//xianshi
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    
    //[self.switchZJCLDate setTag:kUISwitchTagZJCLDate];
    //[self.switchSGCLDate setTag:kUISwitchTagSGCLDate];
   
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
    
}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:roadWayClosedListTableView didSelectRowAtIndexPath:indexPath];
}
-(void)selectFirstRow:(NSIndexPath *)indexPath{
    //当UITableView没有内容的时候，选择第一行会报错
    if([self.roadWayClosedList count]> 0){
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

@end
