//
//  Inspection.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-26.
//
//

#import "Inspection.h"


@implementation Inspection

@dynamic carcode;
@dynamic classe;
@dynamic date_inspection;
@dynamic delivertext;
@dynamic duty_leader;
@dynamic inspection_description;
@dynamic inspection_milimetres;
@dynamic inspection_place;
@dynamic inspectionor_name;
@dynamic isdeliver;
@dynamic isuploaded;
@dynamic myid;
@dynamic organization_id;
@dynamic recorder_name;
@dynamic remark;
@dynamic time_end;
@dynamic time_start;
@dynamic weather;
@dynamic fuzeren;
@dynamic yjsx;
@dynamic yjzb;
@dynamic yjr;
@dynamic jsr;
@dynamic yjsj;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

+ (NSArray *)inspectionForID:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDS=[[NSSortDescriptor alloc] initWithKey:@"date_inspection" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDS]];
    [fetchRequest setEntity:entity];
    if (![inspectionID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"myid == %@",inspectionID]];
    } else {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"isdeliver.boolValue == YES"]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}

/*add by lxm
 *  新增删除历史巡查
 *
 *
 + (void)deleteInspectionForID:(NSString *)inspectionID withHistoryID:(NSString *)historyID{
 if (inspectionID && ![inspectionID isEmpty]) {
 NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
 NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
 NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid ==%@ && document_name == %@",inspectionID,historyID];
 NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
 [fetchRequest setEntity:entity];
 [fetchRequest setPredicate:predicate];
 NSArray *temp = [context executeFetchRequest:fetchRequest error:nil];
 for (CaseDocuments *doc in temp) {
 if ([[NSFileManager defaultManager] fileExistsAtPath:doc.document_path]){
 [[NSFileManager defaultManager] removeItemAtPath:doc.document_path error:nil];
 }
 [context deleteObject:doc];
 [[AppDelegate App] saveContext];
 }
 }
 }
 */
+ (Inspection *)oneDatainspectionForID:(NSString *)ID{
    if(ID==nil) return nil;
    NSManagedObjectContext *context = [[ AppDelegate  App ] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context ];
    NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid==%@",ID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray * arr = [context executeFetchRequest:fetchRequest error:nil];
    if(arr.count>0)
        return [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    else
        return nil;
}

+(NSDate *)inspectionfortime_endsettingtimeyjsj:(NSDate *)time_end andtime_start:(NSDate *)time_start andclasse:(NSString *)classe{
    NSDate * temp;
    NSDateFormatter * matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"yyyy年MM月dd日"];
    NSString * timestring;
    if([classe containsString:@"晚班"]){
        temp = time_end;
        timestring = [NSString stringWithFormat:@"%@08时00分",[matter stringFromDate:temp]];
    }else if([classe containsString:@"早班"]){
        temp = time_start;
        timestring = [NSString stringWithFormat:@"%@16时00分",[matter stringFromDate:temp]];
    }else if([classe containsString:@"中班"]){
        temp = [NSDate dateWithTimeInterval:24*60*60 sinceDate:time_start];
        timestring = [NSString stringWithFormat:@"%@00时00分",[matter stringFromDate:temp]];
    }else{
        return time_end;
    }
    [matter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    return [matter dateFromString:timestring];
}


@end
