//
//  Inspection_Main.m
//  GDRMXBYHMobile
//
//  Created by admin on 2019/6/14.
//

#import "Inspection_Main.h"

@implementation Inspection_Main

@dynamic inspection_id;
@dynamic date_inspection;
@dynamic inspection_mile; ;
@dynamic inspection_man_num;
@dynamic accident_num;
@dynamic deal_accident_num;
@dynamic deal_bxlp_num;
@dynamic fxqx;
@dynamic fxwfxw;
@dynamic jzwfxw;
@dynamic cllmzaw;
@dynamic bzgzc;
@dynamic jcsgd;
@dynamic gzzfj;
@dynamic fcflws;
@dynamic qlxr;
@dynamic inspection_principal_content;
@dynamic inspection_principal;
@dynamic inspection_principal_sign_date;
@dynamic reporter_content;
@dynamic reporter;
@dynamic reporter_sign_date;
@dynamic note;
@dynamic org_id;
@dynamic isuploaded;

+(Inspection_Main *)Inspection_MainForinspection_id:(NSString*)inspection_id{
    if(inspection_id==nil) return nil;
    NSManagedObjectContext *context = [[ AppDelegate  App ] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context ];
    NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"inspection_id==%@",inspection_id];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray * arr = [context executeFetchRequest:fetchRequest error:nil];
    if(arr.count>0)
        return [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    else
        return nil;
}



@end
