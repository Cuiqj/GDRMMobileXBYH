//
//  TrafficRecord.m
//  GDRMMobile
//
//  Created by coco on 13-7-8.
//
//

#import "TrafficRecord.h"


@implementation TrafficRecord

@dynamic car;
@dynamic clend;
@dynamic clstart;
@dynamic fix;
@dynamic happentime;
@dynamic myid;
@dynamic infocome;
@dynamic isend;
@dynamic lost;
@dynamic paytype;
@dynamic property;
@dynamic rel_id;
@dynamic remark;
@dynamic roadsituation;
@dynamic station;
@dynamic type;
@dynamic wdsituation;
@dynamic zjend;
@dynamic zjstart;
@dynamic isuploaded;
@dynamic iszj;
@dynamic issg;
@dynamic org_id;
@dynamic location;
@dynamic death_sum;
@dynamic badcar_sum;
@dynamic fleshwound_sum;
@dynamic badwound_sum;

@dynamic case_type;

- (NSString *) signStr{
    if (![self.rel_id isEmpty]) {
        return [NSString stringWithFormat:@"rel_id == %@", self.rel_id];
    }else{
        return @"";
    }
}
+(NSArray*)allTrafficRecord{
    
    NSManagedObjectContext *ct = [[AppDelegate App] managedObjectContext];
    NSEntityDescription *ed    = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:ct];
    NSFetchRequest *fr         = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    [fr setPredicate:nil];
    return [ct executeFetchRequest:fr error:nil];
    //    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    //    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    //    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    //    [fetchRequest setEntity:entity];
    //    [fetchRequest setPredicate:nil];
    //    return [context executeFetchRequest:fetchRequest error:nil];
}
+(TrafficRecord*)trafficRecordForID:(NSString*)ID{
    if(ID==nil) return nil;
    NSManagedObjectContext *context = [[ AppDelegate  App ] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context ];
    NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid==%@",ID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSMutableArray  * arr = [ context executeFetchRequest:fetchRequest error:nil];
    if(arr.count>0)
        return [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    else
        return nil;
}
@end
