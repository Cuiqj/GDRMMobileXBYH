//
//  BridgeSpaceCheckSpecial.m
//  GDRMXBYHMobile
//
//  Created by admin on 2019/7/22.
//

#import "BridgeSpaceCheckSpecial.h"

@implementation BridgeSpaceCheckSpecial

@dynamic myid;
@dynamic check_project;
@dynamic check_content;
@dynamic check_require;
@dynamic check_result;
@dynamic b_id;
@dynamic bsd_id;
@dynamic isuploaded;

+(BridgeSpaceCheckSpecial *)BridgeSpaceCheckSpecialForCase:(NSString *)caseID addforb_id:(NSString *)smallID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"BridgeSpaceCheckSpecial" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bsd_id == %@ && b_id ==%@",caseID,smallID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult && fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}
+(NSArray *)caseBridgeSpaceCheckSpecialForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"BridgeSpaceCheckSpecial" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity    = entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bsd_id == %@",caseID];
    fetchRequest.predicate = predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (BridgeSpaceCheckSpecial *)newDataObjectWithEntityNameforcaseID:(NSString *)caseID addBiaoShiID:(NSString *)smallID  addresult:(NSString *)result{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"BridgeSpaceCheckSpecial" inManagedObjectContext:context];
    BridgeSpaceCheckSpecial * obj = [[NSClassFromString(@"BridgeSpaceCheckSpecial") alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    //    if ([obj respondsToSelector:@selector(setbsd_id:)]) {
    //        [obj setValue:caseID forKey:@"bsd_id"];
    //    }
    if ([obj respondsToSelector:@selector(isuploaded)]) {
        [obj setValue:@(NO) forKey:@"isuploaded"];
    }
    obj.bsd_id = caseID;
    obj.myid = caseID;
    obj.b_id = smallID;
    obj.check_result = result;
    [[AppDelegate App] saveContext];
    return obj;
}

@end
