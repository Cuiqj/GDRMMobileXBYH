//
//  MaintainCheckDaily.m
//  YUNWUMobile
//
//  Created by admin on 2018/11/2.
//

#import "MaintainCheckDaily.h"


@implementation MaintainCheckDaily
@dynamic myid;
@dynamic org;
@dynamic tel;
@dynamic date;
@dynamic direction;
@dynamic constr_org;
@dynamic constr_nature;
@dynamic constr_are;
@dynamic constr_content;
@dynamic person_saft_mark;
@dynamic work_length_require;
@dynamic constr_car_light;
@dynamic night_light;
@dynamic notice;
@dynamic approval;
@dynamic traffic_cone;
@dynamic sign_lay;
@dynamic material_stack;
@dynamic have_safe_person;
@dynamic canalization;
@dynamic have_supervise;
@dynamic have_against;
@dynamic summary;
@dynamic inspector;
@dynamic maintain_plan_id;
@dynamic isuploaded;


+(NSArray *)allMaintainCheckDailyforMaintain_planid:(NSString *)planID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSSortDescriptor *sort=[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    fetchRequest.sortDescriptors=[NSArray arrayWithObjects:sort, nil];
    [fetchRequest setEntity:entity];
    if ([planID isEmpty]) {
        [fetchRequest setPredicate:nil];
    } else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"maintain_plan_id == %@ ",planID]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}
+(MaintainCheckDaily *)maintainCheckDailyForMyid:(NSString *)myid{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid==%@",myid];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}



@end
